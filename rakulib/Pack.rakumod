unit module Pack:ver<0.1.0>:auth<Francis Grizzly Smit (grizzlysmit@smit.id.au)>;

use JSON::Fast;

my $schema;
my $podir;
my $gettext-domain;
my $package-dir;
my $out-dir;
my $force-file;
my @extra-sources;
my $exitcode-val;

sub read-file(Str $dir --> Bool) is export {
    die "file $dir/.pack_args.json does not exist" unless "$dir/.pack_args.json".IO ~~ :f;
    my $file-cont         = "$dir/.pack_args.json".IO.slurp(:utf8);
    my $data              = from-json $file-cont;
    $schema               = %$data«schema»;
    $podir                = %$data«podir»;
    $gettext-domain       = %$data«gettext-domain»;
    $package-dir          = %$data«package-dir»;
    $out-dir              = %$data«out-dir»;
    $force-file           = %$data«force»;
    my $extra             = %$data«extra-sources»;
    @extra-sources        = @$extra;
    return True;
}

sub pack(Str $dir, Bool $force is copy = False --> Bool) is export {
    $force              ||= $force-file;
    my @cmd = qqww{gnome-extensions pack};
    for @extra-sources -> $extra {
        push @cmd, "--extra-source=$extra";  
    }
    push @cmd, "--schema=$schema" if defined $schema;
    push @cmd, "--podir=$podir" if defined $podir;
    push @cmd, "--gettext-domain=$gettext-domain" if defined $gettext-domain;
    push @cmd, "--force" if $force;
    push @cmd, "--out-dir=$out-dir" if defined $out-dir;
    $package-dir = $dir unless defined $package-dir;
    push @cmd, "$package-dir";
    @cmd.join(' ').say;
    my Proc $res = run @cmd;
    $exitcode-val = $res.exitcode;
    return $res.exitcode == 0;
}

sub exitcode(--> int) is export {
    return $exitcode-val;
}

sub create-config(Str $package-dir, Str $schema, Str $podir, Str $gettext-domain, Str $out-dir, $force, @extra-sources --> Bool) is export {
    my $data               = { extra-sources => [ |@extra-sources ],  };
    %$data«schema»         = $schema unless $schema eq 'Null';
    %$data«podir»          = $podir unless $podir eq 'Null';
    %$data«gettext-domain» = $gettext-domain unless $gettext-domain eq 'Null';
    %$data«package-dir»    = $package-dir.IO.basename unless $package-dir eq 'Null';
    %$data«out-dir»        = $out-dir??"$out-dir".IO.absolute.IO.resolve(:completely).Str!!'Null' unless $out-dir eq 'Null';
    %$data«force»          = $force;
    "$package-dir/.pack_args.json".IO.spurt(to-json $data);
    return True;                                                                                                                                                                                                                                    
}

sub add(Str $dir, Str $_schema, Str $_podir, Str $_gettext-domain, Str $_out-dir, Bool $_force is copy, Bool $stomp-force, Bool $stomp, @_extra-sources --> Bool) is export {
    read-file($dir);
    push @extra-sources, |@_extra-sources if @_extra-sources;
    if $stomp {
        @extra-sources     = @_extra-sources;
    }
    @extra-sources         = @extra-sources.sort.squish;
    $package-dir           = $dir.IO.absolute.IO.resolve(:completely).basename unless defined $package-dir;
    $schema                = $_schema unless $_schema eq 'Null';
    $podir                 = $_podir unless $_podir eq 'Null';
    $gettext-domain        = $_gettext-domain unless $_gettext-domain eq 'Null';
    $out-dir               = $_out-dir.IO.absolute.IO.resolve(:completely).Str unless $_out-dir eq 'Null';
    if !$stomp-force {
        $_force            = $force-file unless $_force;
    }
    my $data               = { extra-sources => [ |@extra-sources ],  };
    if defined $schema {
        %$data«schema»     = $schema;
    }
    if defined $podir {
        %$data«podir»      = $podir;
    }
    if $gettext-domain {
        %$data«gettext-domain» = $gettext-domain;
    }
    if $package-dir {
        %$data«package-dir»    = $package-dir;
    }
    if defined $out-dir {
        %$data«out-dir»        = "$out-dir".IO.absolute.IO.resolve(:completely).Str;
    }
    %$data«force»          = $_force;
    "$dir/.pack_args.json".IO.spurt(to-json $data);
    return True;                                                                                                                                                                                                                                    
}

sub set-package-dir($dir, $package-dir-value) is export {
    read-file($dir);
    $package-dir               = $package-dir-value.IO.basename;
    my $data                   = { extra-sources => [ |@extra-sources ],  };
    if defined $schema {
        %$data«schema»         = $schema;
    }
    if defined $podir {
        %$data«podir»          = $podir;
    }
    if $gettext-domain {
        %$data«gettext-domain» = $gettext-domain;
    }
    if $package-dir {
        %$data«package-dir»    = $package-dir;
    }
    if defined $out-dir {
        %$data«out-dir»        = "$out-dir".IO.absolute.IO.resolve(:completely).Str;
    }
    %$data«force»              = $force-file;
    "$dir/.pack_args.json".IO.spurt(to-json $data);
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
    "$package-dir/.pack_args.json".IO.spurt(to-json $data);
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
