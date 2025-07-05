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

Table of Contents

=end head2

=item1 L<NAME|#name>
=item1 L<AUTHOR|#author>
=item1 L<VERSION|#version>
=item1 L<TITLE|#title>
=item1 L<SUBTITLE|#subtitle>
=item1 L<COPYRIGHT|#copyright>
=item1 L<Introduction|#introduction>
=item2 L<Motivation|#motivation>
=item1 L<pack.raku do --help|#packraku-do---help>
=item1 L<pack.raku create --help|#packraku-create---help>
=item1 L<pack.raku add|#packraku-add>
=item1 L<pack.raku set schema|#packraku-set-schema>
=item1 L<pack.raku set podir|#packraku-set-podir>
=item1 L<pack.raku set gettext-domain|#packraku-set-gettext-domain>
=item1 L<pack.raku set out-dir|#packraku-set-out-dir>
=item1 L<pack.raku set force|#packraku-set-force>
=item1 L<pack.raku add-extra-sources|#packraku-add-extra-sources>
=item1 L<pack.raku set package-dir|#packraku-set-package-dir>
=item1 L<pack.raku set extra-sources|#packraku-set-extra-sources>
=item1 L<pack.raku append extra-sources|#packraku-append-extra-sources>
=item1 L<pack.raku remove schema|#packraku-remove-schema>
=item1 L<pack.raku remove podir|#packraku-remove-podir>
=item1 L<pack.raku remove gettext-domain|#packraku-remove-gettext-domain>
=item1 L<pack.raku remove out-dir|#packraku-remove-out-dir>
=item1 L<pack.raku remove extra-sources|#packraku-remove-extra-sources>
=item1 L<pack.raku get schema|#packraku-get-schema>
=item1 L<pack.raku get podir|#packraku-get-podir>
=item1 L<pack.raku get gettext-domain|#packraku-get-gettext-domain>
=item1 L<pack.raku get out-dir|#packraku-get-out-dir>
=item1 L<pack.raku get extra-sources|#packraku-get-extra-sources>
=item1 L<pack.raku get force|#packraku-get-force>

=head1 key => directory methods
=item1 L<pack.raku alias add|#packraku-alias-add>
=item1 L<pack.raku alias do --help|#packraku-alias-do---help>
=item1 L<pack.raku edit configs|#packraku-edit-configs>
=item1 L<pack.raku list keys|#packraku-list-keys>
=item1 L<pack.raku list all|#packraku-list-all>
=item1 L<pack.raku delete|#packraku-delete>
=item1 L<pack.raku del|#packraku-del>
=item1 L<pack.raku trash|#packraku-trash>
=item1 L<pack.raku tidy file|#packraku-tidy-file>
=item1 L<pack.raku comment|#packraku-comment>
=item1 L<pack.raku list trash|#packraku-list-trash>
=item1 L<pack.raku empty trash|#packraku-empty-trash>
=item1 L<pack.raku undelete|#packraku-undelete>
=item1 L<pack.raku show stats|#packraku-show-stats>
=item1 L<pack.raku show statistics|#packraku-show-statistics>
=item1 L<pack.raku backup db|#packraku-backup-db>
=item1 L<pack.raku restore db|#packraku-restore-db>
=item1 L<pack.raku menu restore db|#packraku-menu-restore-db>
=item1 L<pack.raku list db backups|#packraku-list-db-backups>
=head1 Editor functions/methods
=item1 L<pack.raku list editors|#packraku-list-editors>
=item1 L<placeholder|#placeholder>
=item1 L<placeholder|#placeholder>
=item1 L<placeholder|#placeholder>
=item1 L<placeholder|#placeholder>
=item1 L<placeholder|#placeholder>
=item1 L<placeholder|#placeholder>
=item1 L<placeholder|#placeholder>


=NAME App::pack 
=AUTHOR Francis Grizzly Smit (grizzly@smit.id.au)
=VERSION v0.1.0
=TITLE pack
=SUBTITLE A Raku program to manage the use of B<gnome-extensions pack>, it has too many arguments this makes it easy; at the expense of setting up a configuration file once, and there are methods for that.

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
  pack.raku do <dir>  [<dirs> ...] [-f|--force] [-c|--command=<Str>] [-q|--quiet|--silent]
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
  pack.raku alias do <key>  [<keys> ...] [-f|--force] [-c|--command=<Str>] [-q|--quiet|--silent]
  pack.raku edit configs
  pack.raku list keys  [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
  pack.raku list all  [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
  pack.raku delete   [<keys> ...] [-d|--delete|--do-not-trash]
  pack.raku del   [<keys> ...] [-d|--delete|--do-not-trash]
  pack.raku trash   [<keys> ...]
  pack.raku tidy file
  pack.raku comment <key> <comment>   [-k|--kind=<Str where \{ ... } >]
  pack.raku list trash  [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
  pack.raku empty trash
  pack.raku undelete   [<keys> ...]
  pack.raku show stats  [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
  pack.raku show statistics  [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
  pack.raku backup db    [-w|--win-format|--use-windows-formatting]
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

=head1 pack.raku do --help

=begin code :lang<bash>

pack.raku do --help
                                                                                                                                                                                           
Usage:
  pack.raku do <dir> [<dirs> ...] [-f|--force] [-c|--command=<Str>] [-q|--quiet|--silent]

L<Table of Contents|#table-of-contents>

=end code

Where
=item1 dir   is a directory containing a B<gnome-shell> plugin
=item2 assumes that the directory contains a C<.pack_args.json> file which containes all the arguments for B<gnome-extensions pack>.
=item1 B<[dirs ...]>  a list of aditional directories containing B<gnome-shell> plugins same as dir.
=item1 B<[-f|--force]>   overrides the force parameter in every C<.pack_args.json>.
=item1 B<[-c|--command=<Str>]>  overrides the command to list the current directory it is asummed this is the same as the output directory for all the plugins.
=item2 the default is B<ls -Flaghi --color=always> this can be overriden by the value of the B<LS_CMD> environment variable but the command-line value overrides both.
=item1 B<[-q|--quiet|--silent]>   if  present then all non-error output is suppressed.

L<Table of Contents|#table-of-contents>


=end pod

multi sub MAIN('do', Str:D $dir, Bool:D :f(:$force) is copy = False,
                    Str:D :c(:$command) = ((%*ENV«LS_CMD»:exists) ?? (~%*ENV«LS_CMD») !! 'ls -Flaghi --color=always'),
                            Bool :q(:quiet(:$silent)) = False, *@dirs is copy --> int){
    @dirs.prepend($dir);
    for @dirs -> $dir_ {
        read-file($dir_);
        unless pack($dir_, $silent, $force) {
            die "run exited with a bad value {exitcode}";
        }
    } # for @dirs -> $dir_ #
    unless $silent {
        $command.say;
        my @cmd = $command.words();
        my Proc $res = run @cmd;
        die "‷$command‴ returned {$res.exitcode}" unless $res.exitcode === 0;
    }
    return 0;
}

=begin pod

=head1 pack.raku create --help

=begin code :lang<bash>

Usage:
  pack.raku create <package-dir> [<extra-sources> ...] [-s|--schema=<Str>] [-p|--podir=<Str>] [-g|--gettext-domain=<Str>] [-o|--out-dir=<Str>] [-f|--force]

=end code

Create the C<.pack_args.json> file.

Where
=item1 B«<package-dir>»  Directory containing plugin.
=item1 B<[<extra-sources> ...]>  A list of extra files to add to the package.
=item1 B«[-s|--schema=<Str>]»  The path to the schema file.
=item1 B«[-p|--podir=<Str>]»  The path to the po files.
=item1 B«[-g|--gettext-domain=<Str>]»   The gettext domain.
=item1 B«[-o|--out-dir=<Str>]»   The directory to place the package file in.
=item1 B«[-f|--force]»   set the force option.

L<Table of Contents|#table-of-contents>

=end pod

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

=begin pod

=head1 pack.raku add

=begin code :lang<bash>

pack.raku add --help

Usage:
  pack.raku add <package-dir> [<extra-sources> ...] [-s|--schema=<Str>] [-p|--podir=<Str>] [-g|--gettext-domain=<Str>] [-o|--out-dir=<Str>] [-f|--force] [-F|--stomp-force] [-S|--stomp]

=end code

Modifiy add to the C<.pack_args.json> file.

Where
=item1 B«<package-dir>»  Directory containing plugin.
=item1 B<[<extra-sources> ...]>  A list of extra files to add to the package.
=item1 B«[-s|--schema=<Str>]»  The path to the schema file.
=item1 B«[-p|--podir=<Str>]»  The path to the po files.
=item1 B«[-g|--gettext-domain=<Str>]»   The gettext domain.
=item1 B«[-o|--out-dir=<Str>]»   The directory to place the package file in.
=item1 B«[-f|--force]»   set the force option.
=item1 B«[-F|--stomp-force]»   If present then the value of --force wins regradless.
=item1 B«[-S|--stomp]»     If present then @extra-sources stomps on whatever was before otherwise they are spliced together.

L<Table of Contents|#table-of-contents>

=end pod

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

=begin pod

=head1 pack.raku set schema

=begin code :lang<bash>

pack.raku set schema --help

Usage:
  pack.raku set schema <package-dir> <schema-value>

=end code

Set the value of schema in B«<package-dir>/.pack_args.json»

Where
=item1 B«<package-dir>»   Directory containing plugin.
=item1 B«<schema-value>»  new value of schema.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('set', 'schema', Str $package-dir, Str $schema-value --> int){
    die "Error: unkown" unless add($package-dir, $schema-value, 'Null', 'Null', 'Null', False, False, False, ());
    return 0;
}

=begin pod

=head1 pack.raku set podir

=begin code :lang<bash>

pack.raku set podir --help

Usage:
  pack.raku set podir <package-dir> <podir-value>

=end code

Set the value of podir in B«<package-dir>/.pack_args.json»

Where
=item1 B«<package-dir>»  Directory containing plugin.
=item1 B«<podir-value>»  new value of podir.
=item2 podir is the path of the directory containing the po files.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('set', 'podir', Str $package-dir, Str $podir-value --> int){
    die "Error: unkown" unless add($package-dir, 'Null', $podir-value, 'Null', 'Null', False, False, False, ());
    return 0;
}

=begin pod

=head1 pack.raku set gettext-domain

=begin code :lang<bash>

pack.raku set gettext-domain --help

Usage:
  pack.raku set gettext-domain <package-dir> <gettext-domain-value>

=end code

Set the value of gettext-domain in B«<package-dir>/.pack_args.json»

Where
=item1 B«<package-dir>»  Directory containing plugin.
=item1 B«<gettext-domain-value>»  new value of gettext-domain.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('set', 'gettext-domain', Str $package-dir, Str $gettext-domain-value --> int){
    die "Error: unkown" unless add($package-dir, 'Null', 'Null', $gettext-domain-value, 'Null', False, False, False, ());
    return 0;
}

=begin pod

=head1 pack.raku set out-dir

=begin code :lang<bash>

pack.raku set out-dir --help

Usage:
  pack.raku set out-dir <package-dir> <out-dir-value>

=end code

Set the value of out-dir in B«<package-dir>/.pack_args.json»

Where
=item1 B«<package-dir>»  Directory containing plugin.
=item1 B«<out-dir-value>»  new value of out-dir.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('set', 'out-dir', Str $package-dir, Str $out-dir-value --> int){
    die "Error: unkown" unless add($package-dir, 'Null', 'Null', 'Null', $out-dir-value, False, False, False, ());
    return 0;
}

=begin pod

=head1 pack.raku set force

=begin code :lang<bash>

pack.raku set force --help

Usage:
  pack.raku set force <package-dir> <force-value>

=end code

Set the value of force in B«<package-dir>/.pack_args.json»

Where
=item1 B«<package-dir>»  Directory containing plugin.
=item1 B«<force-value>»  new value of force.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('set', 'force', Str $package-dir, Bool $force-value --> int){
    die "Error: unkown" unless add($package-dir, 'Null', 'Null', 'Null', 'Null', $force-value, True, False, ());
    return 0;
}

=begin pod

=head1 pack.raku add-extra-sources

=begin code :lang<bash>

pack.raku add-extra-sources --help

Usage:
  pack.raku add-extra-sources <package-dir> [<extra-sources> ...]

=end code

Add to the value of extra-sources in B«<package-dir>/.pack_args.json»

Where
=item1 B«<package-dir>»  Directory containing plugin.
=item1 B«[<extra-sources> ...]»  additional extra-sources.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('add-extra-sources', Str $package-dir, *@extra-sources --> int){
    die "Error: unkown" unless add($package-dir, 'Null', 'Null', 'Null', 'Null', False, False, False, @extra-sources);
    return 0;
}

=begin pod

=head1 pack.raku set package-dir

=begin code :lang<bash>

pack.raku set package-dir --help

Usage:
  pack.raku set package-dir <package-dir> <package-dir-value>

=end code

Set the value of package-dir in B«<package-dir>/.pack_args.json»

Where
=item1 B«<package-dir>»  Directory containing plugin.
=item1 B«<package-dir-value>»  new value of package-dir.
=item2 probably useless as B«<package-dir>» and B«<package-dir-value>» are to be expected to be the same generally, but if needed it's here.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('set', 'package-dir', Str $package-dir, Str $package-dir-value --> int){
    die "Error: unkown" unless set-package-dir($package-dir, $package-dir-value);
    return 0;
}

=begin pod

=head1 pack.raku set extra-sources

=begin code :lang<bash>

pack.raku set extra-sources --help

Usage:
  pack.raku set extra-sources <package-dir> [<extra-sources> ...]

=end code

Set the value of extra-sources in B«<package-dir>/.pack_args.json»

Where
=item1 B«<package-dir>»  Directory containing plugin.
=item1 B«[<extra-sources> ...]»  new value of extra-sources.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('set', 'extra-sources', Str $package-dir, *@extra-sources --> int){
    die "Error: unkown" unless add($package-dir, 'Null', 'Null', 'Null', 'Null', False, False, True, @extra-sources);
    return 0;
}

=begin pod

=head1 pack.raku append extra-sources

=begin code :lang<bash>

pack.raku append extra-sources --help

Usage:
  pack.raku append extra-sources <package-dir> [<extra-sources> ...]

=end code

Append B«[<extra-sources> ...]» to the value of extra-sources in B«<package-dir>/.pack_args.json»

Where
=item1 B«<package-dir>»  Directory containing plugin.
=item1 B«[<extra-sources> ...]»  value to append to extra-sources.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('append', 'extra-sources', Str $package-dir, *@extra-sources --> int){
    die "Error: unkown" unless add($package-dir, 'Null', 'Null', 'Null', 'Null', False, False, False, @extra-sources);
    return 0;
}

=begin pod

=head1 pack.raku remove schema

=begin code :lang<bash>

pack.raku remove schema --help

Usage:
  pack.raku remove schema <package-dir>

=end code

Remove the value of schema in B«<package-dir>/.pack_args.json»

Where
=item1 B«<package-dir>»  Directory containing plugin.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('remove', 'schema', Str $package-dir --> int){
    die "Error: unkown" unless remove($package-dir, 'schema');
    return 0;
}

=begin pod

=head1 pack.raku remove podir

=begin code :lang<bash>

pack.raku remove podir --help

Usage:
  pack.raku remove podir <package-dir>

=end code

Remove the value of podir in B«<package-dir>/.pack_args.json»

Where
=item1 B«<package-dir>»  Directory containing plugin.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('remove', 'podir', Str $package-dir --> int){
    die "Error: unkown" unless remove($package-dir, 'podir');
    return 0;
}

=begin pod

=head1 pack.raku remove gettext-domain

=begin code :lang<bash>

pack.raku remove gettext-domain --help

Usage:
  pack.raku remove gettext-domain <package-dir>

=end code

Remove the value of gettext-domain in B«<package-dir>/.pack_args.json»

Where
=item1 B«<package-dir>»  Directory containing plugin.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('remove', 'gettext-domain', Str $package-dir --> int){
    die "Error: unkown" unless remove($package-dir, 'gettext-domain');
    return 0;
}

=begin pod

=head1 pack.raku remove out-dir

=begin code :lang<bash>

pack.raku remove out-dir --help

Usage:
  pack.raku remove out-dir <package-dir>

=end code

Remove the value of out-dir in B«<package-dir>/.pack_args.json»

Where
=item1 B«<package-dir>»  Directory containing plugin.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('remove', 'out-dir', Str $package-dir --> int){
    die "Error: unkown" unless remove($package-dir, 'out-dir');
    return 0;
}

=begin pod

=head1 pack.raku remove extra-sources

=begin code :lang<bash>

pack.raku remove extra-sources --help

Usage:
  pack.raku remove extra-sources <package-dir>

=end code

Truncate the value of extra-sources in B«<package-dir>/.pack_args.json»

Where
=item1 B«<package-dir>»  Directory containing plugin.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('remove', 'extra-sources', Str $package-dir --> int){
    die "Error: unkown" unless remove($package-dir, 'extra-sources');
    return 0;
}

=begin pod

=head1 pack.raku get schema

=begin code :lang<bash>

pack.raku get schema --help

Usage:
  pack.raku get schema <package-dir>

=end code

Get the value of schema in B«<package-dir>/.pack_args.json»

Where
=item1 B«<package-dir>»  Directory containing plugin.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('get', 'schema', Str $package-dir --> int){
    die "Error: parameter unknown" unless get($package-dir, 'schema');
    return 0;
}

=begin pod

=head1 pack.raku get podir

=begin code :lang<bash>

pack.raku get podir --help

Usage:
  pack.raku get podir <package-dir>

=end code

Get the value of podir in B«<package-dir>/.pack_args.json»
=item1 B«NB: podir is the path to the directory containing the po files.»

Where
=item1 B«<package-dir>»  Directory containing plugin.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('get', 'podir', Str $package-dir --> int){
    die "Error: parameter unknown" unless get($package-dir, 'podir');
    return 0;
}

=begin pod

=head1 pack.raku get gettext-domain

=begin code :lang<bash>

pack.raku get gettext-domain --help

Usage:
  pack.raku get gettext-domain <package-dir>

=end code

Get the value of gettext-domain in B«<package-dir>/.pack_args.json»

Where
=item1 B«<package-dir>»  Directory containing plugin.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('get', 'gettext-domain', Str $package-dir --> int){
    die "Error: parameter unknown" unless get($package-dir, 'gettext-domain');
    return 0;
}

=begin pod

=head1 pack.raku get out-dir

=begin code :lang<bash>

pack.raku get out-dir --help

Usage:
  pack.raku get out-dir <package-dir>

=end code

Get the value of out-dir in B«<package-dir>/.pack_args.json»

Where
=item1 B«<package-dir>»  Directory containing plugin.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('get', 'out-dir', Str $package-dir --> int){
    die "Error: parameter unknown" unless get($package-dir, 'out-dir');
    return 0;
}

=begin pod

=head1 pack.raku get extra-sources

=begin code :lang<bash>

pack.raku get extra-sources --help

Usage:
  pack.raku get extra-sources <package-dir>

=end code

Get the value of extra-sources in B«<package-dir>/.pack_args.json»

Where
=item1 B«<package-dir>»  Directory containing plugin.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('get', 'extra-sources', Str $package-dir --> int){
    die "Error: parameter unknown" unless get($package-dir, 'extra-sources');
    return 0;
}

=begin pod

=head1 pack.raku get force

=begin code :lang<bash>

pack.raku get force --help

Usage:
  pack.raku get force <package-dir>

=end code

Get the value of force in B«<package-dir>/.pack_args.json»

Where
=item1 B«<package-dir>»  Directory containing plugin.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('get', 'force', Str $package-dir --> int){
    die "Error: parameter unknown" unless get($package-dir, 'force');
    return 0;
}

multi sub MAIN('get', 'package-dir', Str $package-dir --> int){
    die "Error: parameter unknown" unless get($package-dir, 'package-dir');
    return 0;
}

=begin pod

=head1 pack.raku alias add

=begin code :lang<bash>

pack.raku alias add --help

Usage:
  pack.raku alias add <key> <target>  [-s|--set|--force] [-c|--comment=<Str>]

=end code

Where 
=item1 B«<key>»  is a faily arbitray key.
=item1 B«<target>»  is a path to a directory containing a B<gnome-shell> plugin.
=item1 B«[-s|--set|--force]»     if present then add the key directory pair even if it requires overwriting an existing entry.
=item1 B«[-c|--comment=<Str>]»   A comment to describe the key directory pair.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'add', Str $key, Str $target, Bool:D :s(:set(:$force)) = False, Str :c(:$comment) = Str --> int){
    if add-path($key, $target, $force, $comment) {
       exit 0;
    } else {
       exit 1;
    } 
}

=begin pod 

=head1 pack.raku alias do --help

=begin code :lang<bash>

Usage:
  pack.raku alias do <key> [<keys> ...] [-f|--force] [-c|--command=<Str>] [-q|--quiet|--silent]

=end code

Where
=item1 key   is a key pointing to a directory in the directory database containing a B<gnome-shell> plugin
=item2 assumes that the directory contains a C<.pack_args.json> file which containes all the arguments for B<gnome-extensions pack>.
=item1 B<[keys ...]>  a list of aditional keys pointing to directories in the directory database containing B<gnome-shell> plugins same as key.
=item1 B<[-f|--force]>   overrides the force parameter in every C<.pack_args.json>.
=item1 B<[-c|--command=<Str>]>  overrides the command to list the current directory it is asummed this is the same as the output directory for all the plugins.
=item2 the default is B<ls -Flaghi --color=always> this can be overriden by the value of the B<LS_CMD> environment variable but the command-line value overrides both.
=item1 B<[-q|--quiet|--silent]>   if  present then all non-error output is suppressed.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'do', Str $key, Bool:D :f(:$force) = False,
                    Str:D :c(:$command) = ((%*ENV«LS_CMD»:exists) ?? (~%*ENV«LS_CMD») !! 'ls -Flaghi --color=always'),
                                                        Bool :q(:quiet(:$silent)) = False, *@keys is copy --> int){
    @keys.prepend($key);
    for @keys -> $key_ {
        my Str:D $dir = path($key_);
        die "could not find key: $key_ in db" unless $dir;
        read-file($dir);
        unless pack($dir, $silent, $force) {
            die "run exited with a bad value {exitcode}";
        }
    } # for @keys -> $key_  #
    unless $silent {
        $command.say;
        my @cmd = $command.words();
        my Proc $res = run @cmd;
        die "‷$command‴ returned {$res.exitcode}" unless $res.exitcode === 0;
    }
    return 0;
}

=begin pod

=head1 pack.raku edit configs

=begin code

pack.raku edit configs --help
                                                                                                                                                                                           
Usage:
  pack.raku edit configs

=end code

Open all configuration files for editing, avoid for expert use only and there are better ways, mostly.

L<Table of Contents|#Table-of-Contents>

=end pod

multi sub MAIN('edit', 'configs') returns Int {
   if edit-configs() {
       exit 0;
   } else {
       exit 1;
   } 
}

=begin pod

=head1 pack.raku list keys

=begin code :lang<bash>

pack.raku list keys --help

Usage:
  pack.raku list keys [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]

=end code

Where
=item1 B«[<prefix>]»  If present then search for keys starting with the string value.
=item1 B«[-c|--color|--colour]»  If present then show with ANSI colours.
=item1 B«[-s|--syntax]»  If present will override colour setting and display with syntax highlighted colours.
=item1 B«[-l|--page-length[=Int]]»  Set the page length before headers are re-shown.
=item1 B«[-p|--pattern=<Str>]»  A Raku regex to use to search for the matching keys.
=item1 B«[-e|--ecma-pattern=<Str>]»  A ECMA262Regex regex to use to search for the matching keys.
=item2 B<NB: uses a imperfect library to convert the EMCA262Regex to a Raku one.> 

List all or a subset of the keys avaiable.

L<Table of Contents|#table-of-contents>

=end pod

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

=begin pod

=head1 pack.raku list all

=begin code :lang<bash>

pack.raku list all --help

Usage:
  pack.raku list all [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]

=end code

List the keys in the database.

Where
=item1 B«[<prefix>]»  If present then search for keys, directories or comments starting with the string value.
=item1 B«[-c|--color|--colour]»  If present then show with ANSI colours.
=item1 B«[-s|--syntax]»  If present will override colour setting and display with syntax highlighted colours.
=item1 B«[-l|--page-length[=Int]]»  Set the page length before headers are re-shown.
=item1 B«[-p|--pattern=<Str>]»  A raku regex to use to search for the matching keys, directories or comments.
=item1 B«[-e|--ecma-pattern=<Str>]»  A ECMA262Regex regex to use to search for the matching keys, directories or comments.
=item2 B<NB:> uses a imperfect library to convert the EMCA262Regex to a raku one.

List all or a subset of the keys avaiable.

L<Table of Contents|#table-of-contents>

=end pod

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

=begin pod

=head1 pack.raku delete

=begin code :lang<bash>

pack.raku delete --help

Usage:
  pack.raku delete [<keys> ...] [-d|--delete|--do-not-trash]

=end code

Delete the specified key/directory paths from the database.

Where
=item1 B«[<keys> ...]»  the keys of the key/directory pairs that you want to delete.
=item1 B«[-d|--delete|--do-not-trash]» If true then actually delete otherwise trash.
=item2 Trash means keep record but commented out.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('delete', Bool:D :d(:delete(:$do-not-trash)) = False, *@keys) returns Int {
    my Int:D $result = 0;
    for @keys -> $key {
        unless delete-key($key, !$do-not-trash) {
            $result++;
        } 
    }
    exit $result;
}

=begin pod

=head1 pack.raku del

=begin code :lang<bash>

pack.raku delete --help

Usage:
  pack.raku del [<keys> ...] [-d|--delete|--do-not-trash]

=end code

Delete the specified key/directory paths from the database.
=item1 B«NB: alias for delete»

Where
=item1 B«[<keys> ...]»  the keys of the key/directory pairs that you want to delete.
=item1 B«[-d|--delete|--do-not-trash]» If true then actually delete otherwise trash.
=item2 Trash means keep record but commented out.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('del', Bool:D :d(:delete(:$do-not-trash)) = False, *@keys) returns Int {
    my Int:D $result = 0;
    for @keys -> $key {
        unless delete-key($key, !$do-not-trash) {
            $result++;
        } 
    }
    exit $result;
}

=begin pod

=head1 pack.raku trash

=begin code :lang<bash>

pack.raku delete --help

Usage:
  pack.raku delete [<keys> ...]

=end code

Trash the specified key/directory paths from the database.

Where
=item1 B«[<keys> ...]»  the keys of the key/directory pairs that you want to trash.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('trash', *@keys) returns Int {
    my Int:D $result = 0;
    for @keys -> $key {
        unless delete-key($key, True) {
            $result++;
        } 
    }
    exit $result;
}

=begin pod

=head1 pack.raku tidy file

=begin code :lang<bash>

pack.raku tidy file --help

Usage:
  pack.raku tidy file

=end code

Tidy up the database file.
=item1 Pointless really just for when your feeling OCD.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('tidy', 'file') returns Int {
   if tidy-file() {
       exit 0;
   } else {
       exit 1;
   } 
}

=begin pod

=head1 pack.raku comment

=begin code :lang<bash>

pack.raku comment --help

Usage:
  pack.raku comment <key> <comment>  [-k|--kind=<Str where \{ ... } >]

=end code

Add a comment to an entry.
=item1 B«<key>»                              The key of the record to add the comment to.
=item1 B«<comment>»                          The comment.
=item1 B«[-k|--kind=<Str where \{ ... } >]»  The kind of record to add the comment to.
=item2 the possible values of $kind are one of ('neither', 'normal', 'commented', 'both').
=item2 default value is 'normal'.

L<Table of Contents|#table-of-contents>

=end pod

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

=begin pod

=head1 pack.raku list trash

=begin code :lang<bash>

pack.raku list trash --help

Usage:
  pack.raku list trash [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]

=end code

List the trashed keys in the database.

Where
=item1 B«[<prefix>]»  If present then search for keys, directories or comments starting with the string value.
=item1 B«[-c|--color|--colour]»  If present then show with ANSI colours.
=item1 B«[-s|--syntax]»  If present will override colour setting and display with syntax highlighted colours.
=item1 B«[-l|--page-length[=Int]]»  Set the page length before headers are re-shown.
=item1 B«[-p|--pattern=<Str>]»  A raku regex to use to search for the matching keys, directories or comments.
=item1 B«[-e|--ecma-pattern=<Str>]»  A ECMA262Regex regex to use to search for the matching keys, directories or comments.
=item2 B<NB:> uses a imperfect library to convert the EMCA262Regex to a raku one.

L<Table of Contents|#table-of-contents>

=end pod

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

=begin pod

=head1 pack.raku empty trash

=begin code :lang<bash>

pack.raku empty trash --help

Usage:
  pack.raku empty trash

=end code

Delete all trashed/commented records.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('empty', 'trash') returns Int {
   if empty-trash() {
       exit 0;
   } else {
       exit 1;
   } 
}

=begin pod

=head1 pack.raku undelete

=begin code :lang<bash>

pack.raku undelete --help

Usage:
  pack.raku undelete [<keys> ...]

=end code

Undelete the specified keys.
=item1 B«[<keys> ...]» The keys of the records to undelete.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('undelete', *@keys) returns Int {
    my Int:D $result = 0;
    for @keys -> $key {
        unless undelete($key) {
            $result++;
        } 
    }
    exit $result;
}

=begin pod

=head1 pack.raku show stats

=begin code :lang<bash>

pack.raku show stats --help

Usage:
  pack.raku show stats [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]

=end code

Show the stats for the database.

Where
=item1 B«[<prefix>]»                If present then search for keys starting with the string value.
=item1 B«[-c|--color|--colour]»     If present then show with ANSI colours.
=item1 B«[-s|--syntax]»             If present will override colour setting and display with syntax highlighted colours.
=item1 B«[-p|--pattern=<Str>]»      A Raku regex to use to search for the matching keys.
=item1 B«[-e|--ecma-pattern=<Str>]» A ECMA262Regex regex to use to search for the matching keys..
=item2 B«NB: uses a imperfect library to convert the EMCA262Regex to a Raku one.»
=item2 B«NB: pattern and ecma-pattern search by the quantity keys, note the values.»

L<Table of Contents|#table-of-contents>

=end pod

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

=begin pod

=head1 pack.raku show statistics

=begin code :lang<bash>

pack.raku show stats --help

Usage:
  pack.raku show statistics [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]

=end code

Show the statistics for the database.
=item1 B«alias for show stats.»

Where
=item1 B«[<prefix>]»                If present then search for keys starting with the string value.
=item1 B«[-c|--color|--colour]»     If present then show with ANSI colours.
=item1 B«[-s|--syntax]»             If present will override colour setting and display with syntax highlighted colours.
=item1 B«[-p|--pattern=<Str>]»      A Raku regex to use to search for the matching keys.
=item1 B«[-e|--ecma-pattern=<Str>]» A ECMA262Regex regex to use to search for the matching keys..
=item2 B«NB: uses a imperfect library to convert the EMCA262Regex to a Raku one.»
=item2 B«NB: pattern and ecma-pattern search by the quantity keys, note the values.»

L<Table of Contents|#table-of-contents>

=end pod

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

=begin pod

=head1 pack.raku backup db

=begin code :lang<bash>

pack.raku backup db --help

Usage:
  pack.raku backup db  [-w|--win-format|--use-windows-formatting]

=end code

Backup the db file.
=item1 B«[-w|--win-format|--use-windows-formatting]» Use windows compatible file names for the backup file.
=item2 B«NB:» The backup file looks like pack.p_ck.2025-06-02T00:02:07.886302+10:00 normally but if you use this option then it will be like pack.p_ck.2025-07-05T09.29.03·560644+10.00 as : is a special char in windows filename names.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('backup', 'db', Bool:D :w(:win-format(:$use-windows-formatting)) = False --> Bool) {
    if backup-db-file($use-windows-formatting) {
        exit 0;
    } else {
        die "Error: backup failed!!!";
    }
}

=begin pod

=head1 pack.raku restore db

=begin code :lang<bash>

pack.raku restore db --help

Usage:
  pack.raku restore db [<restore-from>]

=end code

Restore the db file from backup restore-from.

Where
=item1 B«[<restore-from>]» A path to a restore file.

L<Table of Contents|#table-of-contents>

=end pod

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

=begin pod

=head1 pack.raku menu restore db

=begin code :lang<bash>

pack.raku menu restore db --help

Usage:
  pack.raku menu restore db [<message>]  [-c|--color|--colour] [-s|--syntax]

=end code

Use a text menu to present options for database file restore

=item1 B«[<message>]»           A message to display above the menu (currently not used in colour and syntax modes).
=item1 B«[-c|--color|--colour]» Use ANSI colour mode.
=item1 B«[-s|--syntax]»         Use ANSI colour mode with syntax highlighting.
=item2 B«NB:» looks like:

=begin code :lang<bash>

pack.raku menu restore db "testing one two three" 
testing one two three
         0	.rw-rw-r-- 394.0B grizzlysmit grizzlysmit 2025-06-02T07:49:56.429315+10:00 pack.p_ck.2025-06-02T00:02:07.886302+10:00
         1	.rw-rw-r-- 495.0B grizzlysmit grizzlysmit 2025-07-05T09:30:11.002659+10:00 pack.p_ck.2025-07-05T09:30:47.997666+10:00
         2	cancel
use cancel, bye, bye bye, quit, q, or 2 to quit
choose a candidate 0..2 =:> q

=end code
in ascii/UTF-8 mode.


L<Table of Contents|#table-of-contents>

=end pod

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

=begin pod

=head1 pack.raku list db backups

=begin code :lang<bash>

pack.raku list db backups --help

Usage:
  pack.raku list db backups [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]

=end code

List the db backups in the standard directory.

Where
=item1 B«[<prefix>]»                          List only those whose name starts with prefix (case insensitive).
=item1 B«[-c|--color|--colour] [-s|--syntax]» List in colour..
=item1 B«[-s|--syntax]»                       List in syntax highlighted colour.
=item1 B«[-l|--page-length[=Int]]»            List in pages of length $page-length.
=item1 B«[-p|--pattern=<Str>]»                List only those matching this Raku regex.
=item1 B«[-e|--ecma-pattern=<Str>]»           List only those matching this EMCA262Regex regex.
=item1 B«The EMCA262Regex library doesn't support ignore case well.» .

L<Table of Contents|#table-of-contents>

=end pod

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

=begin pod

=head1 pack.raku list editors

=begin code :lang<bash>

pack.raku list editors --help

Usage:
  pack.raku list editors  [-f|--prefix=<Str>] [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]

=end code

List the contents of the db file.

Where
=item1 B«[<prefix>]»                          List only those whose name starts with prefix (case insensitive).
=item1 B«[-c|--color|--colour] [-s|--syntax]» List in colour..
=item1 B«[-s|--syntax]»                       List in syntax highlighted colour.
=item1 B«[-l|--page-length[=Int]]»            List in pages of length $page-length.
=item1 B«[-p|--pattern=<Str>]»                List only those matching this Raku regex.
=item1 B«[-e|--ecma-pattern=<Str>]»           List only those matching this EMCA262Regex regex.
=item1 B«The EMCA262Regex library doesn't support ignore case well.» .

L<Table of Contents|#table-of-contents>

=end pod

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
