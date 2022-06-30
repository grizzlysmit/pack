#!/usr/bin/env raku

use v6;
use JSON::Fast;
use Pack;

multi sub MAIN('do', Str $dir, Bool :f(:$force) is copy = False --> int){
    read-file($dir);
    if pack($dir, $force) {
        return 0;
    } else {
        die "run exited with a bad value {exitcode}";
    }
}

multi sub MAIN('create', Str $package-dir, Str :s(:$schema) = 'Null', Str :p(:$podir) = 'Null', Str :g(:$gettext-domain) = 'Null', Str :o(:$out-dir) = '.', Bool :f(:$force) = False, *@extra-sources --> int){
    die "Error: unkown" unless create-config($package-dir, $schema, $podir, $gettext-domain, $out-dir, $force, @extra-sources);
    return 0;
}

multi sub MAIN('add', Str $package-dir, Str :s(:$schema) = 'Null', Str :p(:$podir) = 'Null', Str :g(:$gettext-domain) = 'Null', Str :o(:$out-dir) = '.', Bool :f(:$force) = False, Bool :F(:$stomp-force) = False, Bool :S(:$stomp) = False, *@extra-sources --> int){
    die "Error: unkown" unless add($package-dir, $schema, $podir, $gettext-domain, $out-dir, $force, $stomp-force, $stomp, @extra-sources);
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
