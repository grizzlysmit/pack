unit module Pack:ver<0.1.0>:auth<Francis Grizzly Smit (grizzlysmit@smit.id.au)>;

use JSON::Fast;

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

sub pack(Str $dir, Bool $force is copy = False --> Bool) is export {
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
    push @cmd, "$package-dir";
    @cmd.join(' ').say;
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
    "$package-dir/.pack_args.json".IO.spurt(to-json %data);
    return True;                                                                                                                                                                                                                                    
}

sub add(Str $dir,
        Str $_schema,
        Str $_podir,
        Str $_gettext-domain,
        Str $_out-dir,
        Bool $_force is copy,
        Bool $stomp-force,
        Bool $stomp,
        @_extra-sources --> Bool) is export {
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
