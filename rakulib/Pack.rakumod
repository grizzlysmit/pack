unit module Pack:ver<0.1.29>:auth<Francis Grizzly Smit (grizzlysmit@smit.id.au)>;

use JSON::Fast;

use Terminal::ANSI::OO :t;
use Terminal::WCWidth;
use Terminal::Width;
use IO::Prompt;
use File::Path::Copy;
use Gzz::Text::Utils;
use Syntax::Highlighters;
use GUI::Editors;
use Usage::Utils;
use Display::Listings;
use File::Utils;
#use Grammar::Debugger;
#use Grammar::Tracer;
#use trace;

# the home dir #
constant $home is export = %*ENV<HOME>.Str();

# config files
constant $config is export = "$home/.local/share/pack";

if $config.IO !~~ :d {
    $config.IO.mkdir();
}

# The config files to test for #
my Str @path-config-files = qw{pack.p_ck};

my Str @guieditors;

my Str $client-config;

sub generate-configs(Str:D $file, Str:D $config) returns Bool:D {
    my Bool $result = True;
    CATCH {
        default { 
                $*ERR.say: .message; 
                $*ERR.say: "some kind of IO exception was caught!"; 
                my Str $content;
                given $file {
                    when 'pack.p_ck' {
                        $content = q:to/END/;
                        #Key                  sep  target # comment #

                        END
                    }
                }
                $content .=trim-trailing;
                $content ~= "\n";
                if "$config/$file".IO !~~ :e || "$config/$file".IO.s == 0 {
                    "$config/$file".IO.spurt: $content, :append;
                }
                return True;
           }
    }
    my IO::CatHandle:D $fd = "$config/$file".IO.open: :w;
    given $file {
        when 'pack.p_ck' {
            my Str $content = q:to/END/;
            #Key                  sep  target # comment #

            END
            $content .=trim-trailing;
            $content ~= "\n";
            my Bool $r = $fd.put: $content;
            "could not write $config/$file".say if ! $r;
            $result ?&= $r;
        }
    } # given $file #
    my Bool $r = $fd.close;
    "error closing file: $config/$file".say if ! $r;
    $result ?&= $r;
    return $result;
} # sub generate-configs(Str $file, Str:D $config) returns Bool:D #


my Bool:D $please-edit = False;

sub check-files(Str:D @cfg-files, Str:D $config --> Bool:D) {
    my Bool $result = True;
    for @cfg-files -> $file {
        if "$config/$file".IO !~~ :e || "$config/$file".IO.s == 0 {
            $please-edit = True;
            if "/etc/skel/.local/share/pack/$file".IO ~~ :f {
                try {
                    CATCH {
                        when X::IO::Copy { 
                            "could not copy /etc/skel/.local/share/pack/$file -> $config/$file".say;
                            my Bool $r = generate-configs($file, $config); 
                            $result ?&= $r;
                        }
                    }
                    my Bool $r = "/etc/skel/.local/share/pack/$file".IO.copy("$config/$file".IO);
                    if $r {
                        "copied /etc/skel/.local/share/pack/$file -> $config/$file".say;
                    } else {
                        "could not copy /etc/skel/.local/share/pack/$file -> $config/$file".say;
                    }
                    $result ?&= $r;
                }
            } else {
                my Bool $r = generate-configs($file, $config);
                "generated $config/$file".say if $r;
                $result ?&= $r;
            }
        }
    } # for @cfg-files -> $file # 
    return $result;
} #`« sub check-files(Str:D @cfg-files, Str:D $config --> Bool:D) »

unless init-gui-editors(@path-config-files, $config, &generate-configs, &check-files) {
    exit 1;
}

#`«««
    ##################################################################
    #                                                                #
    #    grammars for parsing pack.p_ck the packs data base file     #
    #                                                                #
    ##################################################################
#»»»

grammar Key {
    regex key { \w* [ <-[\h]>+ \w* ]* }
}

role KeyActions {
    method key($/) {
        my $k = (~$/).trim;
        make $k;
    }
}


grammar Paths {
    token path         { [ <absolute-path> || <relative-path> ] }
    token absolute-path { [ '/' | '~' | '~/' ]  <path-segments>? }
    token relative-path { <path-segments> }
    regex path-segments { <path-segment> [ '/' <path-segment> ]* '/'? }
    regex path-segment  { \w* [ [ '-' || \h || '+' || ':' || '@' || '=' || '!' || ',' || '&' || '&' || '%' || '$' || '(' || ')' '[' || ']' || '{' || '}' || ';' || '.' ]+ \w* ]* }
}

role PathsActions {
    method path($/) {
        my Str $abs-rel-path;
        if $/<absolute-path> {
            $abs-rel-path = $/<absolute-path>.made;
        } elsif $/<relative-path> {
            $abs-rel-path = $/<relative-path>.made;
        }
        make $abs-rel-path;
    }
    method absolute-path($/) {
        my Str $abs-path;
        if $/<path-segments> {
            $abs-path = ~$/.trim;
        } else {
            $abs-path = ~$/.trim;
        }
        make $abs-path;
    }
    method path-relative($/) {
        make ~$/.trim
    }
    method path-segment($/) { make $/<path-segment>.made }
    method path-segments($/) {
        #my @made-elts = $/».made;
        #make @made-elts.join('/');
    }
}

grammar PathsFile is Key is Paths {
    token TOP                 { <line> [ \v+ <line> ]* \v* }
    regex line                { [ <white-space-line> || <dir> || <header-line> || <line-of-hashes> || <comment-line> ] }
    regex white-space-line    { ^^ \h* $$ }
    token header-line         { ^^ \h* '#' <header> \h* $$ }
    token header              { 'key' \h+ 'sep' \h+ 'path' \h+ ':' \h+ '#' \h+ 'comment' }
    token line-of-hashes      { ^^ \h* '#'+ $$ }
    regex comment-line        { ^^ \h* '#' <-[\v]>* $$ }
    token dir                 { <key> \h* '=>' \h* <path> \h* [ '#' \h* <comment> \h* ]? }
    token comment             { <-[\n]>* }
}

my $line-no = 0;
class PathFileActions does KeyActions does PathsActions {
    method line($/) {
        my %line;
        if $/<white-space-line> {
            %line = $/<white-space-line>.made;
        }elsif $/<dir> {
            %line = $/<dir>.made;
        } elsif $/<header-line> {
            %line = $/<header-line>.made;
        } elsif $/<line-of-hashes> {
            %line = $/<line-of-hashes>.made;
        } elsif $/<comment-line> {
            %line = $/<comment-line>.made;
        }
        make %line;
    }
    method white-space-line($/) {
        $line-no++;
        my %white-space-line = type => 'white-space-line', line-no => $line-no, value => ~$/;
        make ~$line-no => %white-space-line;
    }
    method header-line($/) {
        $line-no++;
        my %header-line = type => 'header-line', line-no => $line-no, value => $/<header>.made;
        make ~$line-no => %header-line;
    }
    method header($/) {
        my $header = ~$/;
        make $header;
    }
    method line-of-hashes($/) {
        $line-no++;
        my %line-of-hashes = type => 'line-of-hashes', line-no => $line-no, value => ~$/;
        make '##' => %line-of-hashes;
    }
    method comment-line($/) {
        $line-no++;
        my %comment-line = type => 'comment-line', line-no => $line-no, value => ~$/;
        make ~$line-no => %comment-line;
    }
    method comment($/)   { make ~$/; }
    method dir   ($/)  {
        my %dir = type => 'dir', path => $/<path>.made;
        if $/<comment> {
            my Str $com = ~($/<comment>).trim;
            %dir«comment» = $com;
        }
        $line-no++;
        %dir«line-no» = $line-no;
        make $/<key>.made => %dir;
    }
    method target ($/) { make $/<key>.made }
    method TOP($match) {
        my %top = $match<line>.map: *.made;
        $match.make: %top;
    }
} # class PathFileActions does KeyActions does PathsActions #

grammar KeyValid is Key {
    token TOP { <key> }
}

class KeyValidAction does KeyActions {
    method TOP($/) { make $/<TOP>.made }
}

grammar Path is Paths {
    token TOP { <path> }
}

class PathValidActions does PathsActions {
    method TOP($/) { make $/<TOP>.made }
}

grammar CommentedLineStuff is Key is Paths {
    regex empty-str           { ^^ \h* $$ }
    regex comment-line        { ^^ \h* '#' <-[\v]>*  $$ }
    token row-of-hashes       { ^^ '#' ** {2 .. ∞} $$ }
    token commeted-dir-alias  { ^^ \h* '#' [ <dir-line> ] }
    regex header-line         { ^^ \h* '#' <header-line-inner> }
    regex header-line-inner   { 'key' \h+ 'sep' \h+ 'path' [ '-spec' ]? \h+ '#' \h+ 'comment' \h* }
    token dir-line            { <key> \h* '=>' \h* <path> \h* [ '#' \h* <comment> \h* ]? }
    regex comment             { <-[\n]>* }
}

role CommentedLineStuffActions does KeyActions does PathsActions {
    method comment($/)   { make $/<comment>.made }
    method empty-str($/) {
        my %e;
        my %value = type => 'empty-str', val => ~$/;
        %e = key => '', value => %value;
        make %e;
    }
    method comment-line($/) {
        my %cl;
        my %value = type => 'comment-line', val => ~$/;
        %cl = key => '#', value => %value;
        make %cl;
    }
    method dir-line   ($/)  {
        my %hl = path => $/<path>.made;
        %hl«type» = 'dir';
        if $/<comment> {
            my Str $com = ~($/<comment>).trim;
            %hl«comment» = $com;
        }
        my %res = key => $/<key>.made, value => %hl;
        make %res;
    }
    method commeted-dir-alias($/) {
        my %commeted-dir-alias;
        if $/<dir-line> {
            %commeted-dir-alias = $/<dir-line>.made;
            %commeted-dir-alias«value»«type» = 'commeted-dir';
        }
        make %commeted-dir-alias;
    }
    method row-of-hashes($/) {
        my %value = type => 'row-of-hashes', val => ~$/;
        my %row-of-hashes = key => '##', value => %value;
        make %row-of-hashes;
    }
    method header-line($/) {
        my %header-line = $/<header-line-inner>.made;
        make %header-line;
    }
    method header-line-inner($/) {
        my %value = type => 'header-line', val => '#' ~ ~$/;
        my %header-line-inner = key => '#header', value => %value;
        make %header-line-inner;
    }
    method target ($/) { make $/<key>.made }
} # role CommentedLineStuffActions does KeyActions does PathsActions #

grammar CommentedLine is CommentedLineStuff {
    regex TOP         { [ <empty-str> || <commeted-dir-alias> || <row-of-hashes> || <header-line> || <dir-line> || <comment-line> ] }
}

class CommentedLineActions does CommentedLineStuffActions {
    method TOP($match) {
        my %top;
        if $match<dir-line> {
            %top = $match<dir-line>.made;
        } elsif $match<commeted-dir-alias> {
            %top = $match<commeted-dir-alias>.made;
        } elsif $match<row-of-hashes> {
            %top = $match<row-of-hashes>.made;
        } elsif $match<header-line> {
            %top = $match<header-line>.made;
        } elsif $match<comment-line> {
            %top = $match<comment-line>.made;
        } elsif $match<empty-str> {
            %top = $match<empty-str>.made;
        }
        $match.make: %top;
    }
} # class CommentedLineActions does CommentedLineStuffActions #

grammar Stats is CommentedLineStuff {
    token TOP     { [ <line> [ \v <line> ]* \v? ] }
    regex line    { [ <empty-str> || <commeted-dir-alias> || <row-of-hashes> || <header-line> || <dir-line> || <comment-line> ] }
}

class StatsActions does CommentedLineStuffActions {
    method line($/) {
        my %line;
        if $/<dir-line> {
            %line = $/<dir-line>.made;
        } elsif $/<commeted-dir-alias> {
            %line = $/<commeted-dir-alias>.made;
        } elsif $/<row-of-hashes> {
            %line = $/<row-of-hashes>.made;
        } elsif $/<header-line> {
            %line = $/<header-line>.made;
        } elsif $/<comment-line> {
            %line = $/<comment-line>.made;
        } elsif $/<empty-str> {
            %line = $/<empty-str>.made;
        } else {
        }
        make %line;
    }
    method TOP($made) {
        my @lines = $made<line>».made;
        my %top = lines-total => @lines.elems,
        lines => @lines.values.grep( -> %val { %val«value»«type» eq 'dir' } ).elems,
        commented => @lines.values.grep( -> %val { %val«value»«type» eq 'commeted-dir' || %val«value»«type» eq 'commeted-alias' } ).elems,
        commented-dirs => @lines.values.grep( -> %val { %val«value»«type» eq 'commeted-dir' } ).elems,
        rows-of-hashes => @lines.values.grep( -> %val { %val«value»«type» eq 'row-of-hashes' } ).elems,
        header-lines => @lines.values.grep( -> %val { %val«value»«type» eq 'header-line' } ).elems,
        comment-lines => @lines.values.grep( -> %val { %val«value»«type» eq 'comment-line' } ).elems,
        empty-strs => @lines.values.grep( -> %val { %val«value»«type» eq 'empty-str' } ).elems,
        dirs => @lines.values.grep( -> %val { %val«value»«type» eq 'dir' } ).elems,
        $made.make:  %top;
    }
} # class StatsActions does CommentedLineStuffActions #

sub valid-key(Str:D $key --> Bool) is export {
    my $actions = KeyActions;
    my Str $match = KeyValid.parse($key, :rule('key'), :enc('UTF-8'), :$actions).made;
    without $match {
        return False;
    }
    return $key eq $match;
}

# the editor to use #
my Str $editor = '';
if %*ENV<GUI_EDITOR>:exists {
    $editor = %*ENV<GUI_EDITOR>.Str();
} elsif %*ENV<VISUAL>:exists {
    $editor = %*ENV<VISUAL>.Str();
} elsif %*ENV<EDITOR>:exists {
    $editor = %*ENV<EDITOR>.Str();
} else {
    my Str $gvim = qx{/usr/bin/which gvim 2> /dev/null };
    my Str $vim  = qx{/usr/bin/which vim  2> /dev/null };
    my Str $vi   = qx{/usr/bin/which vi   2> /dev/null };
    if $gvim {
        $editor = $gvim;
    } elsif $vim {
        $editor = $vim;
    } elsif $vi {
        $editor = $vi;
    }
}


my Str  @LINES     = slurp("$config/pack.p_ck").split("\n");
my Str  @lines     = @LINES.grep({ !rx/^ \h* '#' .* $/ }).grep({ !rx/^ \h* $/ });
#my Str  %the-paths = @lines.map( { my Str $e = $_; $e ~~ s/ '#' .* $$ //; $e } ).map( { $_.trim() } ).grep({ !rx/ [ ^^ \s* '#' .* $$ || ^^ \s* $$ ] / }).map: { my ($key, $value) = $_.split(rx/ \s*  '=>' \s* /, 2); my $e = $key => $value; $e };
#my Hash %the-lot   = @lines.grep({ !rx/ [ ^^ \s* '#' .* $$ || ^^ \s* $$ ] / }).map: { my $e = $_; ($e ~~ rx/^ \s* $<key> = [ \w+ [ [ '.' || '-' || '@' || '+' ]+ \w* ]* ] \s* '=>' \s* $<path> = [ <-[ # ]>+ ] \s* [ '#' \s* $<comment> = [ .* ] ]?  $/) ?? (~$<key> => { value => (~$<path>).trim, comment => ($<comment> ?? ~$<comment> !! Str), }) !! { my ($key, $value) = $_.split(rx/ \s*  '=>' \s* /, 2); my $r = $key => $value; $r } };
my $actions = PathFileActions;
my %whole-file = |(PathsFile.parse(@LINES.join("\x0A"), :enc('UTF-8'), :$actions).made);
my %the-lot = |%whole-file.kv.grep( -> $k, %v { %v«type» eq 'dir' }).map: -> @val {
                                                                                      my $ky = @val[0];
                                                                                      my %vl = |@val[1];
                                                                                      $ky => %vl
                                                                                  };
#my Hash %the-lot = PathsFile.parse(@lines.join("\n"), :enc('UTF-8'), :$actions).made;
#my Hash %the-lot   = PathsFile.parse(@lines.join("\n"), actions  => PathFileActions.new).made;


####################
#                  #
#  get the stats   #
#                  #
####################
my $statsactions = StatsActions;
my %stats;
{
    CATCH {
        default {
             $*ERR.say: .message;
             for .backtrace.full.reverse {
                 $*ERR.say: "{.file} line {.line}";
             }
            .rethrow;
        }
    }
    %stats   = Stats.parse(@LINES.join("\x0A"), :enc('UTF-8'), :actions($statsactions)).made;
}



sub resolve-dir(Str $dir, Bool $relative-to-home = True) returns Str is export {
    my Str $Dir = $dir.trim;
    #$Dir.say;
    $Dir = $home if $Dir eq '~';
    $Dir ~~ s! ^^ '~' \/ !$home\/!;
    if $Dir ~~ rx! ^^ $<start> = [ '~' <-[ \/ ]> +  ] \/ ! {
        my Str $start = ~$<start>;
        given $start {
            when '~root' { $Dir ~~ s! ^^ '~' !\/!; }
            default {
                my Str @candidates = dir('/home', test => { "/home/$_".IO.d && $_ ne '.' && $_ ne '..' }).map: { $_.Str };
                my Str $start_d = $start.substr(1);
                my Str $candidate = @candidates.grep: { rx/ \/ $start_d $$ / };
                if $candidate {
                    $Dir ~~ s! ^^ $start \/ !$candidate\/!;
                } else {
                    $*ERR.say: "cannot resolve $start";
                    return $dir;
                }
            }
        }
    }
    $Dir = "$home/$Dir" if $relative-to-home && $Dir !~~ rx! ^^ \/ !;
    #$Dir.say;
    return $Dir;
}


sub path(Str:D $go-here --> Str:D) is export {
    my Str:D $return = '';
    if %the-lot{$go-here}:exists {
        my %val        = %the-lot{$go-here};
        $return        = %val«path»;
        my Str:D $type = %val«type»;
        if $return.trim eq '' {
            return $return;
        }
        $return = resolve-dir($return);
    }
    return $return;
}

sub make-array( --> Array) is export {
    my @results;
    for %the-lot.kv -> $key, %val {
        my Str $comment = Str;
        $comment = %val«comment» with %val«comment»;
        my %row = key => $key;
        with $comment {
            %row«comment» = $comment;
        }
        #dd %row;
        @results.push(%row);
    }
    #dd @results;
    #@results = @results.map( -> %elt { %elt }).Array;
    #dd @results;
    return @results;
}

sub say-list-keys(Str $prefix,
                  Bool:D $colour,
                  Bool:D $syntax,
                  Regex:D $pattern,
                  Int:D $page-length --> Bool:D) is export {
    my @rows = make-array();
    my Str:D @fields = |qw[key comment];
    #dd @fields, @rows;
    my %defaults;
    sub include-row(Str:D $prefix, Regex:D $pattern, Int:D $idx, Str:D @fields, %row --> Bool:D) {
        for @fields -> $field {
            my Str:D $value = ~(%row{$field} // '');
            #dd $field, $value;
            return True if $value.starts-with($prefix, :ignorecase) && $value ~~ $pattern;
        }
        return False;
    } # sub include-row(Str:D $prefix, Regex:D $pattern, Int:D $idx, Str:D @fields, %row --> Bool:D) #
    sub head-value(Int:D $indx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) {
        #dd $indx, $field, $colour, $syntax, @fields;
        if $colour {
            if $syntax { 
                return t.color(0, 255, 255) ~ $field;
            } else {
                return t.color(0, 255, 255) ~ $field;
            }
        } else {
            return $field;
        }
    } # sub head-value(Int:D $indx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) #
    sub head-between(Int:D $indx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) {
        if $colour {
            if $syntax {
                given $field {
                    when 'key'     { return t.color(0, 255, 255)   ~ ' # ';   }
                    when 'comment' { return t.color(0, 0, 255)     ~ '  ';    }
                    default { return ''; }
                }
            } else {
                given $field {
                    when 'key'     { return t.color(0, 255, 255)   ~ ' # ';   }
                    when 'comment' { return t.color(0, 255, 255)   ~ '  ';    }
                    default { return ''; }
                }
            }
        } else {
            given $field {
                when 'key'     { return ' # ';   }
                when 'comment' { return '  ';    }
                default        { return '';      }
            }
        }
    } # sub head-between(Int:D $indx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) #
    sub field-value(Int:D $idx, Str:D $field, $value, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) {
        my Str:D $val = ~($value // ''); #`««« assumming $value is a Str:D »»»
        #dd $val, $value, $field;
        if $syntax {
            given $field {
                when 'key'     { return t.color(0, 255, 255) ~ $val; }
                when 'comment' { return t.color(0, 0, 255) ~ $val;   }
                default        { return t.color(255, 0, 0) ~ '';     }
            } # given $field #
        } elsif $colour {
            given $field {
                when 'key'     { return t.color(0, 0, 255) ~ $val; }
                when 'comment' { return t.color(0, 0, 255) ~ $val; }
                default        { return t.color(255, 0, 0) ~ '';   }
            }
        } else {
            given $field {
                when 'key'     { return $val;                      }
                when 'comment' { return ~$val;                     }
                default        { return '';                        }
            }
        }
    } # sub field-value(Int:D $idx, Str:D $field, $value, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) #
    sub between(Int:D $idx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) {
        if $syntax {
                given $field {
                    when 'key'     { return t.color(0, 0, 255) ~ ' # '; }
                    when 'comment' { return t.color(0, 0, 255) ~ '  ';  }
                    default        { return t.color(255, 0, 0) ~ '';    }
                }
        } elsif $colour {
                given $field {
                    when 'key'     { return t.color(0, 0, 255) ~ ' # '; }
                    when 'comment' { return t.color(0, 0, 255) ~ '  ';  }
                    default        { return t.color(255, 0, 0) ~ '';    }
                }
        } else {
                given $field {
                    when 'key'     { return ' # '; }
                    when 'comment' { return '  ';  }
                    default        { return '';    }
                }
        }
    } # sub between(Int:D $idx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) #
    sub row-formatting(Int:D $cnt, Bool:D $colour, Bool:D $syntax --> Str:D) {
        if $colour {
            if $syntax { 
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -3; # three heading lines. #
                return t.bg-color(0, 0, 127) ~ t.bold ~ t.bright-blue if $cnt == -2;
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -1;
                return (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,195,0)) ~ t.bold ~ t.bright-blue;
            } else {
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -3;
                return t.bg-color(0, 0, 127) ~ t.bold ~ t.bright-blue if $cnt == -2;
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -1;
                return (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,195,0)) ~ t.bold ~ t.bright-blue;
            }
        } else {
            return '';
        }
    } # sub row-formatting(Int:D $cnt, Bool:D $colour, Bool:D $syntax --> Str:D) #
    return list-by($prefix, $colour, $syntax, $page-length,
                  $pattern, @fields, %defaults, @rows,
                  :&include-row, 
                  :&head-value, 
                  :&head-between,
                  :&field-value, 
                  :&between,
                  :&row-formatting);
} # sub say-list-keys(Str $prefix, Bool:D $colour is copy, Bool:D $syntax, Regex:D $pattern, Int:D $page-length --> Bool:D) is export #

sub list-by-all(Str:D $prefix,
                Bool:D $colour,
                Bool:D $syntax,
                Int:D $page-length,
                Regex:D $pattern --> Bool:D) is export {
    my Str:D $key-name = 'key';
    my Str:D @fields = 'path', 'comment';
    my   %defaults = path => '';
    sub include-row(Str:D $prefix, Regex:D $pattern, Str:D $key, Str:D @fields, %row --> Bool:D) {
        return False if $key ~~ rx/ ^ '#' .*/;
        return True if $key.starts-with($prefix, :ignorecase) && $key ~~ $pattern;
        for @fields -> $field {
            my Str:D $value = '';
            with %row{$field} { #`««« if %row{$field} does not exist then a Any will be retured,
                                  and if some cases, you may return undefined values so use
                                  some sort of guard this is one way to do that, you could
                                  use %row{$field}:exists or :!exists or // perhaps.
                                  TIMTOWTDI rules as always. »»»
                $value = ~%row{$field};
            }
            return True if $value.starts-with($prefix, :ignorecase) && $value ~~ $pattern;
        }
        return False;
    } # sub include-row(Str:D $prefix, Regex:D $pattern, Str:D $key, @fields, %row --> Bool:D) #
    sub head-value(Int:D $indx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) {
        if $syntax {
            t.color(0, 255, 255) ~ $field;
        } elsif $colour {
            t.color(0, 255, 255) ~ $field;
        } else {
            return $field;
        }
    } #`««« sub head-value(Int:D $indx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) »»»
    sub head-between(Int:D $idx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) {
        if $colour {
            if $syntax {
                given $field {
                    when 'key'     { return t.color(0, 255, 255) ~ ' sep '; }
                    when 'path'    { return t.color(0, 255, 255)   ~ ' # ';   }
                    when 'comment' { return t.color(0, 0, 255)   ~ '  ';    }
                    default { return ''; }
                }
            } else {
                given $field {
                    when 'key'     { return t.color(0, 255, 255)   ~ ' sep '; }
                    when 'path'    { return t.color(0, 255, 255)   ~ ' # ';   }
                    when 'comment' { return t.color(0, 255, 255)   ~ '  ';    }
                    default { return ''; }
                }
            }
        } else {
            given $field {
                when 'key'     { return ' sep '; }
                when 'path'    { return ' # ';   }
                when 'comment' { return '  ';    }
                default        { return '';      }
            }
        }
    } #`««« sub head-between(Int:D $idx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) »»»
    sub field-value(Int:D $idx, Str:D $field, $value, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) {
        if $syntax {
            given $field {
                when 'key'     { return t.color(0, 255, 255) ~ ~$value; }
                when 'path'    { return t.color(255, 0, 255) ~ ~$value; }
                when 'comment' { return t.color(0, 0, 255) ~ ~$value; }
                default        { return t.color(255, 0, 0) ~ '';      }
            } # given $field #
        } elsif $colour {
            given $field {
                when 'key'     { return t.color(0, 0, 255) ~ ~$value; }
                when 'path'    { return t.color(0, 0, 255) ~ ~$value; }
                when 'comment' { return t.color(0, 0, 255) ~ ~$value; }
                default        { return t.color(255, 0, 0) ~ '';      }
            }
        } else {
            given $field {
                when 'key'     { return ~$value; }
                when 'path'    { return ~$value; }
                when 'comment' { return ~$value; }
                default        { return '';      }
            }
        }
    } #`««« sub field-value(Int:D $idx, Str:D $field, $value, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) »»»
    sub between(Int:D $idx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) {
        if $syntax {
                given $field {
                    when 'key'     {
                        my Str:D $type = %row«type»;
                        if $type eq 'dir' {
                            return t.color(255, 0, 0) ~ '  => ';
                        } else {
                            return t.color(255, 0, 0) ~ ' --> ';
                        }
                    }
                    when 'path'    { return t.color(0, 0, 255) ~ ' # '; }
                    when 'comment' { return t.color(0, 0, 255) ~ '  ';  }
                    default        { return t.color(255, 0, 0) ~ '';    }
                }
        } elsif $colour {
                given $field {
                    when 'key'     {
                        my Str:D $type = %row«type»;
                        if $type eq 'dir' {
                            return t.color(0, 0, 255) ~ '  => ';
                        } else {
                            return t.color(0, 0, 255) ~ ' --> ';
                        }
                    }
                    when 'path'    { return t.color(0, 0, 255) ~ ' # '; }
                    when 'comment' { return t.color(0, 0, 255) ~ '  ';  }
                    default        { return t.color(255, 0, 0) ~ '';    }
                }
        } else {
                given $field {
                    when 'key'     {
                        my Str:D $type = %row«type»;
                        if $type eq 'dir' {
                            return '  => ';
                        } else {
                            return ' --> ';
                        }
                    }
                    when 'path'    { return ' # '; }
                    when 'comment' { return '  ';  }
                    default        { return '';    }
                }
        }
    } #`««« sub between(Int:D $idx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) »»»
    sub row-formatting(Int:D $cnt, Bool:D $colour, Bool:D $syntax --> Str:D) {
        if $colour {
            if $syntax { 
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -3; # three heading lines. #
                return t.bg-color(0, 0, 127) ~ t.bold ~ t.bright-blue if $cnt == -2;
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -1;
                return (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,195,0)) ~ t.bold ~ t.bright-blue;
            } else {
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -3;
                return t.bg-color(0, 0, 127) ~ t.bold ~ t.bright-blue if $cnt == -2;
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -1;
                return (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,195,0)) ~ t.bold ~ t.bright-blue;
            }
        } else {
            return '';
        }
    } #`««« sub row-formatting(Int:D $cnt, Bool:D $colour, Bool:D $syntax --> Str:D) »»»
    return list-by($prefix, $colour, $syntax, $page-length, $pattern, $key-name, @fields, %defaults, %the-lot,
                                            :&include-row, :&head-value, :&head-between, :&field-value, :&between, :&row-formatting);
} #`««« sub list-by-all(Str:D $prefix, Bool:D $colour is copy, Bool:D $syntax, Int:D $page-length, Regex:D $pattern --> Bool:D) is export »»»

sub add-tildes(Str:D $path is copy --> Str:D) {
    $path .=trim;
    unless $path.starts-with('~') {
        $path  = $path.IO.absolute;
    }
    $path  = '~' if $path eq $home;
    $path ~~ s{^ $home '/' } = '~/';
    $path ~~ s{^ '/home/' }  = '~';
    $path ~~ s!\/$!!;
    return $path;
}

sub add-path(Str:D $key, Str:D $path is copy, Bool $force, Str $comment --> Bool) is export {
    unless valid-key($key) {
        $*ERR.say: "invalid key: $key";
        return False;
    }
    unless $path.IO ~~ :d {
        $path = $path.IO.dirname;
    }
    if %the-lot{$key}:exists {
        if $force {
            CATCH {
                when X::IO::Rename {
                    $*ERR.say: $_;
                    return False;
                }
                default: {
                    $*ERR.say: $_;
                    return False;
                }
            }
            my Str $line = sprintf "%-20s  =>   %-50s", $key, add-tildes($path);
            with $comment {
                $line ~= " # $comment";
            }
            my IO::Handle:D $input  = "$config/pack.p_ck".IO.open:     :r, :nl-in("\n")   :chomp;
            my IO::Handle:D $output = "$config/pack.p_ck.new".IO.open: :w, :nl-out("\n"), :chomp(True);
            my Str $ln;
            while $ln = $input.get {
                if $ln ~~ rx/^ \h* <$key> \h* '=>' \h* .* $/ {
                    $output.say: $line;
                } else {
                    $output.say: $ln
                }
            }
            $input.close;
            $output.close;
            if "$config/pack.p_ck.new".IO.move: "$config/pack.p_ck" {
                return True;
            } else {
                return False;
            }
        } else {
            $*ERR.say: "duplicate key use -s|--set|--force to override";
            return False;
        }
    }
    my Str $config-path = "$config/pack.p_ck";
    my Str $line = sprintf "%-20s  =>   %-50s", $key, add-tildes($path);
    with $comment {
        $line ~= " # $comment";
    }
    $line ~= "\n";
    $config-path.IO.spurt($line, :append);
    return True;
} # sub add-path(Str:D $key, Str:D $path, Bool $force, Str $comment --> Bool) is export #

sub delete-key(Str:D $key, Bool:D $trash --> Bool) is export {
    CATCH {
        when X::IO::Rename {
            $*ERR.say: $_;
            return False;
        }
        default: {
            $*ERR.say: $_;
            return False;
        }
    }
    unless valid-key($key) {
        $*ERR.say: "invalid key: $key";
        return False;
    }
    my IO::Handle:D $input  = "$config/pack.p_ck".IO.open:     :r, :nl-in("\n")   :chomp;
    my IO::Handle:D $output = "$config/pack.p_ck.new".IO.open: :w, :nl-out("\n"), :chomp(True);
    my Str $ln;
    $ln = $input.get;
    while !$input.eof {
        if $ln ~~ rx/^ $key \h* [ '-->' || '=>' ] \h* [ <-[ # ]>+ ] \h* [ '#' \h* .* ]? $/ {
            if $trash {
                $output.say: "#$ln";
            }
        } else {
            $output.say: $ln
        }
        $ln = $input.get;
    }
    if $ln {
        if $ln ~~ rx/^ $key \h* [ '-->' || '=>' ] \h* [ <-[ # ]>+ ] \h* [ '#' \h* .* ]? $/ {
            if $trash {
                $output.say: "#$ln";
            }
        } else {
            $output.say: $ln
        }
    }
    $input.close;
    $output.close;
    if "$config/pack.p_ck.new".IO.move: "$config/pack.p_ck" {
        return True;
    } else {
        return False;
    }
} # sub delete-key(Str:D $key, Bool:D $trash --> Bool) is export #

sub tidy-file( --> Bool) is export {
    CATCH {
        when X::IO::Rename {
            $*ERR.say: $_;
            return False;
        }
        default: {
            $*ERR.say: $_;
            return False;
        }
    }
    my IO::Handle:D $input  = "$config/pack.p_ck".IO.open:     :r, :nl-in("\n")   :chomp(False);
    my Str $ln             = $input.get;
    my @lines;
    my Int:D $keywidth     = 20;
    my Int:D $pathwidth    = 50;
    my Int:D $commentwidth = 20;
    repeat {
        if $ln ~~ rx/^ \s* $<key> = [ \w+ [ <-[\h]>+ \w* ]* ] \s* $<type> = [ ' =>' ] \s* $<path> = [ <-[ # ]>+ ] \s* [ '#' \s* $<comment> = [ <-[#]>* ] [ \s* '#' \s* ]? ]?  $/ {
            my Str:D $key      = ~$<key>;
            $key              .=trim;
            my Str:D $path     = ~$<path>;
            $path             .=trim;
            if ~$<type> eq ' =>' {
                $path          = add-tildes($path);
            }
            my Str:D $comment  = ~$<comment>;
            $comment          .=trim;
            $keywidth          = max($keywidth,            $key.chars);
            $pathwidth         = max($pathwidth,          $path.chars);
            $commentwidth      = max($commentwidth,    $comment.chars);
            my %line           = key => $key, type => ~$<type>, path => $path, comment => $comment;
            %line«kind» = 'normal';
            @lines.push: %line;
        } elsif $ln ~~ rx/^ '#' \s* $<key> = [ \w+ [ <-[\h]>+ \w* ]* ] \s* $<type> = [ ' =>' ] \s* $<path> = [ <-[ # ]>+ ] \s* [ '#' \s* $<comment> = [ <-[#]>* ] [ '#' \s* ]? ]?  $/ {
            my Str:D $key      = ~$<key>;
            my Str:D $path     = ~$<path>;
            $path             .=trim;
            if ~$<type> eq ' =>' {
                $path          = add-tildes($path);
            }
            my Str:D $comment  = ~$<comment>;
            $keywidth          = max($keywidth,            $key.chars);
            $pathwidth         = max($pathwidth,          $path.chars);
            $commentwidth      = max($commentwidth,    $comment.chars);
            my %line           = key => $key, type => ~$<type>, path => $path, comment => $comment;
            %line«kind» = 'commented';
            @lines.push: %line;
        } elsif $ln ~~ rx:ignorecase/^ '#' $<key> = [ 'key' ] \s+ $<type> = [ 'sep' ] \s+ $<path> = [ 'target' ] \s+ [ '#' $<comment> = [ \s* 'comment' ] [ \s* '#' \s* ]? ]? $/ {
            my Str:D $key      = ~$<key>;
            my Str:D $path     = ~$<path>;
            $path             .=trim;
            if ~$<type> eq ' =>' {
                $path          = add-tildes($path);
            }
            my Str:D $comment  = 'comment';
            $keywidth          = max($keywidth,            $key.chars);
            $pathwidth         = max($pathwidth,          $path.chars);
            $commentwidth      = max($commentwidth,    $comment.chars);
            my %line           = key => $key, type => ~$<type>, path => $path, comment => $comment;
            %line«kind» = 'header';
            @lines.push: %line;
        } elsif $ln ~~ rx/^ $<pre> = [ \s* ] '#' $<body> = [ .* ] $/ {
            my %line = pre => ~$<pre>, body => ~$<body>;
            %line«kind» = 'arbitrary';
            @lines.push: %line;
        } elsif $ln ~~ rx/^ \s* $/ {
            my %line;
            %line«kind» = 'empty';
            @lines.push: %line;
        }
        $ln             = $input.get;
    }  until $input.eof;
    if $ln {
        if $ln ~~ rx/^ \s* $<key> = [ \w+ [ <-[\h]>+ \w* ]* ] \s* $<type> = [ ' =>' ] \s* $<path> = [ <-[ # ]>+ ] \s* [ '#' \s* $<comment> = [ <-[#]>* ] [ \s* '#' \s* ]? ]?  $/ {
            my Str:D $key      = ~$<key>;
            $key              .=trim;
            my Str:D $path     = ~$<path>;
            $path             .=trim;
            if ~$<type> eq ' =>' {
                $path          = add-tildes($path);
            }
            my Str:D $comment  = ~$<comment>;
            $comment          .=trim;
            $keywidth          = max($keywidth,            $key.chars);
            $pathwidth         = max($pathwidth,          $path.chars);
            $commentwidth      = max($commentwidth,    $comment.chars);
            my %line           = key => $key, type => ~$<type>, path => $path, comment => $comment;
            %line«kind» = 'normal';
            @lines.push: %line;
        } elsif $ln ~~ rx/^ '#' \s* $<key> = [ \w+ [ <-[\h]>+ \w* ]* ] \s* $<type> = [ ' =>' ] \s* $<path> = [ <-[ # ]>+ ] \s* [ '#' \s* $<comment> = [ <-[#]>* ] [ '#' \s* ]? ]?  $/ {
            my Str:D $key      = ~$<key>;
            my Str:D $path     = ~$<path>;
            $path             .=trim;
            if ~$<type> eq ' =>' {
                $path          = add-tildes($path);
            }
            my Str:D $comment  = ~$<comment>;
            $keywidth          = max($keywidth,            $key.chars);
            $pathwidth         = max($pathwidth,          $path.chars);
            $commentwidth      = max($commentwidth,    $comment.chars);
            my %line           = key => $key, type => ~$<type>, path => $path, comment => $comment;
            %line«kind» = 'commented';
            @lines.push: %line;
        } elsif $ln ~~ rx:ignorecase/^ '#' $<key> = [ 'key' ] \s+ $<type> = [ 'sep' ] \s+ $<path> = [ 'target' ] \s+ [ '#' $<comment> = [ \s* 'comment' ] [ \s* '#' \s* ]? ]? $/ {
            my Str:D $key      = ~$<key>;
            my Str:D $path     = ~$<path>;
            $path             .=trim;
            if ~$<type> eq ' =>' {
                $path          = add-tildes($path);
            }
            my Str:D $comment  = 'comment';
            $keywidth          = max($keywidth,            $key.chars);
            $pathwidth         = max($pathwidth,          $path.chars);
            $commentwidth      = max($commentwidth,    $comment.chars);
            my %line           = key => $key, type => ~$<type>, path => $path, comment => $comment;
            %line«kind» = 'header';
            @lines.push: %line;
        } elsif $ln ~~ rx/^ $<pre> = [ \s* ] '#' $<body> = [ .* ] $/ {
            my %line = pre => ~$<pre>, body => ~$<body>;
            %line«kind» = 'arbitrary';
            @lines.push: %line;
        } elsif $ln ~~ rx/^ \s* $/ {
            my %line;
            %line«kind» = 'empty';
            @lines.push: %line;
        }
    } # if $ln #
    $input.close;
    my IO::Handle:D $output = "$config/pack.p_ck.new".IO.open: :w, :nl-out("\n"), :chomp(True);
    for @lines -> %ln {
        my Str:D $line = '';
        given %ln«kind» {
            when 'normal' {
                $line = sprintf "%-*s %-3s %-*s # %-*s # ", $keywidth, %ln«key», %ln«type»,
                                        $pathwidth, %ln«path», $commentwidth, %ln«comment»;
            }
            when 'commented' {
                $line = sprintf "#%-*s %-3s %-*s # %-*s # ", $keywidth, %ln«key», %ln«type»,
                                        $pathwidth, %ln«path», $commentwidth, %ln«comment»;
            }
            when 'header' {
                $line = sprintf "#%-*s %-3s %-*s # %-*s # ", $keywidth - 1, %ln«key», %ln«type»,
                                        $pathwidth, %ln«path», $commentwidth, %ln«comment»;
            }
            when 'arbitrary' {
                $line = sprintf "%s#%s", %ln«pre», %ln«body»;
            }
        }
        $output.say: $line;
    }
    $output.close;
    if "$config/pack.p_ck.new".IO.move: "$config/pack.p_ck" {
        return True;
    } else {
        return False;
    }
} # sub tidy-file( --> Bool) is export #

enum Kind is export ( neither => 0, normal => 1, commented => 2, both => 3, );

sub is-kind(Str:D $kind --> Bool:D) is export {
    if $kind  ~~ rx/^ [ 'neither' || 'normal' || 'commented' || 'both' ] $/ {
        return True;
    } else {
        return False;
    }
} # sub is-kind(Str:D $kind --> Bool:D) is export #

sub add-comment(Str:D $key_, Str:D $comment_, Int:D $kind --> Bool) is export {
    CATCH {
        when X::IO::Rename {
            $*ERR.say: $_;
            return False;
        }
        default: {
            $*ERR.say: $_;
            return False;
        }
    }
    my IO::Handle:D $input  = "$config/pack.p_ck".IO.open:     :r, :nl-in("\n")   :chomp(False);
    my Str $ln             = $input.get;
    my @lines;
    my Int:D $keywidth     = 20;
    my Int:D $pathwidth    = 50;
    my Int:D $commentwidth = 20;
    repeat {
        if $ln ~~ rx/^ \s* $<key> = [ \w+ [ <-[\h]>+ \w* ]* ] \s* $<type> = [ ' =>' ] \s* $<path> = [ <-[ # ]>+ ] \s* [ '#' \s* $<comment> = [ <-[#]>* ] [ \s* '#' \s* ]? ]?  $/ {
            my Str:D $key      = ~$<key>;
            $key              .=trim;
            my Str:D $path     = ~$<path>;
            $path             .=trim;
            if ~$<type> eq ' =>' {
                $path          = add-tildes($path);
            }
            my Str:D $comment  = (~$<comment> ?? ~$<comment> !! '');
            $comment          .=trim;
            #dd $key, $path, $comment;
            $comment           = $comment_ if $key eq $key_ && $kind +& Kind::normal;
            $keywidth          = max($keywidth,            $key.chars);
            $pathwidth         = max($pathwidth,          $path.chars);
            $commentwidth      = max($commentwidth,    $comment.chars);
            my %line           = key => $key, type => ~$<type>, path => $path, comment => $comment;
            %line«kind» = 'normal';
            @lines.push: %line;
        } elsif $ln ~~ rx/^ '#' \s* $<key> = [ \w+ [ <-[\h]>+ \w* ]* ] \s* $<type> = [ ' =>' ] \s* $<path> = [ <-[ # ]>+ ] \s* [ '#' \s* $<comment> = [ <-[#]>* ] [ '#' \s* ]? ]?  $/ {
            my Str:D $key      = ~$<key>;
            my Str:D $path     = ~$<path>;
            $path             .=trim;
            if ~$<type> eq ' =>' {
                $path          = add-tildes($path);
            }
            my Str:D $comment  = (~$<comment> ?? ~$<comment> !! '');
            $comment          .=trim;
            $comment           = $comment_ if $key eq $key_ && $kind +& Kind::commented;
            $keywidth          = max($keywidth,            $key.chars);
            $pathwidth         = max($pathwidth,          $path.chars);
            $commentwidth      = max($commentwidth,    $comment.chars);
            my %line           = key => $key, type => ~$<type>, path => $path, comment => $comment;
            %line«kind» = 'commented';
            @lines.push: %line;
        } elsif $ln ~~ rx:ignorecase/^ '#' $<key> = [ 'key' ] \s+ $<type> = [ 'sep' ] \s+ $<path> = [ 'target' ] \s+ [ '#' $<comment> = [ \s* 'comment' ] [ \s* '#' \s* ]? ]? $/ {
            my Str:D $key      = ~$<key>;
            my Str:D $path     = ~$<path>;
            $path             .=trim;
            if ~$<type> eq ' =>' {
                $path          = add-tildes($path);
            }
            my Str:D $comment  = 'comment';
            $keywidth          = max($keywidth,            $key.chars);
            $pathwidth         = max($pathwidth,          $path.chars);
            $commentwidth      = max($commentwidth,    $comment.chars);
            my %line           = key => $key, type => ~$<type>, path => $path, comment => $comment;
            %line«kind» = 'header';
            @lines.push: %line;
        } elsif $ln ~~ rx/^ $<pre> = [ \s* ] '#' $<body> = [ .* ] $/ {
            my %line = pre => ~$<pre>, body => ~$<body>;
            %line«kind» = 'arbitrary';
            @lines.push: %line;
        } elsif $ln ~~ rx/^ \s* $/ {
            my %line;
            %line«kind» = 'empty';
            @lines.push: %line;
        }
        $ln             = $input.get;
    }  until $input.eof;
    if $ln {
        if $ln ~~ rx/^ \s* $<key> = [ \w+ [ <-[\h]>+ \w* ]* ] \s* $<type> = [ ' =>' ] \s* $<path> = [ <-[ # ]>+ ] \s* [ '#' \s* $<comment> = [ <-[#]>* ] [ \s* '#' \s* ]? ]?  $/ {
            my Str:D $key      = ~$<key>;
            $key              .=trim;
            my Str:D $path     = ~$<path>;
            $path             .=trim;
            if ~$<type> eq ' =>' {
                $path          = add-tildes($path);
            }
            my Str:D $comment  = (~$<comment> ?? ~$<comment> !! '');
            $comment          .=trim;
            #dd $key, $path, $comment;
            $comment           = $comment_ if $key eq $key_ && $kind +& Kind::normal;
            $keywidth          = max($keywidth,            $key.chars);
            $pathwidth         = max($pathwidth,          $path.chars);
            $commentwidth      = max($commentwidth,    $comment.chars);
            my %line           = key => $key, type => ~$<type>, path => $path, comment => $comment;
            %line«kind» = 'normal';
            @lines.push: %line;
        } elsif $ln ~~ rx/^ '#' \s* $<key> = [ \w+ [ <-[\h]>+ \w* ]* ] \s* $<type> = [ ' =>' ] \s* $<path> = [ <-[ # ]>+ ] \s* [ '#' \s* $<comment> = [ <-[#]>* ] [ '#' \s* ]? ]?  $/ {
            my Str:D $key      = ~$<key>;
            my Str:D $path     = ~$<path>;
            $path             .=trim;
            if ~$<type> eq ' =>' {
                $path          = add-tildes($path);
            }
            my Str:D $comment  = (~$<comment> ?? ~$<comment> !! '');
            $comment          .=trim;
            $comment           = $comment_ if $key eq $key_ && $kind +& Kind::commented;
            $keywidth          = max($keywidth,            $key.chars);
            $pathwidth         = max($pathwidth,          $path.chars);
            $commentwidth      = max($commentwidth,    $comment.chars);
            my %line           = key => $key, type => ~$<type>, path => $path, comment => $comment;
            %line«kind» = 'commented';
            @lines.push: %line;
        } elsif $ln ~~ rx:ignorecase/^ '#' $<key> = [ 'key' ] \s+ $<type> = [ 'sep' ] \s+ $<path> = [ 'target' ] \s+ [ '#' $<comment> = [ \s* 'comment' ] [ \s* '#' \s* ]? ]? $/ {
            my Str:D $key      = ~$<key>;
            my Str:D $path     = ~$<path>;
            $path             .=trim;
            if ~$<type> eq ' =>' {
                $path          = add-tildes($path);
            }
            my Str:D $comment  = 'comment';
            $keywidth          = max($keywidth,            $key.chars);
            $pathwidth         = max($pathwidth,          $path.chars);
            $commentwidth      = max($commentwidth,    $comment.chars);
            my %line           = key => $key, type => ~$<type>, path => $path, comment => $comment;
            %line«kind» = 'header';
            @lines.push: %line;
        } elsif $ln ~~ rx/^ $<pre> = [ \s* ] '#' $<body> = [ .* ] $/ {
            my %line = pre => ~$<pre>, body => ~$<body>;
            %line«kind» = 'arbitrary';
            @lines.push: %line;
        } elsif $ln ~~ rx/^ \s* $/ {
            my %line;
            %line«kind» = 'empty';
            @lines.push: %line;
        }
    } # if $ln #
    $input.close;
    my IO::Handle:D $output = "$config/pack.p_ck.new".IO.open: :w, :nl-out("\n"), :chomp(True);
    #dd @lines;
    for @lines -> %ln {
        my Str:D $line = '';
        given %ln«kind» {
            when 'normal' {
                $line = sprintf "%-*s %-3s %-*s # %-*s # ", $keywidth, %ln«key», %ln«type»,
                                        $pathwidth, %ln«path», $commentwidth, %ln«comment»;
            }
            when 'commented' {
                $line = sprintf "#%-*s %-3s %-*s # %-*s # ", $keywidth, %ln«key», %ln«type»,
                                        $pathwidth, %ln«path», $commentwidth, %ln«comment»;
            }
            when 'header' {
                $line = sprintf "#%-*s %-3s %-*s # %-*s # ", $keywidth - 1, %ln«key», %ln«type»,
                                        $pathwidth, %ln«path», $commentwidth, %ln«comment»;
            }
            when 'arbitrary' {
                $line = sprintf "%s#%s", %ln«pre», %ln«body»;
            }
        }
        $output.say: $line;
    }
    $output.close;
    if "$config/pack.p_ck.new".IO.move: "$config/pack.p_ck" {
        return True;
    } else {
        return False;
    }
}

sub list-commented(Str:D $prefix, Bool:D $colour, Bool:D $syntax, Int:D $page-length, Regex:D $pattern --> Bool) is export {
    my @data;
    my IO::Handle:D $input  = "$config/pack.p_ck".IO.open:     :r, :nl-in("\n")   :chomp;
    my $actions = CommentedLineActions;
    my $ln = $input.get;
    while !$input.eof {
        my %row;
        #my $test = Line.parse($ln, :enc('UTF-8'), :$actions).made;
        #dd $test;
        my %val = CommentedLine.parse($ln, :enc('UTF-8'), :$actions).made;
        my Str $key         = %val«key»;
        my %v               = %val«value»;
        my Str:D $type      = %v«type»;
        %row                = key => $key, type => $type;
        if $type eq 'commeted-alias' || $type eq 'commeted-dir' {
            my Str $path;
            with %v«path» {
                $path      = %v«path»;
                %row«path»  =  $path;
            }
            with %v«comment» {
                my Str $comment = %v«comment»;
                %row«comment»   = $comment;
            }
            @data.push: %row;
        }
        $ln = $input.get;
    } # while !$input.eof #
    if $ln {
        my %row;
        #my $test = Line.parse($ln, :enc('UTF-8'), :$actions).made;
        #dd $test;
        my %val = CommentedLine.parse($ln, :enc('UTF-8'), :$actions).made;
        my Str $key         = %val«key»;
        my %v               = %val«value»;
        my Str:D $type      = %v«type»;
        %row                = key => $key, type => $type;
        if $type eq 'commeted-alias' || $type eq 'commeted-dir' {
            my Str $path;
            with %v«path» {
                $path      = %v«path»;
                %row«path»  =  $path;
            }
            with %v«comment» {
                my Str $comment = %v«comment»;
                %row«comment»   = $comment;
            }
            @data.push: %row;
        }
    } # $ln #
    $input.close();
    my Str:D @fields = 'key', 'path', 'comment';
    my   %defaults;
    sub include-row(Str:D $prefix, Regex:D $pattern, Int:D $idx, Str:D @fields, %row --> Bool:D) {
        for @fields -> $field {
            my Str:D $value = '';
            with %row{$field} { #`««« if %row{$field} does not exist then a Any will be retured,
                                  and if some cases, you may return undefined values so use
                                  some sort of guard this is one way to do that, you could
                                  use %row{$field}:exists or :!exists or // perhaps.
                                  TIMTOWTDI rules as always. »»»
                $value = ~%row{$field};
            }
            return True if $value.starts-with($prefix, :ignorecase) && $value ~~ $pattern;
        }
        return False;
    } # sub include-row(Str:D $prefix, Regex:D $pattern, Str:D $key, @fields, %row --> Bool:D) #
    sub head-value(Int:D $indx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) {
        if $syntax {
            t.color(0, 255, 255) ~ (($field eq 'key') ?? "#$field" !! $field);
        } elsif $colour {
            t.color(0, 255, 255) ~ (($field eq 'key') ?? "#$field" !! $field);
        } else {
            return (($field eq 'key') ?? "#$field" !! $field);
        }
    } #`««« sub head-value(Int:D $indx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) »»»
    sub head-between(Int:D $indx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) {
        if $colour {
            if $syntax {
                given $field {
                    when 'key'     { return t.color(0, 255, 255) ~ ' sep '; }
                    when 'path'    { return t.color(0, 255, 255)   ~ ' # ';   }
                    when 'comment' { return t.color(0, 0, 255)   ~ '  ';    }
                    default { return ''; }
                }
            } else {
                given $field {
                    when 'key'     { return t.color(0, 255, 255)   ~ ' sep '; }
                    when 'path'    { return t.color(0, 255, 255)   ~ ' # ';   }
                    when 'comment' { return t.color(0, 255, 255)   ~ '  ';    }
                    default { return ''; }
                }
            }
        } else {
            given $field {
                when 'key'     { return ' sep '; }
                when 'path'    { return ' # ';   }
                when 'comment' { return '  ';    }
                default        { return '';      }
            }
        }
    } #`««« sub head-between(Int:D $idx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) »»»
    sub field-value(Int:D $idx, Str:D $field, $value, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) {
        if $syntax {
            given $field {
                when 'key'     { return t.color(0, 0, 255) ~ '#' ~ t.color(0, 255, 255) ~ ~$value; }
                when 'path'    { 
                    my Str:D $type = %row«type»;
                    if $type eq 'commeted-dir' {
                        return t.color(255, 0, 255) ~ ~$value;
                    } else {
                        return t.color(0, 255, 255) ~ ~$value;
                    }
                }
                when 'comment' { return t.color(0, 0, 255) ~ ~$value; }
                default        { return t.color(255, 0, 0) ~ '';      }
            } # given $field #
        } elsif $colour {
            given $field {
                when 'key'     { return t.color(0, 0, 255) ~ '#' ~ ~$value; }
                when 'path'    { 
                    my Str:D $type = %row«type»;
                    if $type eq 'commeted-dir' {
                        return t.color(0, 0, 255) ~ ~$value;
                    } else {
                        return t.color(0, 0, 255) ~ ~$value;
                    }
                }
                when 'comment' { return t.color(0, 0, 255) ~ ~$value; }
                default        { return t.color(255, 0, 0) ~ '';      }
            }
        } else {
            given $field {
                when 'key'     { return '#' ~ ~$value; }
                when 'path'    { 
                    my Str:D $type = %row«type»;
                    if $type eq 'commeted-dir' {
                        return ~$value;
                    } else {
                        return ~$value;
                    }
                }
                when 'comment' { return ~$value; }
                default        { return '';      }
            }
        }
    } #`««« sub field-value(Int:D $idx, Str:D $field, $value, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) »»»
    sub between(Int:D $idx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) {
        if $syntax {
                given $field {
                    when 'key'     {
                        my Str:D $type = %row«type»;
                        if $type eq 'commeted-dir' {
                            return t.color(255, 0, 0) ~ '  => ';
                        } else {
                            return t.color(255, 0, 0) ~ ' --> ';
                        }
                    }
                    when 'path'    { return t.color(0, 0, 255) ~ ' # '; }
                    when 'comment' { return t.color(0, 0, 255) ~ '  ';  }
                    default        { return t.color(255, 0, 0) ~ '';    }
                }
        } elsif $colour {
                given $field {
                    when 'key'     {
                        my Str:D $type = %row«type»;
                        if $type eq 'commeted-dir' {
                            return t.color(0, 0, 255) ~ '  => ';
                        } else {
                            return t.color(0, 0, 255) ~ ' --> ';
                        }
                    }
                    when 'path'    { return t.color(0, 0, 255) ~ ' # '; }
                    when 'comment' { return t.color(0, 0, 255) ~ '  ';  }
                    default        { return t.color(255, 0, 0) ~ '';    }
                }
        } else {
                given $field {
                    when 'key'     {
                        my Str:D $type = %row«type»;
                        if $type eq 'commeted-dir' {
                            return '  => ';
                        } else {
                            return ' --> ';
                        }
                    }
                    when 'path'    { return ' # '; }
                    when 'comment' { return '  ';  }
                    default        { return '';    }
                }
        }
    } #`««« sub between(Int:D $idx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) »»»
    sub row-formatting(Int:D $cnt, Bool:D $colour, Bool:D $syntax --> Str:D) {
        if $colour {
            if $syntax { 
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -3; # three heading lines. #
                return t.bg-color(0, 0, 127) ~ t.bold ~ t.bright-blue if $cnt == -2;
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -1;
                return (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,195,0)) ~ t.bold ~ t.bright-blue;
            } else {
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -3;
                return t.bg-color(0, 0, 127) ~ t.bold ~ t.bright-blue if $cnt == -2;
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -1;
                return (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,195,0)) ~ t.bold ~ t.bright-blue;
            }
        } else {
            return '';
        }
    } #`««« sub row-formatting(Int:D $cnt, Bool:D $colour, Bool:D $syntax --> Str:D) »»»
    return list-by($prefix, $colour, $syntax, $page-length,
                  $pattern, @fields, %defaults, @data,
                  :&include-row, 
                  :&head-value, 
                  :&head-between,
                  :&field-value, 
                  :&between,
                  :&row-formatting);
} # sub list-commented(Str:D $prefix, Bool:D $colour, Bool:D $syntax, Int:D $page-length, Regex:D $pattern --> Bool) is export #

sub empty-trash( --> Bool) is export {
    my IO::Handle:D $input  = "$config/pack.p_ck".IO.open:     :r, :nl-in("\n")   :chomp;
    my IO::Handle:D $output = "$config/pack.p_ck.new".IO.open: :w, :nl-out("\n"), :chomp(True);
    my Int:D $key-width        = 0;
    my Int:D $dir-width       = 0;
    my Int:D $comment-width    = 0;
    my Str $ln;
    $ln = $input.get;
    while !$input.eof {
        if $ln ~~ rx/ ^ '#' ** {2 .. ∞} / {
        } elsif $ln ~~ rx/^ \s* $<key> = [ \w* [ <-[\h]>+ \w* ]* ] \h* $<type> = [ '-->' || ' =>' ] \h* $<path> = [ <-[ # ]>+ ] \h* [ '#' \h* $<comment> = [ .* ] ]?  $/ {
            my Str:D $path = ~$<path>;
            $path         .=trim;
            $key-width         = max($key-width,     wcswidth(~$<key>));
            $dir-width        = max($dir-width,    wcswidth($path));
            with $<comment> {
                $comment-width = max($comment-width, wcswidth(~$<comment>));
            }
        } elsif $ln ~~ rx/^ \h+ '#' \h* $<key> = [ \w* [ <-[\h]>+ \w* ]* ] \h* $<type> = [ '-->' || ' =>' || 'sep' ] \h* $<path> = [ <-[ # ]>+ ] \h* [ [ '#' \h* $<comment> = [ .* ] ]? ]?  $/ {
            my Str:D $path = ~$<path>;
            $path         .=trim;
            $key-width         = max($key-width,     wcswidth('#' ~ ~$<key>));
            $dir-width        = max($dir-width,    wcswidth($path));
            with $<comment> {
                $comment-width = max($comment-width, wcswidth(~$<comment>));
            }
        }
        $ln = $input.get;
    } # while !$input.eof #
    if $ln {
        if $ln ~~ rx/ ^ '#' ** {2 .. ∞} / {
        } elsif $ln ~~ rx/^ \s* $<key> = [ \w* [ <-[\h]>+ \w* ]* ] \h* $<type> = [ '-->' || ' =>' ] \h* $<path> = [ <-[ : # ]>+ ] \h* [ '#' \h* $<comment> = [ .* ] ]?  $/ {
            my Str:D $path = ~$<path>;
            $path         .=trim;
            $key-width         = max($key-width,     wcswidth(~$<key>));
            $dir-width        = max($dir-width,    wcswidth($path));
            with $<comment> {
                $comment-width = max($comment-width, wcswidth(~$<comment>));
            }
        } elsif $ln ~~ rx/^ \h* '#' \h* $<key> = [ \w* [ <-[\h]>+ \w* ]* ] \h* $<type> = [ '-->' || ' =>' || 'sep' ] \h* $<path> = [ <-[ # ]>+ ] \h* [ '#' \h* $<comment> = [ .* ] ]? $/ {
            my Str:D $path = ~$<path>;
            $path         .=trim;
            $key-width         = max($key-width,     wcswidth('#' ~ ~$<key>));
            $dir-width        = max($dir-width,    wcswidth($path));
            with $<comment> {
                $comment-width = max($comment-width, wcswidth(~$<comment>));
            }
        }
    } # $ln #
    #$key-width     += 2;
    #$dir-width    += 2;
    #$comment-width += 2;
    $key-width = 20 if $key-width < 20;
    $dir-width = 70 if $dir-width < 70;
    $input.seek(0, SeekFromBeginning);
    $ln = $input.get;
    while !$input.eof {
        if $ln ~~ rx/ ^ '#' ** {2 .. ∞} / {
            $output.say: $ln
        } elsif $ln ~~ rx/^ \h* $<key> = [ \w+ [ <-[\h]>+ \w* ]* ] \h* $<type> = [ '-->' || ' =>' ] \h* $<path> = [ <-[ : # ]>+ ] \h* [ '#' \h* $<comment> = [ .* ] ]?  $/ {
            my Str:D $path = ~$<path>;
            $path         .=trim;
            my Str $line = sprintf "%-*s %-3s %-*s", $key-width, ~$<key>, ~$<type>, $dir-width, $path;
            with $<comment> {
                $line ~= " # $<comment>";
            }
            $output.say: $line;
        } elsif $ln ~~ rx/^ \h* '#' \h* $<key> = [ \w+ [ <-[\h]>+ \w* ]* ] \h* $<type> = [ '-->' || ' =>' ] \h* $<path> = [ <-[ : # ]>+ ] \h* [ '#' \h* $<comment> = [ .* ] ]?  $/ {
            # do nothing we want to delete this #
        } else {
            $output.say: $ln
        }
        $ln = $input.get;
    } # while !$input.eof #
    if $ln {
        if $ln ~~ rx/ ^ '#' ** {2 .. ∞} / {
            $output.say: $ln
        } elsif $ln ~~ rx/^ \h* $<key> = [ \w+ [ <-[\h]>+ \w+ ]* ] \h* $<type> = [ '-->' || ' =>' ] \h* $<path> = [ <-[ : # ]>+ ] \h* [ '#' \h* $<comment> = [ .* ] ]?  $/ {
            my Str:D $path = ~$<path>;
            $path         .=trim;
            my Str $line = sprintf "%-*s %-3s %-*s", $key-width, ~$<key>, ~$<type>, $dir-width, $path;
            with $<comment> {
                $line ~= " # $<comment>";
            }
            $output.say: $line;
        } elsif $ln ~~ rx/^ \h* '#' \h* $<key> = [ \w+ [ <-[\h]>+ \w+ ]* ] \h* $<type> = [ '-->' || ' =>' || 'sep' ] \h* $<path> = [ <-[ : # ]>+ ] \h* [ '#' \h* $<comment> = [ .* ] ]?  $/ {
            # do nothing we want to delete this #
        } else {
            $output.say: $ln
        }
    } # $ln #
    $input.close;
    $output.close;
    if "$config/pack.p_ck.new".IO.move: "$config/pack.p_ck" {
        return True;
    } else {
        die "move failed";
    }
} # sub empty-trash( --> Bool) is export #

sub undelete(Str:D $key-to-find --> Bool) is export {
    if %the-lot{$key-to-find}:exists {
        "key $key-to-find exists delete undelete would override it.".say;
        return False;
    }
    my IO::Handle:D $input  = "$config/pack.p_ck".IO.open:     :r, :nl-in("\n")   :chomp;
    my IO::Handle:D $output = "$config/pack.p_ck.new".IO.open: :w, :nl-out("\n"), :chomp(True);
    my Int:D $key-width        = 0;
    my Int:D $path-width       = 0;
    my Int:D $comment-width    = 0;
    my Str $ln;
    $ln = $input.get;
    while !$input.eof {
        if $ln ~~ rx/ ^ '#' ** {2 .. ∞} / {
        } elsif $ln ~~ rx/^ \s* $<key> = [ \w* [ <-[\h]>+ \w* ]* ] \h* $<type> = [ '-->' || ' =>' ] \h* $<path> = [ <-[ # ]>+ ] \h* [ '#' \h* $<comment> = [ .* ] ]?  $/ {
            my Str:D $path = ~$<path>;
            $path         .=trim;
            $key-width         = max($key-width,     wcswidth(~$<key>));
            $path-width        = max($path-width,    wcswidth($path));
            with $<comment> {
                $comment-width = max($comment-width, wcswidth(~$<comment>));
            }
        } elsif $ln ~~ rx/^ \h+ '#' \h* $<key> = [ \w* [ <-[\h]>+ \w* ]* ] \h* $<type> = [ '-->' || ' =>' || 'sep' ] \h* $<path> = [ <-[ : # ]>+ ] \h* [ '#' \h* $<comment> = [ .* ] ]? $/ {
            my Str:D $path = ~$<path>;
            $path         .=trim;
            $key-width         = max($key-width,     wcswidth('#' ~ ~$<key>));
            $path-width        = max($path-width,    wcswidth($path));
            with $<comment> {
                $comment-width = max($comment-width, wcswidth(~$<comment>));
            }
        }
        $ln = $input.get;
    } # while !$input.eof #
    if $ln {
        if $ln ~~ rx/ ^ '#' ** {2 .. ∞} / {
        } elsif $ln ~~ rx/^ \s* $<key> = [ \w* [ <-[\h]>+ \w* ]* ] \h* $<type> = [ '-->' || ' =>' ] \h* $<path> = [ <-[ : # ]>+ ] \h* [ '#' \h* $<comment> = [ .* ] ]?  $/ {
            my Str:D $path = ~$<path>;
            $path         .=trim;
            $key-width         = max($key-width,     wcswidth(~$<key>));
            $path-width        = max($path-width,    wcswidth($path));
            with $<comment> {
                $comment-width = max($comment-width, wcswidth(~$<comment>));
            }
        } elsif $ln ~~ rx/^ \h* '#' \h* $<key> = [ \w* [ <-[\h]>+ \w* ]* ] \h* $<type> = [ '-->' || ' =>' || 'sep' ] \h* $<path> = [ <-[ : # ]>+ ] \h* [ '#' \h* $<comment> = [ .* ] ]? $/ {
            my Str:D $path = ~$<path>;
            $path         .=trim;
            $key-width         = max($key-width,     wcswidth('#' ~ ~$<key>));
            $path-width        = max($path-width,    wcswidth($path));
            with $<comment> {
                $comment-width = max($comment-width, wcswidth(~$<comment>));
            }
        }
    } # $ln #
    #$key-width     += 2;
    #$path-width    += 2;
    #$comment-width += 2;
    $key-width = 20 if $key-width < 20;
    $path-width = 70 if $path-width < 70;
    $input.seek(0, SeekFromBeginning);
    $ln = $input.get;
    while !$input.eof {
        if $ln ~~ rx/ ^ '#' ** {2 .. ∞} / {
            $output.say: $ln
        } elsif $ln ~~ rx/^ \h* $<key> = [ \w+ [ <-[\h]>+ \w* ]* ] \h* $<type> = [ '-->' || ' =>' ] \h* $<path> = [ <-[ : # ]>+ ] \h* [ '#' \h* $<comment> = [ .* ] ]?  $/ {
            my Str:D $path = ~$<path>;
            $path         .=trim;
            my Str $line = sprintf "%-*s %-3s %-*s", $key-width, ~$<key>, ~$<type>, $path-width, $path;
            with $<comment> {
                $line ~= " # $<comment>";
            }
            $output.say: $line;
        } elsif $ln ~~ rx/^ \h* '#' \h* $<key> = [ \w+ [ <-[\h]>+ \w* ]* ] \h* $<type> = [ '-->' || ' =>' ] \h* $<path> = [ <-[ : # ]>+ ] \h* [ '#' \h* $<comment> = [ .* ] ]?  $/ {
            my Str:D $path = ~$<path>;
            $path         .=trim;
            my Str $line;
            if $key-to-find.trim eq (~$<key>).trim {
                $line = sprintf "%-*s %-3s %-*s", $key-width, ~$<key>, ~$<type>, $path-width, $path;
            } else {
                $line = sprintf "#%-*s %-3s %-*s", $key-width - 1, ~$<key>, ~$<type>, $path-width, $path;
            }
            with $<comment> {
                $line ~= " # $<comment>";
            }
            $output.say: $line;
        } else {
            $output.say: $ln
        }
        $ln = $input.get;
    } # while !$input.eof #
    if $ln {
        if $ln ~~ rx/ ^ '#' ** {2 .. ∞} / {
            $output.say: $ln
        } elsif $ln ~~ rx/^ \h* $<key> = [ \w+ [ <-[\h]>+ \w+ ]* ] \h* $<type> = [ '-->' || ' =>' ] \h* $<path> = [ <-[ : # ]>+ ] \h* [ '#' \h* $<comment> = [ .* ] ]?  $/ {
            my Str:D $path = ~$<path>;
            $path         .=trim;
            my Str $line = sprintf "%-*s %-3s %-*s", $key-width, ~$<key>, ~$<type>, $path-width, $path;
            with $<comment> {
                $line ~= " # $<comment>";
            }
            $output.say: $line;
        } elsif $ln ~~ rx/^ \h* '#' \h* $<key> = [ \w+ [ <-[\h]>+ \w+ ]* ] \h* $<type> = [ '-->' || ' =>' || 'sep' ] \h* $<path> = [ <-[ : # ]>+ ] \h* [ '#' \h* $<comment> = [ .* ] ]?  $/ {
            my Str:D $path = ~$<path>;
            $path         .=trim;
            my Str $line;
            if $key-to-find.trim eq (~$<key>).trim {
                $line = sprintf "%-*s %-3s %-*s", $key-width, ~$<key>, ~$<type>, $path-width, $path;
            } else {
                $line = sprintf "#%-*s %-3s %-*s", $key-width - 1, ~$<key>, ~$<type>, $path-width, $path;
            }
            with $<comment> {
                $line ~= " # $<comment>";
            }
            $output.say: $line;
        } else {
            $output.say: $ln
        }
    } # $ln #
    $input.close;
    $output.close;
    if "$config/pack.p_ck.new".IO.move: "$config/pack.p_ck" {
        return True;
    } else {
        die "move failed";
    }
} # sub undelete(Str:D $key-to-find --> Bool) is export #

sub stats(Str:D $prefix, Bool:D $colour, Bool:D $syntax, Regex:D $pattern --> Bool:D) is export {
    my Str:D @quanties = 'lines-total', 'header-lines', 'rows-of-hashes',
                          'empty-strs', 'comment-lines', 'commented',
                          'commented-dirs', 'lines', 'dirs';
    my @rows;
    for @quanties -> $quantity {
        my %row = quantity => $quantity, value => %stats{$quantity};
        @rows.push: %row;
    }
    my Str:D @fields     = 'quantity', 'value';
    my Str:D %fancynames = quantity => 'Quantity', value => 'Number';
    my Str:D %prompts    = lines-total => 'number of lines in file:',
                           header-lines => 'number of header lines in file:',
                           rows-of-hashes => 'rows of hashes in file:',
                           empty-strs => 'empty lines in file:',
                           comment-lines => 'comment lines:',
                           commented => 'trashed lines:',
                           commented-dirs => 'trashed dirs in db:',
                           lines => 'number of elts in db:',
                           dirs => 'number of dirs in db:';
    my %defaults;
    my $page-length = 30; # basically $page-length is redundant here. #
    sub include-row(Str:D $prefix, Regex:D $pattern, Int:D $idx, Str:D @fields, %row --> Bool:D) {
        my Str:D $value = ~(%prompts{%row«quantity»} // '');
        return True if $value.starts-with($prefix, :ignorecase) && $value ~~ $pattern;
        return False;
    } # sub include-row(Str:D $prefix, Regex:D $pattern, Int:D $idx, Str:D @fields, %row --> Bool:D) #
    sub head-value(Int:D $indx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) {
        #dd $indx, $field, $colour, $syntax, @fields;
        if $colour {
            if $syntax { 
                return t.color(0, 255, 255) ~ %fancynames{$field};
            } else {
                return t.color(0, 255, 255) ~ %fancynames{$field};
            }
        } else {
            return %fancynames{$field};
        }
    } # sub head-value(Int:D $indx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) #
    sub head-between(Int:D $indx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) {
        return ' ' x 5;
    } # sub head-between(Int:D $indx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) #
    sub field-value(Int:D $idx, Str:D $field, $value, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) {
        my Str:D $val = ~($value // ''); #`««« assumming $value is a Str:D »»»
        #dd $val, $value, $field;
        if $syntax {
            given $field {
                when 'quantity' { return t.color(255, 0, 0)   ~ %prompts{$val}; }
                when 'value'    { return t.color(255, 0, 255) ~ $val;           }
                default         { return t.color(255, 0, 0)   ~ $val;           }
            } # given $field #
        } elsif $colour {
            given $field {
                when 'quantity' { return t.color(0, 0, 255) ~ %prompts{$val}; }
                when 'value'    { return t.color(0, 0, 255) ~ $val;           }
                default         { return t.color(255, 0, 0) ~ $val;           }
            } # given $field #
        } else {
            given $field {
                when 'quantity' { return %prompts{$val}; }
                when 'value'    { return $val;           }
                default         { return $val;           }
            } # given $field #
        }
    } # sub field-value(Int:D $idx, Str:D $field, $value, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) #
    sub between(Int:D $idx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) {
        return ' ' x 5;
    } # sub between(Int:D $idx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) #
    sub row-formatting(Int:D $cnt, Bool:D $colour, Bool:D $syntax --> Str:D) {
        if $colour {
            if $syntax { 
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -3; # three heading lines. #
                return t.bg-color(0, 0, 127) ~ t.bold ~ t.bright-blue if $cnt == -2;
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -1;
                return (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,195,0)) ~ t.bold ~ t.bright-blue;
            } else {
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -3;
                return t.bg-color(0, 0, 127) ~ t.bold ~ t.bright-blue if $cnt == -2;
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -1;
                return (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,195,0)) ~ t.bold ~ t.bright-blue;
            }
        } else {
            return '';
        }
    } # sub row-formatting(Int:D $cnt, Bool:D $colour, Bool:D $syntax --> Str:D) #
    return list-by($prefix, $colour, $syntax, $page-length,
                  $pattern, @fields, %defaults, @rows,
                  :!sort,
                  :&include-row, 
                  :&head-value, 
                  :&head-between,
                  :&field-value, 
                  :&between,
                  :&row-formatting);
} # sub stats(Str:D $prefix, Bool:D $colour, Bool:D $syntax, Regex:D $pattern --> Bool:D) is export #

sub backup-db-file(Bool:D $use-windows-formating --> Bool) is export {
    my DateTime $now = DateTime.now;
    my Str:D $time-stamp = $now.Str;
    if $*DISTRO.is-win || $use-windows-formating {
        $time-stamp ~~ tr/./·/;
        $time-stamp ~~ tr/:/./;
    }
    return "$config/pack.p_ck".IO.copy("$config/pack.p_ck.$time-stamp".IO);
} # sub backup-db-file(Bool:D $use-windows-formating --> Bool) is export #

sub restore-db-file(IO::Path $restore-from --> Bool) is export {
    with $restore-from {
        my $actions = PathFileActions;
        if $restore-from ~~ :f {
            my @db-file = $restore-from.slurp.split("\n");
            return $restore-from.copy("$config/pack.p_ck".IO) if PathsFile.parse(@db-file.join("\x0A"), :enc('UTF-8'), :$actions).made;
        }
        return False;
    } else {
        return False;
    }
}

sub backups-menu-restore-db(Bool:D $colour, Bool:D $syntax, Str:D $message = "" --> Bool:D) is export {
    my IO::Path @backups = $config.IO.dir(:test(rx/ ^ 
                                                           'pack.p_ck.' \d ** 4 '-' \d ** 2 '-' \d ** 2
                                                               [ 'T' \d **2 [ [ '.' || ':' ] \d ** 2 ] ** {0..2} [ [ '.' || '·' ] \d+ 
                                                                   [ [ '+' || '-' ] \d ** 2 [ '.' || ':' ] \d ** 2 || 'z' ]?  ]?
                                                               ]?
                                                           $
                                                         /
                                                       )
                                                );
    #dd @backups;
    my $actions = PathFileActions;
    @backups .=grep: -> IO::Path $fl { 
                                my @file = $fl.slurp.split("\n");
                                PathsFile.parse(@file.join("\x0A"), :enc('UTF-8'), :$actions).made;
                            };
    #dd @backups;
    my $highlight-bg-colour = t.bg-color(0, 0, 107) ~ t.bold;
    my $highlight-fg-colour = t.color(255, 255, 0);
    my @Backups = @backups.map: -> IO::Path $f {
          my %elt = value => $f.Str, backup => $f.basename,
                      perms => symbolic-perms($f, :$colour, :$syntax, :highlight-fg-colour(''),
                                              :fg-colour0(''), :fg-colour1('')),
                      user => uid2username($f.user), group => gid2groupname($f.group),
                      size => format-bytes($f.s), modified => $f.modified.DateTime.local.Str;
          %elt;
    };
    @Backups .=sort( -> %lhs, %rhs { %lhs«value».IO.basename cmp %rhs«value».IO.basename });
    sub row(Int:D $cnt, Int:D $pos, @array,
                                     Bool:D :$colour = False, Bool:D :$syntax = False,
                                     Str:D :$highlight-bg-colour = '',
                                     Str:D :$highlight-fg-colour = '',
                                     Str:D :$bg-colour0 = '',
                                     Str:D :$fg-colour0 = '', 
                                     Str:D :$bg-colour1 = '',
                                     Str:D :$fg-colour1 = ''  --> Str:D) {
        my %r = @array[$cnt];
        if $syntax {
            if %r«value» eq 'cancel' {
                return %r«name» if %r«name»:exists;
                return %r«value»;
            } 
            my Str:D $name = %r«perms» ~ ' ';
            if $cnt == $pos {
                $name ~= $highlight-bg-colour ~ t.color(255, 0, 0)   ~ %r«size»     ~ ' ';
                $name ~= $highlight-bg-colour ~ t.color(255, 255, 0) ~ %r«user»     ~ ' ';
                $name ~= $highlight-bg-colour ~ t.color(255, 255, 0) ~ %r«group»    ~ ' ';
                $name ~= $highlight-bg-colour ~ t.color(0, 0, 255)   ~ %r«modified» ~ ' ';
                $name ~= $highlight-bg-colour ~ t.color(255, 0, 255) ~ %r«backup»   ~ ' ';
            } elsif $cnt %% 2 {
                $name ~= $bg-colour0 ~ t.color(255, 0, 0)   ~ %r«size»     ~ ' ';
                $name ~= $bg-colour0 ~ t.color(255, 255, 0) ~ %r«user»     ~ ' ';
                $name ~= $bg-colour0 ~ t.color(255, 255, 0) ~ %r«group»    ~ ' ';
                $name ~= $bg-colour0 ~ t.color(0, 0, 255)   ~ %r«modified» ~ ' ';
                $name ~= $bg-colour0 ~ t.color(255, 0, 255) ~ %r«backup»   ~ ' ';
            } else {
                $name ~= $bg-colour1 ~ t.color(255, 0, 0)   ~ %r«size»     ~ ' ';
                $name ~= $bg-colour1 ~ t.color(255, 255, 0) ~ %r«user»     ~ ' ';
                $name ~= $bg-colour1 ~ t.color(255, 255, 0) ~ %r«group»    ~ ' ';
                $name ~= $bg-colour1 ~ t.color(0, 0, 255)   ~ %r«modified» ~ ' ';
                $name ~= $bg-colour1 ~ t.color(255, 0, 255) ~ %r«backup»   ~ ' ';
            }
        } elsif $colour {
            if %r«value» eq 'cancel' {
                return %r«name» if %r«name»:exists;
                return %r«value»;
            } 
            my Str:D $name = %r«size» ~ ' ' ~ %r«user» ~ ' ' ~ %r«group» ~ ' ' ~ %r«modified» ~ ' ' ~ %r«backup»;
            if $cnt == $pos {
                return $highlight-bg-colour ~ %r«perms» ~ ' ' ~ $highlight-fg-colour ~ $name;
            } elsif $cnt %% 2 {
                return $bg-colour0          ~ %r«perms» ~ ' ' ~ $fg-colour0          ~ $name;
            } else {
                return $bg-colour1          ~ %r«perms» ~ ' ' ~ $fg-colour1          ~ $name;
            }
        } else {
            if %r«value» eq 'cancel' {
                return %r«name» if %r«name»:exists;
                return %r«value»;
            } 
            my Str:D $name = %r«perms» ~ ' ' ~ %r«size» ~ ' ' ~ %r«user» ~ ' ' ~ %r«group» ~ ' ' ~ %r«modified» ~ ' ' ~ %r«backup»;
            return $name;
        }
    }
    my Str $file = menu(@Backups, $message, :&row, :$colour, :$syntax, :$highlight-bg-colour, :$highlight-fg-colour, :wrap-around);
    return False without $file;
    return False if $file eq '';
    return False if $file eq 'cancel';
    return restore-db-file($file.IO);
} # sub backups-menu-restore-db(Bool:D $colour, Bool:D $syntax, Str:D $message = "" --> Bool:D) is export #

sub list-db-backups(Str:D $prefix,
                    Bool:D $colour is copy,
                    Bool:D $syntax,
                    Regex:D $pattern,
                    Int:D $page-length --> Bool:D) is export {
    $colour = True if $syntax;
    my IO::Path @backups = $config.IO.dir(:test(rx/ ^ 'pack.p_ck.' \d ** 4 '-' \d ** 2 '-' \d ** 2
                                                               [ 'T' \d **2 [ [ '.' || ':' ] \d ** 2 ] ** {0..2} [ [ '.' || '·' ] \d+ 
                                                                   [ [ '+' || '-' ] \d ** 2 [ '.' || ':' ] \d ** 2 || 'z' ]?  ]?
                                                               ]?
                                                           $
                                                         /
                                                       )
                                                );
    #dd @backups;
    my $actions = PathFileActions;
    @backups .=grep: -> IO::Path $fl { 
                                my @file = $fl.slurp.split("\n");
                                PathsFile.parse(@file.join("\x0A"), :enc('UTF-8'), :$actions).made;
                            };
    @backups .=sort;
    my @_backups = @backups.map: -> IO::Path $f {
          my %elt = backup => $f.basename, perms => symbolic-perms($f, :$colour, :$syntax),
                      user => $f.user, group => $f.group, size => $f.s, modified => $f.modified;
          %elt;
      };
    #dd @backups;
    my Str:D @fields = 'perms', 'size', 'user', 'group', 'modified', 'backup';
    my       %defaults;
    my Str:D %fancynames = perms => 'Permissions', size => 'Size',
                             user => 'User', group => 'Group',
                             modified => 'Date Modified', backup => 'Backup';
    sub include-row(Str:D $prefix, Regex:D $pattern, Int:D $idx, Str:D @fields, %row --> Bool:D) {
        my Str:D $value = ~(%row«backup» // '');
        return True if $value.starts-with($prefix, :ignorecase) && $value ~~ $pattern;
        return False;
    } # sub include-row(Str:D $prefix, Regex:D $pattern, Int:D $idx, Str:D @fields, %row --> Bool:D) #
    sub head-value(Int:D $indx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) {
        #dd $indx, $field, $colour, $syntax, @fields;
        if $colour {
            if $syntax { 
                return t.color(0, 255, 255) ~ %fancynames{$field};
            } else {
                return t.color(0, 255, 255) ~ %fancynames{$field};
            }
        } else {
            return %fancynames{$field};
        }
    } # sub head-value(Int:D $indx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) #
    sub head-between(Int:D $indx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) {
        return ' ';
    } # sub head-between(Int:D $indx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields --> Str:D) #
    sub field-value(Int:D $idx, Str:D $field, $value, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) {
        my Str:D $val = ~($value // ''); #`««« assumming $value is a Str:D »»»
        #dd $val, $value, $field;
        if $syntax {
            given $field {
                when 'perms'    { return $val; }
                when 'size'     {
                    my Int:D $size = +$value;
                    return t.color(255, 0, 0) ~ format-bytes($size);
                }
                when 'user'     { return t.color(255, 255, 0) ~ uid2username(+$value);    }
                when 'group'    { return t.color(255, 255, 0) ~ gid2groupname(+$value);   }
                when 'modified' {
                    my Instant:D $m = +$value;
                    my DateTime:D $dt = $m.DateTime.local;
                    return t.color(0, 0, 235) ~ $dt.Str;  
                }
                when 'backup'   { return t.color(255, 0, 255) ~ $val; }
                default         { return t.color(255, 0, 0) ~ $val;   }
            } # given $field #
        } elsif $colour {
            given $field {
                when 'perms'    { return $val; }
                when 'size'     {
                    my Int:D $size = +$value;
                    return t.color(0, 0, 255) ~ format-bytes($size);
                }
                when 'user'     { return t.color(0, 0, 255) ~ uid2username(+$value);    }
                when 'group'    { return t.color(0, 0, 255) ~ gid2groupname(+$value);   }
                when 'modified' {
                    my Instant:D $m = +$value;
                    my DateTime:D $dt = $m.DateTime.local;
                    return t.color(0, 0, 255) ~ $dt.Str;  
                }
                when 'backup'   { return t.color(0, 0, 255) ~ $val;   }
                default         { return t.color(255, 0, 0) ~ $val;   }
            } # given $field #
        } else {
            given $field {
                when 'perms'    { return $val; }
                when 'size'     {
                    my Int:D $size = +$value;
                    return format-bytes($size);
                }
                when 'user'     { return uid2username(+$value);    }
                when 'group'    { return gid2groupname(+$value);   }
                when 'modified' {
                    my Instant:D $m = +$value;
                    my DateTime:D $dt = $m.DateTime.local;
                    return $dt.Str;  
                }
                when 'backup'   { return $val;   }
                default         { return $val;   }
            } # given $field #
        }
    } # sub field-value(Int:D $idx, Str:D $field, $value, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) #
    sub between(Int:D $idx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) {
        return ' ';
    } # sub between(Int:D $idx, Str:D $field, Bool:D $colour, Bool:D $syntax, Str:D @fields, %row --> Str:D) #
    sub row-formatting(Int:D $cnt, Bool:D $colour, Bool:D $syntax --> Str:D) {
        if $colour {
            if $syntax { 
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -3; # three heading lines. #
                return t.bg-color(0, 0, 127) ~ t.bold ~ t.bright-blue if $cnt == -2;
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -1;
                return (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,195,0)) ~ t.bold ~ t.bright-blue;
            } else {
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -3;
                return t.bg-color(0, 0, 127) ~ t.bold ~ t.bright-blue if $cnt == -2;
                return t.bg-color(255, 0, 255) ~ t.bold ~ t.bright-blue if $cnt == -1;
                return (($cnt % 2 == 0) ?? t.bg-yellow !! t.bg-color(0,195,0)) ~ t.bold ~ t.bright-blue;
            }
        } else {
            return '';
        }
    } # sub row-formatting(Int:D $cnt, Bool:D $colour, Bool:D $syntax --> Str:D) #
    return list-by($prefix, $colour, $syntax, $page-length,
                  $pattern, @fields, %defaults, @_backups,
                  :!sort,
                  :&include-row, 
                  :&head-value, 
                  :&head-between,
                  :&field-value, 
                  :&between,
                  :&row-formatting);
} #`««« sub list-db-backups(Str:D $prefix,
                            Bool:D $colour is copy,
                            Bool:D $syntax,
                            Regex:D $pattern,
                            Int:D $page-length --> Bool:D) is export »»»

my Str  $schema;
my Str  $podir;
my Str  $gettext-domain;
my Str  $package-dir;
my Str  $out-dir;
my Bool $force-file;
my      @extra-sources;
my Int  $exitcode-val;

sub read-file(Str $dir --> Bool) is export {
    die "file $dir/.pack_args.json does not exist" unless "$dir/.pack_args.json".IO ~~ :f;
    my $file-cont         = "$dir/.pack_args.json".IO.slurp(:utf8);
    my $data              = from-json $file-cont;
    $schema               = %$data«schema» // Str;
    $podir                = %$data«podir» // Str;
    $gettext-domain       = %$data«gettext-domain» // Str;
    $package-dir          = %$data«package-dir» // Str;
    $out-dir              = %$data«out-dir» // Str;
    $force-file           = %$data«force» // Bool;
    my $extra             = %$data«extra-sources»;
    @extra-sources        = @$extra;
    return True;
}

sub pack(Str $dir, Bool $silent, Bool $force is copy = False --> Bool) is export {
    $force              ||= $force-file;
    my @cmd = qqww{gnome-extensions pack};
    for @extra-sources -> $extra {
        push @cmd, "--extra-source=$extra";  
    }
    push @cmd, "--schema=$schema" with $schema;
    push @cmd, "--podir=$podir" with $podir;
    push @cmd, "--gettext-domain=$gettext-domain" with $gettext-domain;
    push @cmd, "--force" if $force;
    push @cmd, "--out-dir=$out-dir" with $out-dir;
    $package-dir = $dir without $package-dir;
    $package-dir = $dir if $dir.contains('/');
    push @cmd, "$package-dir";
    (@cmd.join(' ') ~ "\n").say unless $silent;
    my Proc $res = run @cmd;
    $exitcode-val = $res.exitcode;
    return $res.exitcode == 0;
}

sub exitcode(--> int) is export {
    return $exitcode-val;
}

sub create-config(Str:D $package-dir,
                  Str $schema,
                  Str $podir,
                  Str $gettext-domain,
                  Str $out-dir,
                  Bool:D $force,
                  @extra-sources --> Bool) is export {
    my %data              = extra-sources => [ |@extra-sources ];
    %data«schema»         = $schema with $schema;
    %data«podir»          = $podir with $podir;
    %data«gettext-domain» = $gettext-domain with $gettext-domain;
    %data«package-dir»    = $package-dir.IO.basename;
    %data«out-dir»        = "$out-dir".IO.absolute.IO.resolve(:completely).Str;
    %data«force»          = $force;
    "$package-dir/.pack_args.json".IO.spurt(to-json(%data, :pretty, :spacing(4), :sorted-keys));
    return True;                                                                                                                                                                                                                                    
}

sub add(Str $dir,
        Str $_schema,
        Str $_podir,
        Str $_gettext-domain,
        Str $_out-dir,
        Bool:D $_force is copy,
        Bool:D $stomp-force,
        Bool:D $stomp,
        @_extra-sources --> Bool) is export {
    read-file($dir);
    push @extra-sources, |@_extra-sources if @_extra-sources;
    if $stomp {
        @extra-sources         = @_extra-sources;
    }
    @extra-sources             = @extra-sources.sort.squish;
    $package-dir               = $dir.IO.absolute.IO.resolve(:completely).basename without $package-dir;
    $schema                    = $_schema with $_schema;
    $podir                     = $_podir with $_podir;
    $gettext-domain            = $_gettext-domain with $_gettext-domain;
    $out-dir                   = $_out-dir.IO.absolute.IO.resolve(:completely).Str with $_out-dir;
    unless $stomp-force {
        $_force                = $force-file unless $_force;
    }
    my $data                   = { extra-sources => [ |@extra-sources ],  };
    with $schema {
        %$data«schema»         = $schema;
    }
    with $podir {
        %$data«podir»          = $podir;
    }
    with $gettext-domain {
        %$data«gettext-domain» = $gettext-domain;
    }
    with $package-dir {
        %$data«package-dir»    = $package-dir;
    }
    with $out-dir {
        %$data«out-dir»        = "$out-dir".IO.absolute.IO.resolve(:completely).Str;
    }
    %$data«force»              = $_force;
    "$dir/.pack_args.json".IO.spurt(to-json($data, :pretty, :spacing(4), :sorted-keys));
    return True;                                                                                                                                                                                                                                    
}

sub set-package-dir($dir, $package-dir-value) is export {
    read-file($dir);
    $package-dir               = $package-dir-value.IO.basename;
    my $data                   = { extra-sources => [ |@extra-sources ],  };
    with $schema {
        %$data«schema»         = $schema;
    }
    with $podir {
        %$data«podir»          = $podir;
    }
    if $gettext-domain {
        %$data«gettext-domain» = $gettext-domain;
    }
    if $package-dir {
        %$data«package-dir»    = $package-dir;
    }
    with $out-dir {
        %$data«out-dir»        = "$out-dir".IO.absolute.IO.resolve(:completely).Str;
    }
    %$data«force»              = $force-file;
    "$dir/.pack_args.json".IO.spurt(to-json($data, :pretty, :spacing(4), :sorted-keys));
    return True;                                                                                                                                                                                                                                    
}

sub remove(Str $package-dir, Str $name --> Bool) is export {
    die "file $package-dir/.pack_args.json does not exist" unless "$package-dir/.pack_args.json".IO ~~ :f;
    my $file-cont         = "$package-dir/.pack_args.json".IO.slurp(:utf8);
    my $data              = from-json $file-cont;
    if $name ne 'extra-sources' && $name ne 'package-dir' {
        %$data{$name}:delete if %$data{$name}:exists;
    } elsif $name eq 'extra-sources' {
        %$data«extra-sources» = [];
    } else {
        "Error: deleting package-dir is not permitted!".say;
    }
    "$package-dir/.pack_args.json".IO.spurt(to-json($data, :pretty, :spacing(4), :sorted-keys));
    return True;                                                                                                                                                                                                                                    
}

sub get(Str $package-dir, Str $name --> Bool) is export {
    die "file $package-dir/.pack_args.json does not exist" unless "$package-dir/.pack_args.json".IO ~~ :f;
    my $file-cont         = "$package-dir/.pack_args.json".IO.slurp(:utf8);
    my $data              = from-json $file-cont;
    if %$data{$name}:exists { 
        %$data{$name}.say;
    } else {
        return False;
    }
    return True;                                                                                                                                                                                                                                    
}

sub get-multi-line-value(Str:D $prompt --> Str) is export {
    my Str $result = '';
    my Str $input;
    my Str $last;
    $prompt.say;
    "terminate with two empty lines.".say;
    my Int:D $cnt = 0;
    repeat {
        $cnt++;
        $last  = $input;
        $input = prompt "$cnt> ";
        $input = $input.chomp with $input;
        $result ~= "$input\n" unless $input eq '' && $last eq '';
    } until $input eq '' && $last eq '';
    return $result.trim;
} # sub get-multi-line-value(Str:D $prompt --> Str) is export #

sub make-schema(IO::Path $plugin-location, Str:D $gettext-domain, Str:D $schema,
                    Bool:D $silent, Bool:D $backtrace --> Bool:D) is export {
    CATCH {
        when X::IO::Chmod, X::IO::Mkdir, X::AdHoc {
            if !$silent {
                $*ERR.say: .message;
                if $backtrace {
                    for .backtrace.reverse {
                        next if .file.starts-with('SETTING::');
                        next unless .subname;
                        $*ERR.say: "  in block {.subname} at {.file} line {.line}";
                    } # for .backtrace.reverse #
                } # if $backtrace #
            }
            return False;
        }
    }
    $plugin-location.mkdir;
    my Str:D $data = qq[<schemalist gettext-domain="$gettext-domain">\n    <enum id="org.gnome.shell.extensions.{$gettext-domain}.area">\n        <value value="0" nick="left"/>\n        <value value="1" nick="center"/>\n        <value value="2" nick="right"/>\n    </enum>\n    <schema path="/org/gnome/shell/extensions/$gettext-domain/" id="org.gnome.shell.extensions.$gettext-domain">\n        <key name="area" enum="org.gnome.shell.extensions.{$gettext-domain}.area">\n            <default>'left'</default>\n            <summary>The panel area to place the button.</summary>\n        </key>\n        <key type="i" name="position">\n            <default>0</default>\n            <summary>The position in the area.</summary>\n            <description>The position to place the button in the area 0 to 25.</description>\n        </key>\n    </schema>\n</schemalist>];
    my IO::Path $sc = $plugin-location.add($schema).resolve;
    $sc.spurt($data); 
    return $sc.chmod(0b110_110_100);
} #`«« sub make-schema(IO::Path $plugin-location, Str:D $gettext-domain,
                    Bool:D $silent, Bool:D $backtrace --> Bool:D) is export »»

sub make-compile-sh(IO::Path $plugin-location, Str:D $gettext-domain, Str:D $dev-lang, Bool:D $prefs,
                    @extra-sources, Bool:D $run, Bool:D $silent, Bool:D $backtrace --> Bool:D) is export {
    CATCH {
        when X::IO::Chmod, X::AdHoc {
            if !$silent {
                $*ERR.say: .message;
                if $backtrace {
                    for .backtrace.reverse {
                        next if .file.starts-with('SETTING::');
                        next unless .subname;
                        $*ERR.say: "  in block {.subname} at {.file} line {.line}";
                    } # for .backtrace.reverse #
                } # if $backtrace #
            }
            return False;
        }
    }
    my Str:D $args = 'extension.js';
    $args ~= ' prefs.js' if $prefs;
    $args ~= ' ' ~ @extra-sources.join(' ') if @extra-sources;
    my Str:D $data = qq«#!/bin/bash

glib-compile-schemas schemas

DIR="po"
SUFFIX="po"

xgettext --from-code='utf-8' -k_ -kN_ -o \$DIR/{$gettext-domain}.pot $args

if ! [ -x "\$DIR"/{$dev-lang}.\$SUFFIX ]
then
    msginit --input=po/{$gettext-domain}.pot --output-file=po/{$dev-lang}.po --no-translator
else
    for file in "\$DIR"/*.\$SUFFIX 
    do
        msgmerge --previous --update po/\$file po/{$gettext-domain}.pot
    done
fi

for file in "\$DIR"/*.\$SUFFIX
do 
	lingua=\$\{file%.*\}
	lingua=\$\{lingua#*/\}
	msgfmt \$file
	mkdir locale/\$lingua/LC_MESSAGES -p
	mv messages.mo locale/\$lingua/LC_MESSAGES/{$gettext-domain}.mo
done
»;
    my IO::Path $path_ = $plugin-location.add('compile.sh');
    $path_.spurt($data);
    my Bool:D $result = $path_.chmod(0b111_111_101);
    if $run {
        my @rem = qqww[bash -c];
        push @rem, qq[cd '{$path_.dirname}' && ./compile.sh];
        my Proc $r = run @rem;
        return $r.exitcode === 0;
    }
    return $result;
} #`«« sub make-compile-sh(IO::Path $plugin-location, Str:D $gettext-domain, Str:D $dev-lang, Bool:D $prefs,
                    @extra-sources, Bool:D $run, Bool:D $silent, Bool:D $backtrace --> Bool:D) is export »»

sub new-plugin(Str:D $key, Str $uuid is copy, Str $name is copy, Str $description is copy,
                Str $gettext-domain is copy, Str $settings-schema is copy, Str $template,
                Bool:D $prefs is copy, Bool:D $schema-file, Bool:D $podirs, Bool:D $force,
                Str:D $home, Str:D $xdg_config_home, Bool:D $silent, Bool:D $backtrace, Str:D $dev-lang,
                Str:D $dev-dir --> Bool:D) is export {
    my Str:D $extensions = $xdg_config_home ~ '/gnome-shell/extensions';
    without $uuid {
        while !$uuid {
            $uuid = prompt "uuid: ";
            "Please supply a valid unique identifier".say  unless $uuid;
        }
    }
    without $name {
        my Str $name_;
        with $uuid {
            $name_ = $uuid.substr(0, $uuid.index('@'));
        }
        my Str $input;
        while !$name {
            $input = prompt "name: $name_? hit enter to accept or type in new value followed by enter.";
            with $input {
                $input = $input.chomp;
                if $input eq '' {
                    $name = $name_;
                } elsif $input {
                    $name = $input;
                }
            }
            "Please supply a valid name".say  unless $name;
        }
    }
    without $description {
        while !$description {
            $description = get-multi-line-value("Please enter a multi line description!");
            "Please supply a valid description".say unless $description;
        }
    }
    without $gettext-domain {
        my Str $gettext-domain_;
        with $name {
            $gettext-domain_ = $name;
        }
        my Str $input;
        while !$gettext-domain {
            $input = prompt "name: $gettext-domain_? hit enter to accept or type in new value followed by enter.";
            with $input {
                $input = $input.chomp;
                if $input eq '' {
                    $gettext-domain = $gettext-domain_;
                } elsif $input {
                    $gettext-domain = $input;
                }
            }
            "Please supply a valid gettext-domain".say  unless $gettext-domain;
        }
    }
    without $settings-schema {
        my Str $settings-schema_;
        with $name {
            $settings-schema_ = $name;
        } orwith $gettext-domain {
            $settings-schema_ = $gettext-domain;
        }
        my Str $input;
        while !$name {
            $input = prompt "name: $settings-schema_? hit enter to accept or type in new value followed by enter.";
            with $input {
                $input = $input.chomp;
                if $input eq '' {
                    $settings-schema = $settings-schema_;
                } elsif $input {
                    $settings-schema = $input;
                }
            }
            "Please supply a valid settings-schema".say  unless $settings-schema;
        }
    }
    my @cmd = qqww[gnome-extensions create];
    push @cmd, "--uuid=$uuid" if $uuid;
    push @cmd, "--name=$name" if $name;
    if $description {
        $description ~~ s:g/\n/\\n/;
        push @cmd, qq[--description="$description"];
    }
    push @cmd, "--gettext-domain=$gettext-domain" if $gettext-domain;
    push @cmd, "--settings-schema=$settings-schema" if $settings-schema;
    push @cmd, "--template='$template'" with $template;
    push @cmd, "--prefs" if $prefs;
    push @cmd, "--interactive" without $template;
    push @cmd, "--quiet"; # don't complain when editor cannot find plugin #
    @cmd.join(' ').say unless $silent;
    my Proc $res = run @cmd;
    $exitcode-val = $res.exitcode;
    if $res.exitcode == 0 {
        my $path = "$xdg_config_home/gnome-shell/extensions/$uuid";
        if $path.IO ~~ :d {
            if copypath($path.IO, $dev-dir.IO) {
                "copypath Success".say;
                if add-path($key, "$dev-dir/$uuid", False, $description) {
                    qq[key: $key => "$dev-dir/$uuid" added successfully].say;
                } else {
                    qq[key: $key => "$dev-dir/$uuid" Failed to add].say;
                } 
                my @extra-sources;
                my Str $schema = Str;
                if $schema-file {
                    my IO::Path $sc = $dev-dir.IO.add($uuid).add('schemas').resolve;
                    $schema = "org.gnome.shell.extensions.{$gettext-domain}.gschema.xml";
                    make-schema($sc, $gettext-domain, $schema, $silent, $backtrace);
                } # if $schema-file #
                my Str $podir = Str;
                if $podirs {
                    $podir = 'po';
                    $dev-dir.IO.add($uuid).add($podir).resolve.mkdir;
                    my @extra-sources;
                    make-compile-sh($dev-dir.IO.add($uuid).resolve, $gettext-domain,
                                                $dev-lang, $prefs, @extra-sources, True, $silent, $backtrace);
                } # if $podirs #
                if create-config($dev-dir.IO.add($uuid).resolve.path, $schema, $podir,
                                 $gettext-domain, $dev-dir, $force, @extra-sources) {
                    ".pack_args.json created".say;
                } else {
                    ".pack_args.json creation Failed".say;
                }
                if prunepath($path.IO) {
                    "removed directory".say;
                } else {
                    "could not remove directory".say;
                }
            } else { # if copypath($path.IO, $dev-dir.IO) #
                "copy failed".say;
            }
        } else { # if $path.IO ~~ :d #
            "$path does not exist or is not a directory".say;
        }
        return True;
    } else {# if $res.exitcode === 0 #
        "Failed".say;
        return False;
    }
} #`«« sub new-plugin(Str:D $key, Str $uuid is copy, Str $name is copy, Str $description is copy,
                Str $gettext-domain is copy, Str $settings-schema is copy, Str $template is copy,
                Bool:D $prefs is copy, Str:D $home, Str:D $xdg_config_home, Bool:D $silent,
                Str:D $dev-dir --> Bool:D) is export »»

sub add-plugin(Str:D $key, Str:D $plugin-dir, Str:D $uuid, Str $podir is copy, Bool:D $force,
                $home, Str:D $xdg_config_home, Bool:D $silent, Bool:D $backtrace, Str:D $dev-lang,
                Bool:D $mk-schema, @extra-sources --> Bool:D) is export {
    CATCH {
        when X::IO::Chmod, X::IO::Mkdir, X::AdHoc {
            if !$silent {
                $*ERR.say: .message;
                if $backtrace {
                    for .backtrace.reverse {
                        next if .file.starts-with('SETTING::');
                        next unless .subname;
                        $*ERR.say: "  in block {.subname} at {.file} line {.line}";
                    } # for .backtrace.reverse #
                } # if $backtrace #
            }
            return False;
        }
    }
    my $plugin-location    = $plugin-dir.IO.add($uuid).resolve;
    my $file-cont          = $plugin-location.add('metadata.json').slurp(:utf8);
    my $data               = from-json $file-cont;
    my Str $gettext-domain = %$data«gettext-domain» // Str; 
    without $gettext-domain {
        $*ERR.say: "gettext-domain missing in metadata.json; please fix!";
        return False;
    }
    my Str $schema         = %$data«settings-schema» // Str; 
    with $schema {
        if $plugin-location.add('schemas').resolve.add("{$schema}.gschema.xml") ~~ :f {
            $schema         = "schemas/$schema";
        } elsif $mk-schema {
            make-schema($plugin-location.add('schema').resolve, $gettext-domain, $schema, $silent, $backtrace);
        }
    } elsif $mk-schema {
        $schema = "org.gnome.shell.extensions.{$gettext-domain}";
        make-schema($plugin-location.add('schemas').resolve, $gettext-domain, "$schema.gschema.xml", $silent, $backtrace);
        %$data«settings-schema» = $schema;
        $plugin-location.add('metadata.json').spurt(to-json($data, :pretty, :spacing(4), :sorted-keys));
    }
    $podir = Str unless $plugin-location.add($podir).resolve ~~ :d;
    with $podir {
        unless $plugin-location.add('compile.sh') ~~ :f {
            my Bool:D $prefs = $plugin-location.add('prefs.js') ~~ :f;
            make-compile-sh($plugin-location, $gettext-domain, $dev-lang,
                                        $prefs, @extra-sources, True, $silent, $backtrace);
        }
    }
    my Str $description = %$data«description» // Str; 
    if add-path($key, $plugin-location.Str, False, $description) {
        qq[key: $key => "$plugin-dir/$uuid" added successfully].say;
    } else {
        qq[key: $key => "$plugin-dir/$uuid" Failed to add].say;
    } 
    if create-config($plugin-location.path, $schema, $podir,
                     $gettext-domain, $plugin-dir, $force, @extra-sources) {
        ".pack_args.json created".say;
    } else {
        ".pack_args.json creation Failed".say;
    }
} #`«« sub add-plugin(Str:D $key, Str:D $plugin-dir, Str:D $uuid, Str $podir is copy, Bool:D $force,
                $home, Str:D $xdg_config_home, Bool:D $silent, Str:D $dev-lang, Str:D $dev-dir,
                @extra-sources --> Bool:D) is export »»
