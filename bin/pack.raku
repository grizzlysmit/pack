#!/usr/bin/env raku

use v6;
use JSON::Fast;
use Pack;

my %*SUB-MAIN-OPTS;
%*SUB-MAIN-OPTS«named-anywhere» = True;
#%*SUB-MAIN-OPTS<bundling>       = True;

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
  pack.raku [-f|--force] do <dir>
  pack.raku [-s|--schema=<Str>] [-p|--podir=<Str>] [-g|--gettext-domain=<Str>] [-o|--out-dir=<Str>] [-f|--force] create <package-dir> [<extra-sources> ...]
  pack.raku [-s|--schema=<Str>] [-p|--podir=<Str>] [-g|--gettext-domain=<Str>] [-o|--out-dir=<Str>] [-f|--force] [-F|--stomp-force] [-S|--stomp] add <package-dir> [<extra-sources> ...]
  pack.raku set schema <package-dir> <schema-value>
  pack.raku set podir <package-dir> <podir-value>
  pack.raku set gettext-domain <package-dir> <gettext-domain-value>
  pack.raku set out-dir <package-dir> <out-dir-value>
  pack.raku set force <package-dir> <force-value>
  pack.raku add-extra-sources <package-dir> [<extra-sources> ...]
  pack.raku set package-dir <package-dir> <package-dir-value>
  pack.raku set extra-sources <package-dir> [<extra-sources> ...]
  pack.raku append extra-sources <package-dir> [<extra-sources> ...]
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
