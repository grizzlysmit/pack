#!/usr/bin/env raku

use v6;
use JSON::Fast;
use ECMA262Regex;

my %*SUB-MAIN-OPTS;
%*SUB-MAIN-OPTS«named-anywhere» = True;
#%*SUB-MAIN-OPTS<bundling>       = True;

use Gzz::Text::Utils;
#use Syntax::Highlighters;
use GUI::Editors;
use Usage::Utils;
use Pack;


=begin pod

=head1 App::pack
=head1 Module Pack

=begin head2

Table of  Contents

=end head2

=item1 L<NAME|#name>
=item1 L<AUTHOR|#author>
=item1 L<VERSION|#version>
=item1 L<TITLE|#title>
=item1 L<SUBTITLE|#subtitle>
=item1 L<COPYRIGHT|#copyright>
=item1 L<Introduction|#introduction>
=item2 L<Motivation|#motivation>
=item1 L<Fix|#fix>


=NAME App::pack 
=AUTHOR Francis Grizzly Smit (grizzly@smit.id.au)
=VERSION v0.1.0
=TITLE pack
=SUBTITLE A Raku program to manage the use of B<gnome-extensions pack>, it has too many arguments this makes it easy.

=COPYRIGHT
GPL V3.0+ L<LICENSE|https://github.com/grizzlysmit/Usage-Utils/blob/main/LICENSE>

L<Top of Document|#table-of-contents>

=head1 Introduction

This is a Raku program to manage the use of B<gnome-extensions pack>, it has too many arguments this makes it easy. 

=head2 Motivation

The command B<gnome-extensions pack> has too many arguments this takes care of that making it easier to package
up your gnome-shell extensions. 

=head3 pack

=begin code :lang<bash>

pack.raku --help
                                                                                                                                                                                           
Usage:                                                                                                                                                                                     
  pack.raku do <dir>   [-f|--force]
  pack.raku create <package-dir>  [<extra-sources> ...] [-s|--schema=<Str>] [-p|--podir=<Str>] [-g|--gettext-domain=<Str>] [-o|--out-dir=<Str>] [-f|--force]
  pack.raku add <package-dir>  [<extra-sources> ...] [-s|--schema=<Str>] [-p|--podir=<Str>] [-g|--gettext-domain=<Str>] [-o|--out-dir=<Str>] [-f|--force] [-F|--stomp-force] [-S|--stomp]
  pack.raku set schema <package-dir> <schema-value>
  pack.raku set podir <package-dir> <podir-value>
  pack.raku set gettext-domain <package-dir> <gettext-domain-value>
  pack.raku set out-dir <package-dir> <out-dir-value>
  pack.raku set force <package-dir> <force-value>
  pack.raku add-extra-sources <package-dir>  [<extra-sources> ...]
  pack.raku set package-dir <package-dir> <package-dir-value>
  pack.raku set extra-sources <package-dir>  [<extra-sources> ...]
  pack.raku append extra-sources <package-dir>  [<extra-sources> ...]
  pack.raku remove schema <package-dir>
  pack.raku remove podir <package-dir>
  pack.raku remove gettext-domain <package-dir>
  pack.raku remove out-dir <package-dir>
  pack.raku remove extra-sources <package-dir>
  pack.raku get schema <package-dir>
  pack.raku get podir <package-dir>
  pack.raku get gettext-domain <package-dir>
  pack.raku get out-dir <package-dir>
  pack.raku get extra-sources <package-dir>
  pack.raku get force <package-dir>
  pack.raku get package-dir <package-dir>
  pack.raku alias add <key> <target>   [-s|--set|--force] [-c|--comment=<Str>]
  pack.raku alias do <key>   [-f|--force]
  pack.raku edit configs
  pack.raku list keys  [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
  pack.raku list all  [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
  pack.raku delete   [<keys> ...] [-d|--delete|--do-not-trash
  pack.raku del   [<keys> ...] [-d|--delete|--do-not-trash]
  pack.raku trash   [<keys> ...]
  pack.raku tidy file
  pack.raku comment <key> <comment>   [-k|--kind=<Str where \{ ... } >]
  pack.raku list trash  [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
  pack.raku empty trash
  pack.raku undelete   [<keys> ...]
  pack.raku show stats  [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
  pack.raku show statistics  [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
  pack.raku backup db    [-w|--win-format|--use-windows-formating]
  pack.raku restore db  [<restore-from>]
  pack.raku menu restore db  [<message>]  [-c|--color|--colour] [-s|--syntax]
  pack.raku list db backups  [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
  pack.raku list editors    [-f|--prefix=<Str>] [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
  pack.raku editors stats  [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
  pack.raku list editors backups  [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
  pack.raku backup editors    [-w|--use-windows-formatting]
  pack.raku restore editors <restore-from>
  pack.raku set editor <editor> [<comment>]
  pack.raku set override GUI_EDITOR <value> [<comment>]
  pack.raku menu restore editors  [<message>]  [-c|--color|--colour] [-s|--syntax]

=end code

=begin code :lang<bash>

pack.raku do --help
Usage:
  pack.raku do <dir> [-f|--force]

=end code


=end pod

multi sub MAIN('do', Str:D $dir, Bool:D :f(:$force) is copy = False --> int){
    read-file($dir);
    if pack($dir, $force) {
        return 0;
    } else {
        die "run exited with a bad value {exitcode}";
    }
}

multi sub MAIN('create',
                Str:D $package-dir,
                Str :s(:$schema) = Str,
                Str :p(:$podir) = Str,
                Str :g(:$gettext-domain) = Str,
                Str:D :o(:$out-dir) = '.',
                Bool:D :f(:$force) = False,
                *@extra-sources --> int){
    die "Error: unkown" unless create-config($package-dir,
                                             $schema, $podir,
                                             $gettext-domain,
                                             $out-dir, $force,
                                             @extra-sources);
    return 0;
}

multi sub MAIN('add',
                Str $package-dir,
                Str :s(:$schema) = 'Null',
                Str :p(:$podir) = 'Null',
                Str :g(:$gettext-domain) = 'Null',
                Str :o(:$out-dir) = '.',
                Bool :f(:$force) = False,
                Bool :F(:$stomp-force) = False,
                Bool :S(:$stomp) = False,
                *@extra-sources --> int){
    die "Error: unkown" unless add($package-dir,
                                   $schema,
                                   $podir,
                                   $gettext-domain,
                                   $out-dir,
                                   $force,
                                   $stomp-force,
                                   $stomp,
                                   @extra-sources);
    return 0;
}

multi sub MAIN('set', 'schema', Str $package-dir, Str $schema-value --> int){
    die "Error: unkown" unless add($package-dir, $schema-value, 'Null', 'Null', 'Null', False, False, False, ());
    return 0;
}

multi sub MAIN('set', 'podir', Str $package-dir, Str $podir-value --> int){
    die "Error: unkown" unless add($package-dir, 'Null', $podir-value, 'Null', 'Null', False, False, False, ());
    return 0;
}

multi sub MAIN('set', 'gettext-domain', Str $package-dir, Str $gettext-domain-value --> int){
    die "Error: unkown" unless add($package-dir, 'Null', 'Null', $gettext-domain-value, 'Null', False, False, False, ());
    return 0;
}

multi sub MAIN('set', 'out-dir', Str $package-dir, Str $out-dir-value --> int){
    die "Error: unkown" unless add($package-dir, 'Null', 'Null', 'Null', $out-dir-value, False, False, False, ());
    return 0;
}

multi sub MAIN('set', 'force', Str $package-dir, Bool $force-value --> int){
    die "Error: unkown" unless add($package-dir, 'Null', 'Null', 'Null', 'Null', $force-value, True, False, ());
    return 0;
}

multi sub MAIN('add-extra-sources', Str $package-dir, *@extra-sources --> int){
    die "Error: unkown" unless add($package-dir, 'Null', 'Null', 'Null', 'Null', False, False, False, @extra-sources);
    return 0;
}

multi sub MAIN('set', 'package-dir', Str $package-dir, Str $package-dir-value --> int){
    die "Error: unkown" unless set-package-dir($package-dir, $package-dir-value);
    return 0;
}

multi sub MAIN('set', 'extra-sources', Str $package-dir, *@extra-sources --> int){
    die "Error: unkown" unless add($package-dir, 'Null', 'Null', 'Null', 'Null', False, False, True, @extra-sources);
    return 0;
}

multi sub MAIN('append', 'extra-sources', Str $package-dir, *@extra-sources --> int){
    die "Error: unkown" unless add($package-dir, 'Null', 'Null', 'Null', 'Null', False, False, False, @extra-sources);
    return 0;
}

multi sub MAIN('remove', 'schema', Str $package-dir --> int){
    die "Error: unkown" unless remove($package-dir, 'schema');
    return 0;
}

multi sub MAIN('remove', 'podir', Str $package-dir --> int){
    die "Error: unkown" unless remove($package-dir, 'podir');
    return 0;
}

multi sub MAIN('remove', 'gettext-domain', Str $package-dir --> int){
    die "Error: unkown" unless remove($package-dir, 'gettext-domain');
    return 0;
}

multi sub MAIN('remove', 'out-dir', Str $package-dir --> int){
    die "Error: unkown" unless remove($package-dir, 'out-dir');
    return 0;
}

multi sub MAIN('remove', 'extra-sources', Str $package-dir --> int){
    die "Error: unkown" unless remove($package-dir, 'extra-sources');
    return 0;
}

multi sub MAIN('get', 'schema', Str $package-dir --> int){
    die "Error: parameter unknown" unless get($package-dir, 'schema');
    return 0;
}

multi sub MAIN('get', 'podir', Str $package-dir --> int){
    die "Error: parameter unknown" unless get($package-dir, 'podir');
    return 0;
}

multi sub MAIN('get', 'gettext-domain', Str $package-dir --> int){
    die "Error: parameter unknown" unless get($package-dir, 'gettext-domain');
    return 0;
}

multi sub MAIN('get', 'out-dir', Str $package-dir --> int){
    die "Error: parameter unknown" unless get($package-dir, 'out-dir');
    return 0;
}

multi sub MAIN('get', 'extra-sources', Str $package-dir --> int){
    die "Error: parameter unknown" unless get($package-dir, 'extra-sources');
    return 0;
}

multi sub MAIN('get', 'force', Str $package-dir --> int){
    die "Error: parameter unknown" unless get($package-dir, 'force');
    return 0;
}

multi sub MAIN('get', 'package-dir', Str $package-dir --> int){
    die "Error: parameter unknown" unless get($package-dir, 'package-dir');
    return 0;
}

multi sub MAIN('alias', 'add', Str $key, Str $target, Bool:D :s(:set(:$force)) = False, Str :c(:$comment) = Str --> int){
    if add-path($key, $target, $force, $comment) {
       exit 0;
    } else {
       exit 1;
    } 
}

multi sub MAIN('alias', 'do', Str $key, Bool:D :f(:$force) = False --> int){
    my Str:D $dir = path($key);
    die "could not find key: $key in db" unless $dir;
    read-file($dir);
    if pack($dir, $force) {
        return 0;
    } else {
        die "run exited with a bad value {exitcode}";
    }
}

multi sub MAIN('edit', 'configs') returns Int {
   if edit-configs() {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('list', 'keys', Str $prefix = '',
                               Bool:D :c(:color(:$colour)) = False,
                               Bool:D :s(:$syntax) = False,
                               Int:D :l(:$page-length) = 50,
                               Str :p(:$pattern) = Str,
                               Str :e(:$ecma-pattern) = Str) returns Int {
    my Regex $_pattern;
    with $pattern {
        $_pattern = rx:i/ <$pattern> /;
    } orwith $ecma-pattern {
        $_pattern = ECMA262Regex.compile("^$ecma-pattern\$");
    } else {
        $_pattern = rx:i/^ .* $/;
    }
    if say-list-keys($prefix, $colour, $syntax, $_pattern, $page-length) {
       exit 0;
    } else {
       exit 1;
    } 
}

multi sub MAIN('list', 'all', Str:D $prefix = '', Bool:D :c(:color(:$colour)) = False,
                    Bool:D :s(:$syntax) = False, Int:D :l(:$page-length) = 50, Str :p(:$pattern) = Str,
                                                                Str :e(:$ecma-pattern) = Str) returns Int {
    my Regex $_pattern;
    with $pattern {
        $_pattern = rx:i/ <$pattern> /;
    } orwith $ecma-pattern {
        $_pattern = ECMA262Regex.compile("^$ecma-pattern\$");
    } else {
        $_pattern = rx:i/^ .* $/;
    }
    if list-by-all($prefix, $colour, $syntax, $page-length, $_pattern) {
       exit 0;
    } else {
       exit 1;
    } 
} #`««« multi sub MAIN('list', 'by', 'all', Str:D $prefix = '', Bool:D :c(:color(:$colour)) = False,
                    Bool:D :s(:$syntax) = False, Int:D :l(:$page-length) = 50, Str :p(:$pattern) = Str,
                                                                Str :e(:$ecma-pattern) = Str) returns Int »»»

multi sub MAIN('delete', Bool:D :d(:delete(:$do-not-trash)) = False, *@keys) returns Int {
    my Int:D $result = 0;
    for @keys -> $key {
        unless delete-key($key, !$do-not-trash) {
            $result++;
        } 
    }
    exit $result;
}

multi sub MAIN('del', Bool:D :d(:delete(:$do-not-trash)) = False, *@keys) returns Int {
    my Int:D $result = 0;
    for @keys -> $key {
        unless delete-key($key, !$do-not-trash) {
            $result++;
        } 
    }
    exit $result;
}

multi sub MAIN('trash', *@keys) returns Int {
    my Int:D $result = 0;
    for @keys -> $key {
        unless delete-key($key, True) {
            $result++;
        } 
    }
    exit $result;
}

multi sub MAIN('tidy', 'file') returns Int {
   if tidy-file() {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('comment',
                    Str:D $key,
                        Str:D $comment,
                            Str:D :k(:$kind) where { $_ eq ('neither' ^ 'normal' ^ 'commented' ^ 'both') } = 'normal' --> Int) {
    die "bad value for kind" unless is-kind($kind);
    my %kinds = Kind.enums;
   if add-comment($key, $comment, %kinds{$kind}) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('list', 'trash', Str:D $prefix = '',
                               Bool:D :c(:color(:$colour)) = False,
                               Bool:D :s(:$syntax) = False,
                               Int:D :l(:$page-length) = 30,
                               Str :p(:$pattern) = Str,
                               Str :e(:$ecma-pattern) = Str) returns Int {
    my Regex $_pattern;
    with $pattern {
        $_pattern = rx:i/ <$pattern> /;
    } orwith $ecma-pattern {
        $_pattern = ECMA262Regex.compile("^$ecma-pattern\$");
    } else {
        $_pattern = rx:i/^ .* $/;
    }
   if list-commented($prefix, $colour, $syntax, $page-length, $_pattern) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('empty', 'trash') returns Int {
   if empty-trash() {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('undelete', *@keys) returns Int {
    my Int:D $result = 0;
    for @keys -> $key {
        unless undelete($key) {
            $result++;
        } 
    }
    exit $result;
}

multi sub MAIN('show', 'stats', Str:D $prefix = '',
                               Bool:D :c(:color(:$colour)) = False,
                               Bool:D :s(:$syntax) = False,
                               Str :p(:$pattern) = Str,
                               Str :e(:$ecma-pattern) = Str) returns Int {
    my Regex $_pattern;
    with $pattern {
        $_pattern = rx:i/ <$pattern> /;
    } orwith $ecma-pattern {
        $_pattern = ECMA262Regex.compile("^$ecma-pattern\$");
    } else {
        $_pattern = rx:i/^ .* $/;
    }
    if stats($prefix, $colour, $syntax, $_pattern) {
        exit 0;
    } else {
        exit 1;
    } 
} # multi sub MAIN('stats', Bool:D :c(:color(:$colour)) = False, Bool:D :s(:$syntax) = False) returns Int #

multi sub MAIN('show', 'statistics', Str:D $prefix = '',
                               Bool:D :c(:color(:$colour)) = False,
                               Bool:D :s(:$syntax) = False,
                               Str :p(:$pattern) = Str,
                               Str :e(:$ecma-pattern) = Str) returns Int {
    my Regex $_pattern;
    with $pattern {
        $_pattern = rx:i/ <$pattern> /;
    } orwith $ecma-pattern {
        $_pattern = ECMA262Regex.compile("^$ecma-pattern\$");
    } else {
        $_pattern = rx:i/^ .* $/;
    }
    if stats($prefix, $colour, $syntax, $_pattern) {
        exit 0;
    } else {
        exit 1;
    } 
} # multi sub MAIN('statistics', Bool:D :c(:color(:$colour)) = False, Bool:D :s(:$syntax) = False) returns Int #

multi sub MAIN('backup', 'db', Bool:D :w(:win-format(:$use-windows-formating)) = False --> Bool) {
    if backup-db-file($use-windows-formating) {
        exit 0;
    } else {
        die "Error: backup failed!!!";
    }
}

multi sub MAIN('restore', 'db', Str $restore-from = Str --> Bool) {
    my IO::Path $_restore-from;
    with $restore-from {
        $_restore-from = $restore-from.IO;
    }
    if restore-db-file($_restore-from) {
        exit 0;
    } else {
        die "Error: restore backup failed!!!";
    }
}

multi sub MAIN('menu', 'restore', 'db',
                Str:D $message = '',
                Bool:D :c(:color(:$colour)) = False,
                Bool:D :s(:$syntax) = False) returns Int {
   if backups-menu-restore-db($colour, $syntax, $message) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('list', 'db', 'backups', Str:D $prefix = '',
                               Bool:D :c(:color(:$colour)) = False,
                               Bool:D :s(:$syntax) = False,
                               Int:D :l(:$page-length) = 30,
                               Str :p(:$pattern) = Str,
                               Str :e(:$ecma-pattern) = Str) returns Int {
    my Regex $_pattern;
    with $pattern {
        $_pattern = rx:i/ <$pattern> /;
    } orwith $ecma-pattern {
        $_pattern = ECMA262Regex.compile("^$ecma-pattern\$");
    } else {
        $_pattern = rx:i/^ .* $/;
    }
    if list-db-backups($prefix, $colour, $syntax, $_pattern, $page-length) {
        exit 0;
    } else {
        exit 1;
    } 
}

#`«««
    ##################################
    #********************************#
    #*                              *#
    #*       Editor functions       *#
    #*                              *#
    #********************************#
    ##################################
#»»»

multi sub MAIN('list', 'editors', Str:D :f(:$prefix) = '',
                               Bool:D :c(:color(:$colour)) = False,
                               Bool:D :s(:$syntax) = False,
                               Int:D :l(:$page-length) = 30,
                               Str :p(:$pattern) = Str,
                               Str :e(:$ecma-pattern) = Str) returns Int {
    my Regex $_pattern;
    with $pattern {
        $_pattern = rx:i/ <$pattern> /;
    } orwith $ecma-pattern {
        $_pattern = ECMA262Regex.compile("^$ecma-pattern\$");
    } else {
        $_pattern = rx:i/^ .* $/;
    }
   if list-editors($prefix, $colour, $syntax, $page-length, $_pattern) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('editors', 'stats', Str:D $prefix = '',
                               Bool:D :c(:color(:$colour)) = False,
                               Bool:D :s(:$syntax) = False,
                               Int:D :l(:$page-length) = 30,
                               Str :p(:$pattern) = Str,
                               Str :e(:$ecma-pattern) = Str) returns Int {
    my Regex $_pattern;
    with $pattern {
        $_pattern = rx:i/ <$pattern> /;
    } orwith $ecma-pattern {
        $_pattern = ECMA262Regex.compile("^$ecma-pattern\$");
    } else {
        $_pattern = rx:i/^ .* $/;
    }
   if editors-stats($prefix, $colour, $syntax, $page-length, $_pattern) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('list', 'editors', 'backups', Str:D $prefix = '',
                               Bool:D :c(:color(:$colour)) = False,
                               Bool:D :s(:$syntax) = False,
                               Int:D :l(:$page-length) = 30,
                               Str :p(:$pattern) = Str,
                               Str :e(:$ecma-pattern) = Str) returns Int {
    my Regex $_pattern;
    with $pattern {
        $_pattern = rx:i/ <$pattern> /;
    } orwith $ecma-pattern {
        $_pattern = ECMA262Regex.compile("^$ecma-pattern\$");
    } else {
        $_pattern = rx:i/^ .* $/;
    }
    if list-editors-backups($prefix, $colour, $syntax, $_pattern, $page-length) {
        exit 0;
    } else {
        exit 1;
    } 
}

multi sub MAIN('backup', 'editors', Bool:D :w(:$use-windows-formatting) = False) returns Int {
   if backup-editors($use-windows-formatting) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('restore', 'editors', Str:D $restore-from) returns Int {
   if restore-editors($restore-from.IO) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('set', 'editor', Str:D $editor, Str $comment = Str) returns Int {
   if set-editor($editor, $comment) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('set', 'override', 'GUI_EDITOR', Bool:D $value, Str $comment = Str) returns Int {
   if set-override-GUI_EDITOR($value, $comment) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('menu', 'restore', 'editors', Str:D $message = '', Bool:D :c(:color(:$colour)) = False, Bool:D :s(:$syntax) = False) returns Int {
   if backups-menu-restore-editors($colour, $syntax, $message) {
       exit 0;
   } else {
       exit 1;
   } 
}

#`«««
    ***********************************************************
    *                                                         *
    *                       USAGE Stuff                       *
    *                                                         *
    ***********************************************************
#»»»

sub USAGE(Bool:D :n(:nocolor(:$nocolour)) = False, *%named-args, *@args --> Int) {
    say-coloured($*USAGE, False, %named-args, @args);
    exit 0;
}

multi sub GENERATE-USAGE(&main, |capture --> Int) {
    my @capture = |(capture.list);
    my @_capture;
    if @capture && @capture[0] eq 'help' {
        @_capture = |@capture[1 .. *];
    } else {
        @_capture = |@capture;
    }
    my %capture = |(capture.hash);
    if %capture«nocolour» || %capture«nocolor» || %capture«n» {
        say-coloured($*USAGE, True, |%capture, |@_capture);
    } else {
        #dd @capture;
        say-coloured($*USAGE, False, |%capture, |@_capture);
        #&*GENERATE-USAGE(&main, |capture)
    }
    exit 0;
}
