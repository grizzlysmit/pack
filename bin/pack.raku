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
=head1 app pack.raku

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
=item3 L<A brief tutorial.|#a-brief-tutorial>
=item1 L<Pack|#pack>
=item2 L«key => directory methods|#key--directory-methods»
=item2 L«key => directory management methods|#key--directory-management-methods»
=item2 L«Editor functions/methods|#editor-functionsmethods»
=item2 L«USAGE stuff|#usage-stuff»
=item1 L<pack.raku --help|#pack>
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
=item1 L<pack.raku get package-dir|#packraku-get-package-dir>

=item1 L<Top of Table of Contents|#table-of-contents>

=head1 key => directory methods
=item1 L<pack.raku alias add|#packraku-alias-add>
=item1 L<pack.raku alias do --help|#packraku-alias-do---help>
=item1 L<pack.raku plugin new --help|#packraku-plugin-new---help>
=item2 L<Recommended Usage|#recommended-usage>
=item1 L<pack.raku plugin add|#packraku-plugin-add>
=item1 L<pack.raku alias add-extra-sources|#packraku-alias-add-extra-sources>
=item1 L<pack.raku alias set-schema|#packraku-alias-set-schema>
=item1 L<pack.raku alias set-podir|#packraku-alias-set-podir>
=item1 L<pack.raku alias set-gettext-domain|#packraku-alias-set-gettext-domain>
=item1 L<pack.raku alias set-out-dir|#packraku-alias-set-out-dir>
=item1 L<pack.raku alias set-force|#packraku-alias-set-force>
=item1 L<pack.raku alias set-package-dir|#packraku-alias-set-package-dir>
=item1 L<pack.raku alias set-extra-sources|#packraku-alias-set-extra-sources>
=item1 L<pack.raku alias append-extra-sources|#packraku-alias-append-extra-sources>
=item1 L<pack.raku alias remove-schema|#packraku-alias-remove-schema>
=item1 L<pack.raku alias remove-podir|#packraku-alias-remove-podir>
=item1 L<pack.raku alias remove-gettext-domain|#packraku-alias-remove-gettext-domain>
=item1 L<pack.raku alias remove-out-dir|#packraku-alias-remove-out-dir>
=item1 L<pack.raku alias remove-extra-sources|#packraku-alias-remove-extra-sources>
=item1 L<pack.raku alias get-schema|#packraku-alias-get-schema>
=item1 L<pack.raku alias get-podir|#packraku-alias-get-podir>
=item1 L<pack.raku alias get-gettext-domain|#packraku-alias-get-gettext-domain>
=item1 L<pack.raku alias get-out-dir|#packraku-alias-get-out-dir>
=item1 L<pack.raku alias get-extra-sources|#packraku-alias-get-extra-sources>
=item1 L<pack.raku alias get-force|#packraku-alias-get-force>
=item1 L<pack.raku alias get-package-dir|#packraku-alias-get-package-dir>

=item1 L<Top of Table of Contents|#table-of-contents>

=head2 key => directory management methods
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

=item1 L<Top of Table of Contents|#table-of-contents>

=head1 Editor functions/methods
=item1 L<pack.raku list editors|#packraku-list-editors>
=item1 L<pack.raku editors stats|#packraku-editors-stats>
=item1 L<pack.raku list editors backups|#packraku-list-editors-backups>
=item1 L<pack.raku backup editors|#packraku-backup-editors>
=item1 L<pack.raku restore editors|#packraku-restore-editors>
=item1 L<pack.raku set editor|#packraku-set-editor>
=item1 L<pack.raku set override GUI_EDITOR|#packraku-set-override-GUI_EDITOR>
=item1 L<pack.raku menu restore editors|#packraku-menu-restore-editors>

=item1 L<Top of Table of Contents|#table-of-contents>

=head1 USAGE stuff
=item1 L<pack.raku USAGE|#packraku-USAGE>
=item1 L<multi sub GENERATE-USAGE|#multi-sub-GENERATE-USAGE>

=item1 L<Top of Table of Contents|#table-of-contents>

=NAME App::pack 
=AUTHOR Francis Grizzly Smit (grizzly@smit.id.au)
=VERSION v0.1.34
=TITLE pack
=SUBTITLE A Raku program to manage the use of B<gnome-extensions pack>, it has too many arguments this makes it easy.

=COPYRIGHT
GPL V3.0+ L<LICENSE|https://github.com/grizzlysmit/Usage-Utils/blob/main/LICENSE>

L<Top of Top of Document|#table-of-contents>

=head1 Introduction

This is a Raku program to manage the use of B<gnome-extensions pack>, it has too many arguments this makes it easy,  as it puts all the arguments in a configuration file. 

=head2 Motivation

The command B<gnome-extensions pack> has too many arguments this takes care of that making it easier to package
up your gnome-shell extensions; at the expense of setting up a configuration file once, and there are methods for that. 

=head3 A brief tutorial.

To create a new plugin just call 

=begin code :lang<bash>

pack.raku plugin new <key> --prefs --schema-file --podirs --force

=end code

You can leave the C«--prefs» out if you don't need settings (i.e. a prefs.js file) you can leave out C«--schema-file» if you do not need a schema file, and you can leave C«--podirs» if you don't want internationalisation and you can leave off C«--force» if you don't want the force parameter when packaging the extension.

The program will prompt for all the parameters it requires once run it will have created a basic extension and moved it into a development location; by default the current directory from which you ran C«pack.raku plugin new» from.
The underlying program B«gnome-extensions create» creates the extension in the directory of the live extensions I move it to the specified development area so you don't mess up your development computer while working, I recommend testing on a VM or at least a less important computer. 
B«NB: I use the words "plugin" extension "interchangeably".»

=item1 L<(See pack.raku plugin new)|#packraku-plugin-new---help>

L<Table of Contents|#table-of-contents>

If you want to manage an existing extension then use:

=begin code :lang<bash>

pack.raku plugin add <key> <uuid> [<extra-sources1> <extra-sources2> ...] --force --mk-schema

=end code

=item1 L<(See pack.raku plugin add)|#packraku-plugin-add>

L<Table of Contents|#table-of-contents>

to package a extension just call 

=begin code :lang<bash>

pack.raku alias do <key> --force

=end code

or to package many this

=begin code :lang<bash>

pack.raku alias do <key0> <key1> <key2> ... <keyn> --force

=end code

=item1 L«See pack.raku alias do --help|#packraku-alias-do---help».

L<Table of Contents|#table-of-contents>

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

L<Table of Contents|#table-of-contents>

=head1 pack.raku do --help

=begin code :lang<bash>

pack.raku do --help
                                                                                                                                                                                           
Usage:
  pack.raku do <dir> [<dirs> ...] [-f|--force] [-c|--command=<Str>] [-q|--quiet|--silent]

=end code

L<Table of Contents|#table-of-contents>

Where
=item1 dir   is a directory containing a B<gnome-shell> plugin
=item2 assumes that the directory contains a C<.pack_args.json> file which containes all the arguments for B<gnome-extensions pack>.
=item1 C«[dirs ...]»  a list of aditional directories containing B<gnome-shell> plugins same as dir.
=item1 C«[-f|--force]»   overrides the force parameter in every C<.pack_args.json>.
=item1 C«[-c|--command=<Str>]»  overrides the command to list the current directory it is asummed this is the same as the output directory for all the plugins.
=item2 the default is B<ls -Flaghi --color=always> this can be overriden by the value of the B<LS_CMD> environment variable but the command-line value overrides both.
=item1 C«[-q|--quiet|--silent]»   if  present then all non-error output is suppressed.

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
=item1 C«<package-dir>»  Directory containing plugin.
=item1 C«[<extra-sources> ...]»  A list of extra files to add to the package.
=item1 C«[-s|--schema=<Str>]»  The path to the schema file.
=item1 C«[-p|--podir=<Str>]»  The path to the po files.
=item1 C«[-g|--gettext-domain=<Str>]»   The gettext domain.
=item1 C«[-o|--out-dir=<Str>]»   The directory to place the package file in.
=item1 C«[-f|--force]»   set the force option.

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
    die "Error: unknown" unless create-config($package-dir,
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
=item1 C«<package-dir>»  Directory containing plugin.
=item1 C«[<extra-sources> ...]»  A list of extra files to add to the package.
=item1 C«[-s|--schema=<Str>]»  The path to the schema file.
=item1 C«[-p|--podir=<Str>]»  The path to the po files.
=item1 C«[-g|--gettext-domain=<Str>]»   The gettext domain.
=item1 C«[-o|--out-dir=<Str>]»   The directory to place the package file in.
=item1 C«[-f|--force]»   set the force option.
=item1 C«[-F|--stomp-force]»   If present then the value of --force wins regradless.
=item1 C«[-S|--stomp]»     If present then @extra-sources stomps on whatever was before otherwise they are spliced together.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('add',
                Str $package-dir,
                Str :s(:$schema) = Str,
                Str :p(:$podir) = Str,
                Str :g(:$gettext-domain) = Str,
                Str :o(:$out-dir) = '.',
                Bool:D :f(:$force) = False,
                Bool:D :F(:$stomp-force) = False,
                Bool:D :S(:$stomp) = False,
                *@extra-sources --> int){
    die "Error: unknown" unless add($package-dir,
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

Set the value of schema in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»   Directory containing plugin.
=item1 C«<schema-value>»  new value of schema.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('set', 'schema', Str $package-dir, Str $schema-value --> int){
    die "Error: unknown" unless add($package-dir, $schema-value, Str, Str, Str, False, False, False, ());
    return 0;
}

=begin pod

=head1 pack.raku set podir

=begin code :lang<bash>

pack.raku set podir --help

Usage:
  pack.raku set podir <package-dir> <podir-value>

=end code

Set the value of podir in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»  Directory containing plugin.
=item1 C«<podir-value>»  new value of podir.
=item2 podir is the path of the directory containing the po files.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('set', 'podir', Str $package-dir, Str $podir-value --> int){
    die "Error: unknown" unless add($package-dir, Str, $podir-value, Str, Str, False, False, False, ());
    return 0;
}

=begin pod

=head1 pack.raku set gettext-domain

=begin code :lang<bash>

pack.raku set gettext-domain --help

Usage:
  pack.raku set gettext-domain <package-dir> <gettext-domain-value>

=end code

Set the value of gettext-domain in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»  Directory containing plugin.
=item1 C«<gettext-domain-value>»  new value of gettext-domain.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('set', 'gettext-domain', Str $package-dir, Str $gettext-domain-value --> int){
    die "Error: unknown" unless add($package-dir, Str, Str, $gettext-domain-value, Str, False, False, False, ());
    return 0;
}

=begin pod

=head1 pack.raku set out-dir

=begin code :lang<bash>

pack.raku set out-dir --help

Usage:
  pack.raku set out-dir <package-dir> <out-dir-value>

=end code

Set the value of out-dir in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»  Directory containing plugin.
=item1 C«<out-dir-value>»  new value of out-dir.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('set', 'out-dir', Str $package-dir, Str $out-dir-value --> int){
    die "Error: unknown" unless add($package-dir, Str, Str, Str, $out-dir-value, False, False, False, ());
    return 0;
}

=begin pod

=head1 pack.raku set force

=begin code :lang<bash>

pack.raku set force --help

Usage:
  pack.raku set force <package-dir> <force-value>

=end code

Set the value of force in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»  Directory containing plugin.
=item1 C«<force-value>»  new value of force.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('set', 'force', Str $package-dir, Bool $force-value --> int){
    die "Error: unknown" unless add($package-dir, Str, Str, Str, Str, $force-value, True, False, ());
    return 0;
}

=begin pod

=head1 pack.raku add-extra-sources

=begin code :lang<bash>

pack.raku add-extra-sources --help

Usage:
  pack.raku add-extra-sources <package-dir> [<extra-sources> ...]

=end code

Add to the value of extra-sources in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»  Directory containing plugin.
=item1 C«[<extra-sources> ...]»  additional extra-sources.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('add-extra-sources', Str $package-dir, *@extra-sources --> int){
    die "Error: unknown" unless add($package-dir, Str, Str, Str, Str, False, False, False, @extra-sources);
    return 0;
}

=begin pod

=head1 pack.raku set package-dir

=begin code :lang<bash>

pack.raku set package-dir --help

Usage:
  pack.raku set package-dir <package-dir> <package-dir-value>

=end code

Set the value of package-dir in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»  Directory containing plugin.
=item1 C«<package-dir-value>»  new value of package-dir.
=item2 probably useless as C«<package-dir>» and C«<package-dir-value>» are to be expected to be the same generally, but if needed it's here.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('set', 'package-dir', Str $package-dir, Str $package-dir-value --> int){
    die "Error: unknown" unless set-package-dir($package-dir, $package-dir-value);
    return 0;
}

=begin pod

=head1 pack.raku set extra-sources

=begin code :lang<bash>

pack.raku set extra-sources --help

Usage:
  pack.raku set extra-sources <package-dir> [<extra-sources> ...]

=end code

Set the value of extra-sources in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»  Directory containing plugin.
=item1 C«[<extra-sources> ...]»  new value of extra-sources.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('set', 'extra-sources', Str $package-dir, *@extra-sources --> int){
    die "Error: unknown" unless add($package-dir, Str, Str, Str, Str, False, False, True, @extra-sources);
    return 0;
}

=begin pod

=head1 pack.raku append extra-sources

=begin code :lang<bash>

pack.raku append extra-sources --help

Usage:
  pack.raku append extra-sources <package-dir> [<extra-sources> ...]

=end code

Append C«[<extra-sources> ...]» to the value of extra-sources in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»  Directory containing plugin.
=item1 C«[<extra-sources> ...]»  value to append to extra-sources.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('append', 'extra-sources', Str $package-dir, *@extra-sources --> int){
    die "Error: unknown" unless add($package-dir, Str, Str, Str, Str, False, False, False, @extra-sources);
    return 0;
}

=begin pod

=head1 pack.raku remove schema

=begin code :lang<bash>

pack.raku remove schema --help

Usage:
  pack.raku remove schema <package-dir>

=end code

Remove the value of schema in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»  Directory containing plugin.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('remove', 'schema', Str $package-dir --> int){
    die "Error: unknown" unless remove($package-dir, 'schema');
    return 0;
}

=begin pod

=head1 pack.raku remove podir

=begin code :lang<bash>

pack.raku remove podir --help

Usage:
  pack.raku remove podir <package-dir>

=end code

Remove the value of podir in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»  Directory containing plugin.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('remove', 'podir', Str $package-dir --> int){
    die "Error: unknown" unless remove($package-dir, 'podir');
    return 0;
}

=begin pod

=head1 pack.raku remove gettext-domain

=begin code :lang<bash>

pack.raku remove gettext-domain --help

Usage:
  pack.raku remove gettext-domain <package-dir>

=end code

Remove the value of gettext-domain in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»  Directory containing plugin.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('remove', 'gettext-domain', Str $package-dir --> int){
    die "Error: unknown" unless remove($package-dir, 'gettext-domain');
    return 0;
}

=begin pod

=head1 pack.raku remove out-dir

=begin code :lang<bash>

pack.raku remove out-dir --help

Usage:
  pack.raku remove out-dir <package-dir>

=end code

Remove the value of out-dir in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»  Directory containing plugin.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('remove', 'out-dir', Str $package-dir --> int){
    die "Error: unknown" unless remove($package-dir, 'out-dir');
    return 0;
}

=begin pod

=head1 pack.raku remove extra-sources

=begin code :lang<bash>

pack.raku remove extra-sources --help

Usage:
  pack.raku remove extra-sources <package-dir>

=end code

Truncate the value of extra-sources in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»  Directory containing plugin.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('remove', 'extra-sources', Str $package-dir --> int){
    die "Error: unknown" unless remove($package-dir, 'extra-sources');
    return 0;
}

=begin pod

=head1 pack.raku get schema

=begin code :lang<bash>

pack.raku get schema --help

Usage:
  pack.raku get schema <package-dir>

=end code

Get the value of schema in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»  Directory containing plugin.

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

Get the value of podir in C«<package-dir>/.pack_args.json»
=item1 C«NB: podir is the path to the directory containing the po files.»

Where
=item1 C«<package-dir>»  Directory containing plugin.

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

Get the value of gettext-domain in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»  Directory containing plugin.

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

Get the value of out-dir in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»  Directory containing plugin.

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

Get the value of extra-sources in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»  Directory containing plugin.

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

Get the value of force in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»  Directory containing plugin.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('get', 'force', Str $package-dir --> int){
    die "Error: parameter unknown" unless get($package-dir, 'force');
    return 0;
}

=begin pod

=head1 pack.raku get package-dir

=begin code :lang<bash>

pack.raku get package-dir --help

Usage:
  pack.raku get package-dir <package-dir>

=end code

Get the value of package-dir in C«<package-dir>/.pack_args.json»

Where
=item1 C«<package-dir>»  Directory containing plugin.
=item2 kind of redundant as it needs C«package-dir» to get C«package-dir».

L<Table of Contents|#table-of-contents>

=end pod

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
=item1 C«<key>»  is a faily arbitray key.
=item1 C«<target>»  is a path to a directory containing a B<gnome-shell> plugin.
=item1 C«[-s|--set|--force]»     if present then add the key directory pair even if it requires overwriting an existing entry.
=item1 C«[-c|--comment=<Str>]»   A comment to describe the key directory pair.

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
=item1 C«[keys ...]»  a list of aditional keys pointing to directories in the directory database containing B<gnome-shell> plugins same as key.
=item1 C«[-f|--force]»   overrides the force parameter in every C<.pack_args.json>.
=item1 C«[-c|--command=<Str>]»  overrides the command to list the current directory it is asummed this is the same as the output directory for all the plugins.
=item2 the default is B<ls -Flaghi --color=always> this can be overriden by the value of the B<LS_CMD> environment variable but the command-line value overrides both.
=item1 C«[-q|--quiet|--silent]»   if  present then all non-error output is suppressed.

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

=head1 pack.raku plugin new --help

=begin code :lang<bash>

pack.raku plugin new --help

Usage:
  pack.raku plugin new <key>  [--uuid=<Str>] [--name=<Str>] [--description=<Str>] [--gettext-domain=<Str>] [--settings-schema=<Str>] [--template=<Str>] [--prefs] [--schema-file] [--podirs] [-f|--force] [-s|--silent] [-l|--dev-lang=<Str>] [-o|--output|--development-dir|--dev-dir=<Str>]

=end code

Make a new plugin/extension for gnome-shell 
Create a new plugin using C«gnome-extensions create» and move it to a development area and set it up for C«pack.raku alias do» etc.

Where
=item1 C«<key>»                      A key which will be used to select the extension you wish to work with.
=item2                                 This is the only mandatory parameter.
=item3                                    B«All the following 6 parameters can be left out and the program will prompt for them.»
=item3                                    And it is recommended to leave C«--template» to be prompted for as this can be tricky to do manually.
=item1 C«[--uuid=<Str>]»             The unique identifier of the new extension.
=item1 C«[--name=<Str>]»             The user-visible name of the new extension.
=item1 C«[--description=<Str>]»      A short description of what the extension does.
=item1 C«[--gettext-domain=<Str>]»   The gettext domain used by the extension.
=item1 C«[--settings-schema=<Str>]»  The GSettings schema used by the extension.
=item1 C«[--template=<Str>]»         The template to use for the new extension.
=item2                               B«The following parameters will not be prompted for.»
=item1 C«[--prefs]»                  Include prefs.js template.
=item1 C«[--schema-file]»            Add a schema file by name of C«schemas/org.gnome.shell.extensions.{$gettext-domain}.gschema.xml».
=item1 C«[--podirs]»                 Add a po directory with gettext files preloaded; plus a C«compile.sh» script to build and update the gettext files.
=item1 C«[-f|--force]»               Add the force parameter to the C«.pack_args.json» file.
=item1 C«[-s|--silent]»              Don't print out the steps taken defaults to C«False».
=item1 C«[-l|--dev-lang=<Str>]»      The language of the default C«*.po» file to generate this should be the language the strings are in in the original source defaults to B«en».
=item1 C«[-o|--output|--development-dir|--dev-dir=<Str>]»  The directory to develop the plugin from; defaults to the current dir.

L<Table of Contents|#table-of-contents>

=head2 Recommended Usage

It is recommended that you use the following command line to get pretty much everything in you could desire in the starting point of your plugin/extension.

=begin code :lang<bash>

pack.raku plugin new <key> --prefs --schema-file --podirs --force

=end code

=item1 B«NB:»
=item2 The key C«<key>» must be replaced with a real key.

This whole development model assumes that you don't want to develop the plugin/extension live as is C«gnome-extensions create» model so I copy the plugin out line generated by C«gnome-extensions create» to another location I use C«~/Projects/gnome-shell/extensions/» and deleting the original that C«gnome-extensions create» generates.  

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('plugin', 'new', Str:D $key, Str :$uuid = Str, Str :$name = Str, Str :$description = Str,
                Str :$gettext-domain = Str, Str :$settings-schema = Str, Str :$template = Str,
                Bool:D :$prefs = False, Bool:D :$schema-file = False, Bool:D :$podirs = False,
                Bool:D :f(:$force) = False, Bool:D :s(:$silent) = False, Bool:D :b(:$backtrace) = False,
                Str:D :l(:$dev-lang) = ((%*ENV«DEV_LANG»:exists) ?? (~%*ENV«DEV_LANG») !! 'en'), 
                Str:D :o(:output(:development-dir(:$dev-dir))) = '.' --> int) {
    my Str:D $home = ~%*ENV«HOME»;
    my Str:D $xdg_config_home = (%*ENV«XDG_CONFIG_HOME»:exists ?? ~%*ENV«XDG_CONFIG_HOME» !! "$home/.local/share" );
    unless new-plugin($key, $uuid, $name, $description, $gettext-domain, $settings-schema, $template,
                      $prefs, $schema-file, $podirs, $force, $home, $xdg_config_home, $silent,
                      $backtrace, $dev-lang, ($dev-dir.IO.resolve.absolute.Str)) {
        die "new-plugin exited with a bad value {exitcode}";
    }
    return 0;
} #`«« multi sub MAIN('plugin', 'new', Str:D $key, Str :$uuid is copy = Str, Str :$name is copy = Str,
                Str :$description is copy = Str, Str :$gettext-domain is copy = Str,
                Str :$settings-schema is copy = Str, Str :$template is copy = Str,
                Bool:D :$prefs is copy = False, Bool:D :i(:$interactive) is copy = False,
                Str:D :$xdg_config_home =
                    ((%*ENV«XDG_CONFIG_HOME»:exists) ?? (~%*ENV«XDG_CONFIG_HOME») !! (~%*ENV«HOME» ~ '/.local/share'))
                                                                                                                 --> int) »»

=begin pod

=head1 pack.raku plugin add

=begin code :lang<bash>

pack.raku plugin add  --help

Usage:
  pack.raku plugin add <key> <uuid> [<extra-sources> ...] [-p|--extension-dir=<Str>] [--podir=<Str>] [-f|--force] [-s|--silent] [-b|--backtrace] [-m|--mk-schema] [-l|--dev-lang=<Str>]

=end code

Use this to add an existing extension into management by C«pack.raku».

Where
=item1 C«<key>»                       The key to reference this extension by (mandatory).
=item1 C«<uuid>»                      The unique id of the extension (mandatory).
=item2                                    The key directory pair will be C«<key> => $extension-dir/$uuid.»
=item3                                        The description in the C«metadata.json» file will form the pairs comment.
=item1 C«[<extra-sources> ...]»       An arbitrarily long list of additional files to add to the extensions package.
=item2                                   can be files other than JavaScript source.
=item1 C«[-p|--extension-dir=<Str>]»  The directory the plugin lives in defaults to C«.» the current directory.
=item1 C«[--podir=<Str>]»             The name of the directory where the internationalisation source is kept defaults to C«'po'».
=item2                                    B«NB:» Will generate the C«compile.sh» file if it doesn't already exist.
=item1 C«[-f|--force]»                The force parameter for C«.pack_args.json» file.
=item1 C«[-s|--silent]»               If True then don't show progress or error messages defaults to False.
=item1 C«[-b|--backtrace]»            Show backtrace info on error (only works if not silent).
=item1 C«[-m|--mk-schema]»            Make the schema file if it doesn't exist.
=item1 C«[-l|--dev-lang=<Str>]»       The language of the default C«*.po» file to generate this should be the language the strings are in in the original source defaults to B«en».

Typical use:

=begin code :lang<bash>

pack.raku plugin add <key> <uuid> [<extra-sources1> <extra-sources2> ...] --force --mk-schema

=end code


L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('plugin', 'add', Str:D $key, Str:D $uuid, Str:D :p(:extension-dir($plugin-dir)) = '.',
                Str:D :$podir = 'po', Bool:D :f(:$force) = False, Bool:D :s(:$silent) = False,
                Bool:D :b(:$backtrace) = False, Bool:D :m(:$mk-schema) = False,
                Str:D :l(:$dev-lang) = ((%*ENV«DEV_LANG»:exists) ?? (~%*ENV«DEV_LANG») !! 'en'), 
                *@extra-sources --> int) {
    my Str:D $home = ~%*ENV«HOME»;
    my Str:D $xdg_config_home = (%*ENV«XDG_CONFIG_HOME»:exists ?? ~%*ENV«XDG_CONFIG_HOME» !! "$home/.local/share" );
    unless add-plugin($key, ($plugin-dir.resolve.absolute.Str), $uuid, $podir, $force, $home, $xdg_config_home,
                $silent, $backtrace, $dev-lang, $mk-schema, @extra-sources) {
        die "run exited with a bad value {exitcode}";
    }
    return 0;
} #`«« multi sub MAIN('plugin', 'add', Str:D $key, Str:D :p(:extension-dir($plugin-dir)) = '.',
                Str :$uuid = Str, Str :$name = Str, Str :$description = Str,
                Str :$gettext-domain = Str, Str :$settings-schema = Str, Str :$template = Str,
                Bool:D :$prefs = False, Bool:D :$schema-file = False, Bool:D :$podirs = False,
                Bool:D :f(:$force) = False, Bool:D :s(:$silent) = False,
                Str:D :l(:$dev-lang) = ((%*ENV«DEV_LANG»:exists) ?? (~%*ENV«DEV_LANG») !! 'en'), 
                Str:D :o(:output(:development-dir(:$dev-dir))) = '.' --> int) »»

=begin pod

=head1 pack.raku alias add-extra-sources

=begin code :lang<bash>

pack.raku alias add-extra-sources --help

Usage:
  pack.raku alias add-extra-sources <key> [<extra-sources> ...]

=end code

Add sources to the B«extra-sources» list.

Where
=item1 C«<key>»                    The key of the extension to add to.
=item1 C«[<extra-sources> ...]»    Additional sources to add to the B«extra-sources» list.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'add-extra-sources', Str:D $key, *@extra-sources --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: unknown" unless add($package-dir, Str, Str, Str, Str, False, False, False, @extra-sources);
    return 0;
}

=begin pod

=head1 pack.raku alias set-schema

=begin code :lang<bash>

pack.raku alias set-schema --help

Usage:
  pack.raku alias set-schema <key> <schema-value>

=end code

Set the value of the B«schema».

Where
=item1 C«<key>»           The key of the extension to add to.
=item1 C«<schema-value>»  New value of schema.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'set-schema', Str $key, Str $schema-value --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: unknown" unless add($package-dir, $schema-value, Str, Str, Str, False, False, False, ());
    return 0;
}

=begin pod

=head1 pack.raku alias set-podir

=begin code :lang<bash>

pack.raku alias set-podir --help

Usage:
  pack.raku alias set-podir <key> <podir-value>

=end code

Set the value of podir in C«<package-dir>/.pack_args.json»

Where
=item1 C«<key>»          The key of the extension.
=item1 C«<podir-value>»  New value of podir.
=item2                   podir is the path of the directory containing the po files, relative to the extensions development directory.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'set-podir', Str $key, Str $podir-value --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: unknown" unless add($package-dir, Str, $podir-value, Str, Str, False, False, False, ());
    return 0;
}

=begin pod

=head1 pack.raku alias set-gettext-domain

=begin code :lang<bash>

pack.raku alias set-gettext-domain --help

Usage:
  pack.raku alias set-gettext-domain <key> <gettext-domain-value>

=end code

Set the value of C«gettext-domain» in C«<package-dir>/.pack_args.json»

Where
=item1 C«<key>»                   The key of the extension.
=item1 C«<gettext-domain-value>»  New value of gettext-domain.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'set-gettext-domain', Str $key, Str $gettext-domain-value --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: unknown" unless add($package-dir, Str, Str, $gettext-domain-value, Str, False, False, False, ());
    return 0;
}

=begin pod

=head1 pack.raku alias set-out-dir

=begin code :lang<bash>

pack.raku alias set-out-dir --help

Usage:
  pack.raku alias set-out-dir <key> <out-dir-value>

=end code

Set the value of out-dir in C«<package-dir>/.pack_args.json»

Where
=item1 C«<key>»            The key of the extension.
=item1 C«<out-dir-value>»  New value of out-dir.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'set-out-dir', Str $key, Str $out-dir-value --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: unknown" unless add($package-dir, Str, Str, Str, $out-dir-value, False, False, False, ());
    return 0;
}

=begin pod

=head1 pack.raku alias set-force

=begin code :lang<bash>

pack.raku alias set-force --help

Usage:
  pack.raku alias set-force <key> <force-value>

=end code

Set the value of force in C«<package-dir>/.pack_args.json»

Where
=item1 C«<key>»          The key of the extension.
=item1 C«<force-value>»  New value of force.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'set-force', Str $key, Bool $force-value --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: unknown" unless add($package-dir, Str, Str, Str, Str, $force-value, True, False, ());
    return 0;
}

=begin pod

=head1 pack.raku alias set-package-dir

=begin code :lang<bash>

pack.raku alias set-package-dir --help

Usage:
  pack.raku alias set-package-dir <key> <package-dir-value>

=end code

Add to the value of extra-sources in C«<package-dir>/.pack_args.json»

Where
=item1 C«<key>»                  The key of the extension.
=item1 C«[<extra-sources> ...]»  Additional extra-sources.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'set-package-dir', Str $key, Str $package-dir-value --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: unknown" unless set-package-dir($package-dir, $package-dir-value);
    return 0;
}

=begin pod

=head1 pack.raku alias set-extra-sources

=begin code :lang<bash>

pack.raku alias set-extra-sources --help

Usage:
  pack.raku alias set-extra-sources <key> [<extra-sources> ...]

=end code

Set the value of extra-sources in C«<package-dir>/.pack_args.json»

Where
=item1 C«<key>»                  The key of the extension.
=item1 C«[<extra-sources> ...]»  New value of extra-sources.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'set-extra-sources', Str $key, *@extra-sources --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: unknown" unless add($package-dir, Str, Str, Str, Str, False, False, True, @extra-sources);
    return 0;
}

=begin pod

=head1 pack.raku alias append-extra-sources

=begin code :lang<bash>

pack.raku alias append-extra-sources --help

Usage:
  pack.raku alias append-extra-sources <key> [<extra-sources> ...]

=end code

Append C«[<extra-sources> ...]» to the value of extra-sources in C«<package-dir>/.pack_args.json»

Where
=item1 C«<key>»                  The key of the extension.
=item1 C«[<extra-sources> ...]»  List of values to append to extra-sources.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'append-extra-sources', Str $key, *@extra-sources --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: unknown" unless add($package-dir, Str, Str, Str, Str, False, False, False, @extra-sources);
    return 0;
}

=begin pod

=head1 pack.raku alias remove-schema

=begin code :lang<bash>

pack.raku alias remove-schema --help

Usage:
  pack.raku alias remove-schema <key>

=end code

Remove the value of schema in C«<package-dir>/.pack_args.json»

Where
=item1 C«<key>»            The key of the extension.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'remove-schema', Str $key --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: unknown" unless remove($package-dir, 'schema');
    return 0;
}

=begin pod

=head1 pack.raku alias remove-podir

=begin code :lang<bash>

pack.raku alias remove-podir --help

Usage:
  pack.raku alias remove-podir <key>

=end code

Remove the value of C«podir» in C«<package-dir>/.pack_args.json»

Where
=item1 C«<key>»            The key of the extension.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'remove-podir', Str:D $key --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: unknown" unless remove($package-dir, 'podir');
    return 0;
}

=begin pod

=head1 pack.raku alias remove-gettext-domain

=begin code :lang<bash>

pack.raku alias remove-gettext-domain --help

Usage:
  pack.raku alias remove-gettext-domain <key>

=end code

Remove the value of gettext-domain in C«<package-dir>/.pack_args.json»

Where
=item1 C«<key>»            The key of the extension.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'remove-gettext-domain', Str:D $key --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: unknown" unless remove($package-dir, 'gettext-domain');
    return 0;
}

=begin pod

=head1 pack.raku alias remove-out-dir

=begin code :lang<bash>

pack.raku alias remove-out-dir --help

Usage:
  pack.raku alias remove-out-dir <key>

=end code

Remove the value of out-dir in C«<package-dir>/.pack_args.json»

Where
=item1 C«<key>»            The key of the extension.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'remove-out-dir', Str:D $key --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: unknown" unless remove($package-dir, 'out-dir');
    return 0;
}

=begin pod

=head1 pack.raku alias remove-extra-sources

=begin code :lang<bash>

pack.raku alias remove-extra-sources --help

Usage:
  pack.raku alias remove-extra-sources <key>

=end code

Truncate the C«extra-sources» list in C«<package-dir>/.pack_args.json».

Where
=item1 C«<key>»            The key of the extension.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'remove-extra-sources', Str:D $key --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: unknown" unless remove($package-dir, 'extra-sources');
    return 0;
}

=begin pod

=head1 pack.raku alias get-schema

=begin code :lang<bash>

pack.raku alias get-schema --help

Usage:
  pack.raku alias get-schema <key>

=end code

Get the value of schema in C«<package-dir>/.pack_args.json»

Where
=item1 C«<key>»            The key of the extension.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'get-schema', Str:D $key --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: parameter unknown" unless get($package-dir, 'schema');
    return 0;
}

=begin pod

=head1 pack.raku alias get-podir

=begin code :lang<bash>

pack.raku alias get-podir --help

Usage:
  pack.raku alias get-podir <key>

=end code

Get the value of C«podir» in C«<package-dir>/.pack_args.json»
=item1 B«NB: C<podir> is the path to the directory containing the po files.»

Where
=item1 C«<key>»            The key of the extension.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'get-podir', Str:D $key --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: parameter unknown" unless get($package-dir, 'podir');
    return 0;
}

=begin pod

=head1 pack.raku alias get-gettext-domain

=begin code :lang<bash>

pack.raku alias get-gettext-domain --help

Usage:
  pack.raku alias get-gettext-domain <key>

=end code

Get the value of C«gettext-domain» in C«<package-dir>/.pack_args.json»

Where
=item1 C«<key>»            The key of the extension.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'get-gettext-domain', Str:D $key --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: parameter unknown" unless get($package-dir, 'gettext-domain');
    return 0;
}

=begin pod

=head1 pack.raku alias get-out-dir

=begin code :lang<bash>

pack.raku alias get-out-dir --help

Usage:
  pack.raku alias get-out-dir <key>

=end code
=item1 C«<key>»            The key of the extension.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'get-out-dir', Str:D $key --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: parameter unknown" unless get($package-dir, 'out-dir');
    return 0;
}

=begin pod

=head1 pack.raku alias get-extra-sources

=begin code :lang<bash>

pack.raku alias get-extra-sources --help

Usage:
  pack.raku alias get-extra-sources <key>

=end code

Get the value of the C«extra-sources» list in C«<package-dir>/.pack_args.json».

Where
=item1 C«<key>»            The key of the extension.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'get-extra-sources', Str:D $key --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: parameter unknown" unless get($package-dir, 'extra-sources');
    return 0;
}

=begin pod

=head1 pack.raku alias get-force

=begin code :lang<bash>

pack.raku alias get-force --help

Usage:
  pack.raku alias get-force <key>

=end code

Get the value of force in C«<package-dir>/.pack_args.json»

Where
=item1 C«<key>»            The key of the extension.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'get-force', Str:D $key --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: parameter unknown" unless get($package-dir, 'force');
    return 0;
}

=begin pod

=head1 pack.raku alias get-package-dir

=begin code :lang<bash>

pack.raku alias get-package-dir --help

Usage:
  pack.raku alias get-package-dir <key>

=end code

Get the value of package-dir in C«<package-dir>/.pack_args.json»

Where
=item1 C«<key>»            The key of the extension.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('alias', 'get-package-dir', Str:D $key --> int){
    my Str:D $package-dir = path($key);
    die "key: $key not found" unless $package-dir;
    die "Error: parameter unknown" unless get($package-dir, 'package-dir');
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
=item1 C«[<prefix>]»  If present then search for keys starting with the string value.
=item1 C«[-c|--color|--colour]»  If present then show with ANSI colours.
=item1 C«[-s|--syntax]»  If present will override colour setting and display with syntax highlighted colours.
=item1 C«[-l|--page-length[=Int]]»  Set the page length before headers are re-shown.
=item1 C«[-p|--pattern=<Str>]»  A Raku regex to use to search for the matching keys.
=item1 C«[-e|--ecma-pattern=<Str>]»  A ECMA262Regex regex to use to search for the matching keys.
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
=item1 C«[<prefix>]»  If present then search for keys, directories or comments starting with the string value.
=item1 C«[-c|--color|--colour]»  If present then show with ANSI colours.
=item1 C«[-s|--syntax]»  If present will override colour setting and display with syntax highlighted colours.
=item1 C«[-l|--page-length[=Int]]»  Set the page length before headers are re-shown.
=item1 C«[-p|--pattern=<Str>]»  A raku regex to use to search for the matching keys, directories or comments.
=item1 C«[-e|--ecma-pattern=<Str>]»  A ECMA262Regex regex to use to search for the matching keys, directories or comments.
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
=item1 C«[<keys> ...]»  the keys of the key/directory pairs that you want to delete.
=item1 C«[-d|--delete|--do-not-trash]» If true then actually delete otherwise trash.
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
=item1 C«NB: alias for delete»

Where
=item1 C«[<keys> ...]»  the keys of the key/directory pairs that you want to delete.
=item1 C«[-d|--delete|--do-not-trash]» If true then actually delete otherwise trash.
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
=item1 C«[<keys> ...]»  the keys of the key/directory pairs that you want to trash.

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
=item1 C«<key>»                              The key of the record to add the comment to.
=item1 C«<comment>»                          The comment.
=item1 C«[-k|--kind=<Str where \{ ... } >]»  The kind of record to add the comment to.
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
=item1 C«[<prefix>]»  If present then search for keys, directories or comments starting with the string value.
=item1 C«[-c|--color|--colour]»  If present then show with ANSI colours.
=item1 C«[-s|--syntax]»  If present will override colour setting and display with syntax highlighted colours.
=item1 C«[-l|--page-length[=Int]]»  Set the page length before headers are re-shown.
=item1 C«[-p|--pattern=<Str>]»  A raku regex to use to search for the matching keys, directories or comments.
=item1 C«[-e|--ecma-pattern=<Str>]»  A ECMA262Regex regex to use to search for the matching keys, directories or comments.
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
=item1 C«[<keys> ...]» The keys of the records to undelete.

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
=item1 C«[<prefix>]»                If present then search for keys starting with the string value.
=item1 C«[-c|--color|--colour]»     If present then show with ANSI colours.
=item1 C«[-s|--syntax]»             If present will override colour setting and display with syntax highlighted colours.
=item1 C«[-p|--pattern=<Str>]»      A Raku regex to use to search for the matching keys.
=item1 C«[-e|--ecma-pattern=<Str>]» A ECMA262Regex regex to use to search for the matching keys..
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
=item1 C«alias for show stats.»

Where
=item1 C«[<prefix>]»                If present then search for keys starting with the string value.
=item1 C«[-c|--color|--colour]»     If present then show with ANSI colours.
=item1 C«[-s|--syntax]»             If present will override colour setting and display with syntax highlighted colours.
=item1 C«[-p|--pattern=<Str>]»      A Raku regex to use to search for the matching keys.
=item1 C«[-e|--ecma-pattern=<Str>]» A ECMA262Regex regex to use to search for the matching keys..
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
=item1 C«[-w|--win-format|--use-windows-formatting]» Use windows compatible file names for the backup file.
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

Restore the db file from restore-from.

Where
=item1 C«[<restore-from>]» A path to a restore file.

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

=item1 C«[<message>]»           A message to display above the menu (currently not used in colour and syntax modes).
=item1 C«[-c|--color|--colour]» Use ANSI colour mode.
=item1 C«[-s|--syntax]»         Use ANSI colour mode with syntax highlighting.
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
=item1 C«[<prefix>]»                          List only those whose name starts with prefix (case insensitive).
=item1 C«[-c|--color|--colour] [-s|--syntax]» List in colour..
=item1 C«[-s|--syntax]»                       List in syntax highlighted colour.
=item1 C«[-l|--page-length[=Int]]»            List in pages of length $page-length.
=item1 C«[-p|--pattern=<Str>]»                List only those matching this Raku regex.
=item1 C«[-e|--ecma-pattern=<Str>]»           List only those matching this EMCA262Regex regex.
=item1 C«The EMCA262Regex library doesn't support ignore case well.» .

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
=item1 C«[<prefix>]»                          List only those whose name starts with prefix (case insensitive).
=item1 C«[-c|--color|--colour] [-s|--syntax]» List in colour..
=item1 C«[-s|--syntax]»                       List in syntax highlighted colour.
=item1 C«[-l|--page-length[=Int]]»            List in pages of length $page-length.
=item1 C«[-p|--pattern=<Str>]»                List only those matching this Raku regex.
=item1 C«[-e|--ecma-pattern=<Str>]»           List only those matching this EMCA262Regex regex.
=item1 C«The EMCA262Regex library doesn't support ignore case well.» .

=begin code :lang<bash>

pack.raku list editors
                         
Editors | Actual Editor  
=========================
gedit   |                
gvim    |             *  
kate    |                
xemacs  |                
=========================

=end code

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

=begin pod

=head1 pack.raku editors stats

=begin code :lang<bash>

pack.raku editors stats --help

Usage:
  pack.raku editors stats [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]

=end code

Show the statistics for the editors database.

Where
=item1 C«[<prefix>]»                If present then search for keys starting with the string value.
=item1 C«[-c|--color|--colour]»     If present then show with ANSI colours.
=item1 C«[-s|--syntax]»             If present will override colour setting and display with syntax highlighted colours.
=item1 C«[-p|--pattern=<Str>]»      A Raku regex to use to search for the matching keys.
=item1 C«[-e|--ecma-pattern=<Str>]» A ECMA262Regex regex to use to search for the matching keys..
=item2 B«NB: uses a imperfect library to convert the EMCA262Regex to a Raku one.»
=item2 B«NB: pattern and ecma-pattern search by the quantity keys, note the values.»

=begin code :lang<bash>

pack.raku editors stats
                                          
Variable               |   Value          
==========================================
$editor                |            gvim  
$override-GUI_EDITOR   |            True  
%*ENV<EDITOR>          |    /usr/bin/vim  
%*ENV<VISUAL>          |    /usr/bin/vim  
%*ENV«GUI_EDITOR»      |   /usr/bin/gvim  
@default-editors       |      [ "gvim" ]  
@override-gui_editor   |          [True]  
==========================================

=end code

L<Table of Contents|#table-of-contents>

=end pod

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

=begin pod

=head1 pack.raku list editors backups

=begin code :lang<bash>

pack.raku list editors backups --help

Usage:
  pack.raku list editors backups [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]

=end code

Show the statistics for the editors database.

Where
=item1 C«[<prefix>]»                If present then search for keys starting with the string value.
=item1 C«[-c|--color|--colour]»     If present then show with ANSI colours.
=item1 C«[-s|--syntax]»             If present will override colour setting and display with syntax highlighted colours.
=item1 C«[-p|--pattern=<Str>]»      A Raku regex to use to search for the matching keys.
=item1 C«[-e|--ecma-pattern=<Str>]» A ECMA262Regex regex to use to search for the matching keys..
=item2 B«NB: uses a imperfect library to convert the EMCA262Regex to a Raku one.»
=item2 B«NB: pattern and ecma-pattern search by the quantity keys, note the values.»

=begin code :lang<bash>

pack.raku list editors backups
                                                                                                                     
Permissions Size   User        Group       Date Modified                    Backup                                   
=====================================================================================================================
.rw-rw-r--  802.0B grizzlysmit grizzlysmit 2023-12-11T00:23:41.634625+10:00 editors.2023-12-11T01:24:20              
.rw-rw-r--  802.0B grizzlysmit grizzlysmit 2023-12-11T20:15:51.038790+10:00 editors.2023-12-11T21:16:28.034522+11:00 
.rw-rw-r--  802.0B grizzlysmit grizzlysmit 2023-12-11T20:58:20.835630+10:00 editors.2023-12-11T21:58:57.832862+11:00 
.rw-rw-r--  833.0B grizzlysmit grizzlysmit 2023-12-11T22:21:21.450694+10:00 editors.2023-12-11T23:21:58.449520+11:00 
.rw-rw-r--  820.0B grizzlysmit grizzlysmit 2023-12-11T22:31:34.183842+10:00 editors.2023-12-11T23:32:11.181779+11:00 
.rw-rw-r--  820.0B grizzlysmit grizzlysmit 2023-12-12T20:59:45.479111+10:00 editors.2023-12-12T22:00:22.468348+11:00 
.rw-rw-r--  820.0B grizzlysmit grizzlysmit 2023-12-30T07:25:06.941870+10:00 editors.2023-12-30T08:25:43.939760+11:00 
.rw-rw-r--  820.0B grizzlysmit grizzlysmit 2023-12-30T12:36:10.532847+10:00 editors.2023-12-30T13:36:47.532341+11:00 
.rw-rw-r--  820.0B grizzlysmit grizzlysmit 2023-12-31T15:36:43.791920+10:00 editors.2023-12-31T16:37:20.781525+11:00 
.rw-rw-r--  820.0B grizzlysmit grizzlysmit 2023-12-31T16:59:08.910346+10:00 editors.2023-12-31T17:59:45.906433+11:00 
.rw-rw-r--  820.0B grizzlysmit grizzlysmit 2023-12-31T17:10:53.742754+10:00 editors.2023-12-31T18:11:30.735343+11:00 
.rw-rw-r--  820.0B grizzlysmit grizzlysmit 2024-01-02T22:56:24.817173+10:00 editors.2024-01-02T23:57:01.808884+11:00 
.rw-rw-r--  820.0B grizzlysmit grizzlysmit 2024-01-04T02:40:03.140891+10:00 editors.2024-01-04T03:40:40.002896+11:00 
.rw-rw-r--  820.0B grizzlysmit grizzlysmit 2024-01-04T02:41:03.757027+10:00 editors.2024-01-04T03:41:40.749044+11:00 
.rw-rw-r--  820.0B grizzlysmit grizzlysmit 2024-01-04T02:47:47.097922+10:00 editors.2024-01-04T03:48:24.025215+11:00 
=====================================================================================================================

=end code

L<Table of Contents|#table-of-contents>

=end pod

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

=begin pod

=head1 pack.raku backup editors

=begin code :lang<bash>

pack.raku backup editors --help

Usage:
  pack.raku backup editors  [-w|--use-windows-formatting]

=end code

Backup the editors db file.
=item1 C«[-w|--win-format|--use-windows-formatting]» Use windows compatible file names for the backup file.
=item2 B«NB:» The backup file looks like editors.2025-06-02T00:02:07.886302+10:00 normally but if you use this option then it will be like editors.2025-07-05T09.29.03·560644+10.00 as : is a special char in windows filename names.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('backup', 'editors', Bool:D :w(:$use-windows-formatting) = False) returns Int {
   if backup-editors($use-windows-formatting) {
       exit 0;
   } else {
       exit 1;
   } 
}

=begin pod

=head1 pack.raku restore editors

=begin code :lang<bash>

pack.raku restore editors --help

Usage:
  pack.raku restore editors <restore-from>

=end code

Restore the editors db file from restore-from.

Where
=item1 C«[<restore-from>]» A path to a restore file.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('restore', 'editors', Str:D $restore-from) returns Int {
   if restore-editors($restore-from.IO) {
       exit 0;
   } else {
       exit 1;
   } 
}

=begin pod

=head1 pack.raku set editor

=begin code :lang<bash>

pack.raku set editor --help

Usage:
  pack.raku set editor <editor> [<comment>]

=end code

Set the default editor to use.

Where
=item1 C«<editor>»    The editor to make default.
=item1 C«[<comment>]» A comment to put against the editor.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('set', 'editor', Str:D $editor, Str $comment = Str) returns Int {
   if set-editor($editor, $comment) {
       exit 0;
   } else {
       exit 1;
   } 
}

=begin pod

=head1 pack.raku set override GUI_EDITOR

=begin code :lang<bash>

pack.raku set override GUI_EDITOR --help

Usage:
  pack.raku set override GUI_EDITOR <value> [<comment>]

=end code

Set the value of the override-GUI_EDITOR parameter 

Where
=item1 C«<value>»     The value of the parameter (True or False).
=item1 C«[<comment>]» A comment to place against the parameter.

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('set', 'override', 'GUI_EDITOR', Bool:D $value, Str $comment = Str) returns Int {
   if set-override-GUI_EDITOR($value, $comment) {
       exit 0;
   } else {
       exit 1;
   } 
}

=begin pod

=head1 pack.raku menu restore editors

=begin code :lang<bash>

pack.raku menu restore editors --help

Usage:
  pack.raku menu restore editors [<message>]  [-c|--color|--colour] [-s|--syntax]

=end code

Restore the editors db using a menu of backups from the standard directory.

Where
=item1 C«[<message>]»           A message to display above the menu only works in monochrome version.
=item1 C«[-c|--color|--colour]» Use ANSI colour mode.
=item1 C«[-s|--syntax]»         Use ANSI colour mode and syntax highlighting.

L<Table of Contents|#table-of-contents>

=end pod

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

=begin pod

=head1 pack.raku USAGE

=begin code :lang<bash>

pack.raku USAGE [-n|--nocolor|--nocolour]

=end code

Shows the USAGE  without this method purpose is to implement the coloured usage.

Where
=item1 C«[-n|--nocolor|--nocolour]» Show the usage in monochrome.

L<Table of Contents|#table-of-contents>

=end pod

sub USAGE(Bool:D :n(:nocolor(:$nocolour)) = False, *%named-args, *@args --> Int) {
    say-coloured($*USAGE, False, %named-args, @args);
    exit 0;
}

=begin pod

=head1 multi sub GENERATE-USAGE

=begin code :lang<raku>

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

=end code

Does the real work generating the colored usage.

L<Table of Contents|#table-of-contents>

=end pod

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
