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
=item3 L<To create a new plugin just call|#to-create-a-new-plugin-just-call>
=item3 L<example of using pack.raku plugin new key --all --force|#example-of-using-packraku-plugin-new-key---all---force>
=item3 L<If you want to manage an existing extension then use|#if-you-want-to-manage-an-existing-extension-then-use>
=item3 L<example of using pack.raku plugin add|#example-of-using-packraku-plugin-add>
=item3 L<To package a extension just call|#to-package-a-extension-just-call>
=item3 L<example of creating packages|#example-of-creating-packages>
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
=VERSION v0.1.46
=TITLE pack
=SUBTITLE A Raku program to manage the use of B<gnome-extensions pack>, it has too many arguments this makes it easy.

=COPYRIGHT
GPL V3.0+ L<LICENSE|https://github.com/grizzlysmit/Usage-Utils/blob/main/LICENSE>

L<Top of Top of Document|#table-of-contents>

=head1 Introduction

This is a Raku program to manage the use of B<gnome-extensions>, originally B<gnome-extensions pack>, it has too many arguments this makes it easy,  as it puts all the arguments in a configuration file. 

=head2 Motivation

The original motivation was that the command B<gnome-extensions pack> has too many arguments this takes care of that making it easier to package up your gnome-shell extensions; at the expense of setting up a configuration file once, and there are methods for that. 

Now in addition I wrap B<gnome-extensions create> as well, plus I create extra stuff like the schema file, the credits field in the C«metadata.json» file; it also creates the po dir and creates B<compile.sh> to populate it with the gettext stuff, and to process the schema file into it's binary form.

=head2 A brief tutorial.

=head3 To create a new plugin just call 

=begin code :lang<bash>

pack.raku plugin new <key> --all --force

=end code

You can alternately use C«--prefs --schema-file --podirs --add-credits» leave out the C«--prefs» out if you don't need settings (i.e. a prefs.js file), you can leave out C«--schema-file» if you do not need a schema file, you can leave C«--podirs» if you don't want internationalisation, you can leave of C«--add-credits» if you don't want to add credits and you can leave off C«--force» if you don't want the force parameter when packaging the extension.

The program will prompt for all the parameters it requires once run it will have created a basic extension and moved it into a development location; B<by default the current directory from which you ran C«pack.raku plugin new» from>.
The underlying program B«gnome-extensions create» creates the extension in the directory of the live extensions I move it to the specified development area so you don't mess up your development computer while working, I recommend testing on a VM or at least a less important computer. 

B«NB: I use the words "plugin" and "extension" interchangeably.»

=item1 L<(See pack.raku plugin new)|#packraku-plugin-new---help>

L<Table of Contents|#table-of-contents>

=head4 example of using pack.raku plugin new key --all --force

=begin code :lang<bash>

05:03:07 θ71° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions 7s $ pack.raku plugin new fred --all --force
uuid: fred@grizzlysmit.smit.id.au
name: fred? hit enter to accept or type in new value followed by enter.
Please enter a multi line description!
terminate with two empty lines.
1> This is a dummy plugin
2> 
3> It is just a test
4> 
5> 
gettext-domain: fred? hit enter to accept or type in new value followed by enter.
Please enter credits lines!
terminate with two empty lines.
1> Francis Grizzly Smit ©2025
2> Licence GPL v3+
3> 
4> 
gnome-extensions create --uuid=fred@grizzlysmit.smit.id.au --name=fred --description=This is a dummy plugin\n\nIt is just a test --gettext-domain=fred --prefs --interactive --quiet
Choose one of the available templates:
1) Plain       –  An empty extension
2) Indicator   –  Add an icon to the top bar
3) Quick Settings Item  –  Add an item to quick settings
Template [1-3]: 2

The new extension was successfully created in /home/grizzlysmit/.config/gnome-shell/extensions/fred@grizzlysmit.smit.id.au.
copypath Success
key: fred => "/home/grizzlysmit/Projects/gnome-shell/extensions/fred@grizzlysmit.smit.id.au" added successfully
Created po/en.po.
.pack_args.json created
removed directory
05:55:14 θ70° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions 2m14s $ exa -F -laahigHb --colour-scale --time-style=full-iso --icons=always fred@grizzlysmit.smit.id.au/
   inode Permissions Links  Size User        Group       Date Modified                       Name
27559253 drwxrwxr-x      5     - grizzlysmit grizzlysmit 2025-07-24 05:55:14.052449684 +1000  ./
26352037 drwxr-xr-x     34     - grizzlysmit grizzlysmit 2025-07-24 05:55:13.943446718 +1000  ../
27559273 .rw-rw-r--      1   287 grizzlysmit grizzlysmit 2025-07-24 05:55:14.053521905 +1000  .pack_args.json
27559265 .rwxrwxr-x      1   562 grizzlysmit grizzlysmit 2025-07-24 05:55:13.959032921 +1000  compile.sh*
27559254 .rw-rw-r--      1 1.8Ki grizzlysmit grizzlysmit 2025-07-24 05:55:13.945257913 +1000  extension.js
27559270 drwxrwxr-x      3     - grizzlysmit grizzlysmit 2025-07-24 05:55:14.045449493 +1000  locale/
27559256 .rw-rw-r--      1   325 grizzlysmit grizzlysmit 2025-07-24 05:55:13.957659027 +1000  metadata.json
27559264 drwxrwxr-x      2     - grizzlysmit grizzlysmit 2025-07-24 05:55:14.041449384 +1000  po/
27559255 .rw-rw-r--      1 1.4Ki grizzlysmit grizzlysmit 2025-07-24 05:55:13.945612838 +1000  prefs.js
27559258 drwxrwxr-x      2     - grizzlysmit grizzlysmit 2025-07-24 05:55:13.986447888 +1000  schemas/
27559257 .rw-rw-r--      1    45 grizzlysmit grizzlysmit 2025-07-24 05:55:13.946068846 +1000  stylesheet.css
05:56:03 θ65° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions $ exa -F -lahigHTb  --colour-scale --time-style=full-iso fred@grizzlysmit.smit.id.au/
   inode Permissions Links  Size User        Group       Date Modified                       Name
27559253 drwxrwxr-x      5     - grizzlysmit grizzlysmit 2025-07-24 05:55:14.052449684 +1000 fred@grizzlysmit.smit.id.au/
27559273 .rw-rw-r--      1   287 grizzlysmit grizzlysmit 2025-07-24 05:55:14.053521905 +1000 ├── .pack_args.json
27559265 .rwxrwxr-x      1   562 grizzlysmit grizzlysmit 2025-07-24 05:55:13.959032921 +1000 ├── compile.sh*
27559254 .rw-rw-r--      1 1.8Ki grizzlysmit grizzlysmit 2025-07-24 05:55:13.945257913 +1000 ├── extension.js
27559270 drwxrwxr-x      3     - grizzlysmit grizzlysmit 2025-07-24 05:55:14.045449493 +1000 ├── locale/
27559271 drwxrwxr-x      3     - grizzlysmit grizzlysmit 2025-07-24 05:55:14.045449493 +1000 │   └── en/
27559272 drwxrwxr-x      2     - grizzlysmit grizzlysmit 2025-07-24 05:55:14.046449521 +1000 │       └── LC_MESSAGES/
27559269 .rw-rw-r--      1   653 grizzlysmit grizzlysmit 2025-07-24 05:55:14.044584280 +1000 │           └── fred.mo
27559256 .rw-rw-r--      1   325 grizzlysmit grizzlysmit 2025-07-24 05:55:13.957659027 +1000 ├── metadata.json
27559264 drwxrwxr-x      2     - grizzlysmit grizzlysmit 2025-07-24 05:55:14.041449384 +1000 ├── po/
27559268 .rw-rw-r--      1   986 grizzlysmit grizzlysmit 2025-07-24 05:55:14.042015222 +1000 │   ├── en.po
27559267 .rw-rw-r--      1   875 grizzlysmit grizzlysmit 2025-07-24 05:55:13.991375405 +1000 │   └── fred.pot
27559255 .rw-rw-r--      1 1.4Ki grizzlysmit grizzlysmit 2025-07-24 05:55:13.945612838 +1000 ├── prefs.js
27559258 drwxrwxr-x      2     - grizzlysmit grizzlysmit 2025-07-24 05:55:13.986447888 +1000 ├── schemas/
27559266 .rw-rw-r--      1   380 grizzlysmit grizzlysmit 2025-07-24 05:55:13.986447888 +1000 │   ├── gschemas.compiled
27559263 .rw-rw-r--      1   765 grizzlysmit grizzlysmit 2025-07-24 05:55:13.956259755 +1000 │   └── org.gnome.shell.extensions.fred.gschema.xml
27559257 .rw-rw-r--      1    45 grizzlysmit grizzlysmit 2025-07-24 05:55:13.946068846 +1000 └── stylesheet.css
05:56:53 θ65° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions $ batcat fred@grizzlysmit.smit.id.au/metadata.json 
───────┬────────────────────────────────────────────────────────────────────────────────────────────────────────────
       │ File: fred@grizzlysmit.smit.id.au/metadata.json
───────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1   │ {
   2   │     "credits": "Francis Grizzly Smit ©2025\nLicence GPL v3+",
   3   │     "description": "This is a dummy plugin\n\nIt is just a test",
   4   │     "gettext-domain": "fred",
   5   │     "name": "fred",
   6   │     "settings-schema": "org.gnome.shell.extensions.fred",
   7   │     "shell-version": [
   8   │         "48"
   9   │     ],
  10   │     "uuid": "fred@grizzlysmit.smit.id.au"
  11   │ }
───────┴────────────────────────────────────────────────────────────────────────────────────────────────────────────
05:57:32 θ71° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions $ batcat fred@grizzlysmit.smit.id.au/.pack_args.json 
───────┬────────────────────────────────────────────────────────────────────────────────────────────────────────────
       │ File: fred@grizzlysmit.smit.id.au/.pack_args.json
───────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1   │ {
   2   │     "extra-sources": [
   3   │     ],
   4   │     "force": true,
   5   │     "gettext-domain": "fred",
   6   │     "out-dir": "/home/grizzlysmit/Projects/gnome-shell/extensions",
   7   │     "package-dir": "fred@grizzlysmit.smit.id.au",
   8   │     "podir": "po",
   9   │     "schema": "schemas/org.gnome.shell.extensions.fred.gschema.xml"
  10   │ }
───────┴────────────────────────────────────────────────────────────────────────────────────────────────────────────


=end code

L<Table of Contents|#table-of-contents>

=head3 If you want to manage an existing extension then use

=begin code :lang<bash>

pack.raku plugin add <key> <uuid> [<extra-sources1> <extra-sources2> ...] --force --mk-schema

=end code

=item1 L<(See pack.raku plugin add)|#packraku-plugin-add>

L<Table of Contents|#table-of-contents>

=head4 example of using pack.raku plugin add

=begin code :lang<bash>

10:41:54 θ70° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions $ gnome-extensions create --prefs --interactive
Name should be a very short (ideally descriptive) string.
Examples are: “Click To Focus”, “Adblock”, “Shell Window Shrinker”
Name: fred

Description is a single-sentence explanation of what your extension does.
Examples are: “Make windows visible on click”, “Block advertisement popups”, “Animate windows shrinking on minimize”
Description: Dummy plugin

UUID is a globally-unique identifier for your extension.
This should be in the format of an email address (clicktofocus@janedoe.example.com)
UUID: fred@grizzlysmit.smit.id.au

Choose one of the available templates:
1) Plain       –  An empty extension
2) Indicator   –  Add an icon to the top bar
3) Quick Settings Item  –  Add an item to quick settings
Template [1-3]: 2

The new extension was successfully created in /home/grizzlysmit/.config/gnome-shell/extensions/fred@grizzlysmit.smit.id.au.
10:43:23 θ72° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions 1m8s $ mv /home/grizzlysmit/.config/gnome-shell/extensions/fred@grizzlysmit.smit.id.au/ .
renamed '/home/grizzlysmit/.config/gnome-shell/extensions/fred@grizzlysmit.smit.id.au/' -> './fred@grizzlysmit.smit.id.au'
10:43:49 θ69° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions $ tb fred@grizzlysmit.smit.id.au/
   inode Permissions Links  Size User        Group       Date Modified                       Name
53501399 drwxrwxr-x      2     - grizzlysmit grizzlysmit 2025-07-24 10:43:23.448872836 +1000 fred@grizzlysmit.smit.id.au/
53501572 .rw-rw-r--      1 1.8Ki grizzlysmit grizzlysmit 2025-07-24 10:43:23.448872836 +1000 ├── extension.js
53501494 .rw-rw-r--      1   130 grizzlysmit grizzlysmit 2025-07-24 10:43:23.448872836 +1000 ├── metadata.json
53501574 .rw-rw-r--      1 1.4Ki grizzlysmit grizzlysmit 2025-07-24 10:43:23.448872836 +1000 ├── prefs.js
53501573 .rw-rw-r--      1    45 grizzlysmit grizzlysmit 2025-07-24 10:43:23.448872836 +1000 └── stylesheet.css

10:44:07 θ66° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions 127 $ type tb
tb is aliased to `exa -F -lahigHTb  --colour-scale --time-style=full-iso'

10:44:14 θ71° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions $ batcat fred@grizzlysmit.smit.id.au/metadata.json 
───────┬───────────────────────────────────────────────────────────────────────────
       │ File: fred@grizzlysmit.smit.id.au/metadata.json
───────┼───────────────────────────────────────────────────────────────────────────
   1   │ {
   2   │   "name": "fred",
   3   │   "description": "Dummy plugin",
   4   │   "uuid": "fred@grizzlysmit.smit.id.au",
   5   │   "shell-version": [
   6   │     "48"
   7   │   ]
   8   │ }
───────┴───────────────────────────────────────────────────────────────────────────
10:44:37 θ68° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions $ pack.raku plugin add fred fred@grizzlysmit.smit.id.au  --force --mk-schema --mk-podir
gettext-domain: fred? hit enter to accept or type in new value followed by enter.
Created po/en.po.
key: fred => "/home/grizzlysmit/Projects/gnome-shell/extensions/fred@grizzlysmit.smit.id.au" added successfully
.pack_args.json created
10:45:50 θ64° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions 13s $ pack.raku alias get-gettext-domain fred
fred
10:46:13 θ77° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions 3s $ # it worked
10:46:26 θ71° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions $ tb fred@grizzlysmit.smit.id.au/
   inode Permissions Links  Size User        Group       Date Modified                       Name
53501399 drwxrwxr-x      5     - grizzlysmit grizzlysmit 2025-07-24 10:45:50.817144241 +1000 fred@grizzlysmit.smit.id.au/
53501634 .rw-rw-r--      1   287 grizzlysmit grizzlysmit 2025-07-24 10:45:50.817730377 +1000 ├── .pack_args.json
53501578 .rwxrwxr-x      1   562 grizzlysmit grizzlysmit 2025-07-24 10:45:50.709030905 +1000 ├── compile.sh*
53501572 .rw-rw-r--      1 1.8Ki grizzlysmit grizzlysmit 2025-07-24 10:43:23.448872836 +1000 ├── extension.js
53501584 drwxrwxr-x      3     - grizzlysmit grizzlysmit 2025-07-24 10:45:50.798143691 +1000 ├── locale/
53501616 drwxrwxr-x      3     - grizzlysmit grizzlysmit 2025-07-24 10:45:50.798143691 +1000 │   └── en/
53501633 drwxrwxr-x      2     - grizzlysmit grizzlysmit 2025-07-24 10:45:50.800143748 +1000 │       └── LC_MESSAGES/
53501582 .rw-rw-r--      1   653 grizzlysmit grizzlysmit 2025-07-24 10:45:50.797109428 +1000 │           └── fred.mo
53501494 .rw-rw-r--      1   231 grizzlysmit grizzlysmit 2025-07-24 10:45:50.706926618 +1000 ├── metadata.json
53501577 drwxrwxr-x      2     - grizzlysmit grizzlysmit 2025-07-24 10:45:50.793143546 +1000 ├── po/
53501581 .rw-rw-r--      1   986 grizzlysmit grizzlysmit 2025-07-24 10:45:50.794635436 +1000 │   ├── en.po
53501580 .rw-rw-r--      1   875 grizzlysmit grizzlysmit 2025-07-24 10:45:50.743762978 +1000 │   └── fred.pot
53501574 .rw-rw-r--      1 1.4Ki grizzlysmit grizzlysmit 2025-07-24 10:43:23.448872836 +1000 ├── prefs.js
53501575 drwxrwxr-x      2     - grizzlysmit grizzlysmit 2025-07-24 10:45:50.739141981 +1000 ├── schemas/
53501579 .rw-rw-r--      1   380 grizzlysmit grizzlysmit 2025-07-24 10:45:50.739141981 +1000 │   ├── gschemas.compiled
53501576 .rw-rw-r--      1   765 grizzlysmit grizzlysmit 2025-07-24 10:45:50.705111892 +1000 │   └── org.gnome.shell.extensions.fred.gschema.xml
53501573 .rw-rw-r--      1    45 grizzlysmit grizzlysmit 2025-07-24 10:43:23.448872836 +1000 └── stylesheet.css
10:46:38 θ64° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions $ batcat fred@grizzlysmit.smit.id.au/metadata.json 
───────┬───────────────────────────────────────────────────────────────────────────
       │ File: fred@grizzlysmit.smit.id.au/metadata.json
───────┼───────────────────────────────────────────────────────────────────────────
   1   │ {
   2   │     "description": "Dummy plugin",
   3   │     "gettext-domain": "fred",
   4   │     "name": "fred",
   5   │     "settings-schema": "org.gnome.shell.extensions.fred",
   6   │     "shell-version": [
   7   │         "48"
   8   │     ],
   9   │     "uuid": "fred@grizzlysmit.smit.id.au"
  10   │ }
───────┴───────────────────────────────────────────────────────────────────────────
10:47:13 θ76° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions $ batcat fred@grizzlysmit.smit.id.au/.pack_args.json 
───────┬───────────────────────────────────────────────────────────────────────────
       │ File: fred@grizzlysmit.smit.id.au/.pack_args.json
───────┼───────────────────────────────────────────────────────────────────────────
   1   │ {
   2   │     "extra-sources": [
   3   │     ],
   4   │     "force": true,
   5   │     "gettext-domain": "fred",
   6   │     "out-dir": "/home/grizzlysmit/Projects/gnome-shell/extensions",
   7   │     "package-dir": "fred@grizzlysmit.smit.id.au",
   8   │     "podir": "po",
   9   │     "schema": "schemas/org.gnome.shell.extensions.fred.gschema.xml"
  10   │ }
───────┴───────────────────────────────────────────────────────────────────────────


=end code

L<Table of Contents|#table-of-contents>

=head3 To package a extension just call 

=begin code :lang<bash>

pack.raku alias do <key> --force

=end code

=head4 Or to package many this

=begin code :lang<bash>

pack.raku alias do <key0> <key1> <key2> ... <keyn> --force

=end code

=item1 L«See pack.raku alias do --help|#packraku-alias-do---help».

L<Table of Contents|#table-of-contents>

=head4 example of creating packages 

=begin code :lang<bash>

15:44:31 θ71° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions $ eb
   inode Permissions Links  Size User        Group       Date Modified                       Name
26352037 drwxr-xr-x     34     - grizzlysmit grizzlysmit 2025-07-24 15:44:31.840926805 +1000  ./
26217632 drwxr-xr-x      3     - grizzlysmit grizzlysmit 2018-03-06 18:20:02.734959839 +1000  ../
26349968 .rw-rw-r--      1  21Ki grizzlysmit grizzlysmit 2024-05-03 11:27:55.484319299 +1000  .shell-extension.zip
26353752 .rw-rw-r--      1  24Ki grizzlysmit grizzlysmit 2021-11-25 19:26:19.479090060 +1000  alternate-hplips-menu.zip
26352042 drwxrwxr-x      4     - grizzlysmit grizzlysmit 2024-05-26 03:32:33.908540232 +1000  apps-menu@gnome-shell-extensions.gcampax.github.com/
26353753 .rw-rw-r--      1  17Ki grizzlysmit grizzlysmit 2021-12-28 04:37:44.146266285 +1000  big-avatar@gustavoperedo.org.shell-extension.zip
26352038 drwxrwxr-x      4     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  Bottom_Panel@rmy.pobox.com/
26512363 drwxrwxr-x      8     - grizzlysmit grizzlysmit 2025-07-23 14:38:59.863644931 +1000  files-launcher@grizzlysmit.smit.id.au/
26349973 .rw-rw-r--      1  54Ki grizzlysmit grizzlysmit 2025-07-24 15:44:00.465134918 +1000  files-launcher@grizzlysmit.smit.id.au.shell-extension.zip
27559274 drwxrwxr-x      5     - grizzlysmit grizzlysmit 2025-07-24 15:42:56.782255700 +1000  fred@grizzlysmit.smit.id.au/
26352043 drwxrwxr-x      7     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  gnome-shell-extension-taskbar/
26352044 drwxrwxr-x      6     - grizzlysmit grizzlysmit 2022-01-07 09:09:40.302644534 +1000  gnome-shell-extensions-gravatar/
26352045 drwxr-xr-x      3     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  gnome-shell-tw/
26353754 .rw-rw-r--      1 6.6Ki grizzlysmit grizzlysmit 2022-01-06 23:56:20.182307575 +1000  gravatar@gnome-shell-extensions.rouleau.io.shell-extension.zip
26352046 drwxrwxr-x      2     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  gravatar@grizzlysmit.id.au/
26353755 .rw-rw-r--      1 1.8Ki grizzlysmit grizzlysmit 2022-07-01 10:34:55.758925396 +1000  gravatar@grizzlysmit.id.au.shell-extension.zip
26352048 drwxrwxr-x      3     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  gravatar@jr.rlabs.io/
26353756 .rw-rw-r--      1 6.6Ki grizzlysmit grizzlysmit 2022-01-07 19:47:05.364419415 +1000  gravatar@jr.rlabs.io.shell-extension.zip
26352049 drwxrwxr-x      8     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  gsconnect@andyholmes.github.io/
26352051 drwxrwxr-x      8     - grizzlysmit grizzlysmit 2025-07-23 14:31:22.859671275 +1000  hplip-menu2@grizzlysmit.smit.id.au/
26346496 .rw-rw-r--      1  28Ki grizzlysmit grizzlysmit 2025-07-02 20:36:31.684875818 +1000  hplip-menu2@grizzlysmit.smit.id.au.shell-extension.zip
26352054 drwxrwxr-x      5     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  messagingmenu@lauinger-clan.de/
26352056 drwxrwxr-x      4     - grizzlysmit grizzlysmit 2020-11-07 22:39:21.087614053 +1000  multi-monitors-add-on/
46561771 drwxrwxr-x      7     - grizzlysmit grizzlysmit 2025-07-23 14:26:07.832210160 +1000  notes-with-history@grizzlysmit.smit.id.au/
26349665 .rw-rw-r--      1  53Ki grizzlysmit grizzlysmit 2025-07-24 15:44:00.409133267 +1000  notes-with-history@grizzlysmit.smit.id.au.shell-extension.zip
51393341 drwxrwxr-x      4     - grizzlysmit grizzlysmit 2025-03-15 16:42:15.414543423 +1000  old/
26352059 drwxrwxr-x      2     - grizzlysmit grizzlysmit 2024-04-29 17:31:02.281104910 +1000  openweather/
26352057 drwxrwxr-x      4     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  openweather-extension@jenslody.de/
26352060 drwxrwxr-x      9     - grizzlysmit grizzlysmit 2025-07-24 15:33:13.862750943 +1000  pack/
26352062 drwxrwxr-x      4     - grizzlysmit grizzlysmit 2022-01-05 22:49:47.185676938 +1000  pixel-saver/
26352064 drwxrwxr-x      2     - grizzlysmit grizzlysmit 2024-07-27 18:54:47.363559805 +1000  popupMenu/
26352065 drwxrwxr-x      4     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  quick-settings-avatar@d-go/
26352039 drwxrwxr-x      4     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  SettingsCenter@lauinger-clan.de/
26352067 drwxrwxr-x      3     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  ssh-connect-menu@edavidf/
26352040 drwxrwxr-x      5     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  SystemMenu@jonnius.github.com/
26352068 drwxrwxr-x      3     - grizzlysmit grizzlysmit 2024-05-06 16:52:51.078240764 +1000  tabstesting/
26352070 drwxr-xr-x      3     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  taskbar@grizzlysmit.smit.id.au/
26352041 drwxrwxr-x      6     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  TaskBar@zpydr/
26352071 drwxr-xr-x      2     - grizzlysmit grizzlysmit 2018-03-06 18:20:02.794960310 +1000  testing/
26352073 drwxrwxr-x      2     - grizzlysmit grizzlysmit 2023-09-27 15:27:06.024458938 +1000  tmp/
26352074 drwxrwxr-x      6     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  unite@hardpixel.eu/
26352075 drwxrwxr-x      4     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  weeks-start-on-monday@extensions.gnome-shell.fifi.org/
26352076 drwxrwxr-x      2     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  workspace-switch-wraparound@theychx.org/
15:44:36 θ67° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions $ type eb
eb is a function
eb () 
{ 
    if type exa >> /dev/null 2>&1; then
        exa -F -laahigHb --colour-scale --time-style=full-iso --icons=always "$@";
    else
        ls --color=auto -Flaghi --color "$@";
    fi
}
15:44:55 θ72° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions $ pack.raku list all
                                                                                                                           
key   sep path                                                                        # comment                            
===========================================================================================================================
files  => ~/Projects/gnome-shell/extensions/files-launcher@grizzlysmit.smit.id.au     #                                    
fred   => ~/Projects/gnome-shell/extensions/fred@grizzlysmit.smit.id.au               # Testing\n\nthis is a Dummy plugin  
hp     => ~/Projects/gnome-shell/extensions/hplip-menu2@grizzlysmit.smit.id.au        # The hplip-menu2 plugin    #        
notes  => ~/Projects/gnome-shell/extensions/notes-with-history@grizzlysmit.smit.id.au # notes-with-history plugin #        
===========================================================================================================================
15:45:56 θ74° grizzlysmit@pern.local:~/Projects/gnome-shell/extensions 3s $ pack.raku alias do fred notes files hp --force
gnome-extensions pack --schema=schemas/org.gnome.shell.extensions.fred.gschema.xml --podir=po --gettext-domain=fred --force --out-dir=/home/grizzlysmit/Projects/gnome-shell/extensions /home/grizzlysmit/Projects/gnome-shell/extensions/fred@grizzlysmit.smit.id.au

gnome-extensions pack --extra-source=gzz.js --extra-source=select.js --extra-source=button.js --extra-source=log_message.js --extra-source=icon_constants.js --schema=schemas/org.gnome.shell.extensions.notes-with-history.gschema.xml --podir=po --gettext-domain=notes-with-history --force --out-dir=/home/grizzlysmit/Projects/gnome-shell/extensions /home/grizzlysmit/Projects/gnome-shell/extensions/notes-with-history@grizzlysmit.smit.id.au

gnome-extensions pack --extra-source=button.js --extra-source=gzz.js --extra-source=icon_constants.js --extra-source=log_message.js --extra-source=select.js --schema=schemas/org.gnome.shell.extensions.files-launcher.gschema.xml --podir=po --gettext-domain=files-launcher --force --out-dir=/home/grizzlysmit/Projects/gnome-shell/extensions /home/grizzlysmit/Projects/gnome-shell/extensions/files-launcher@grizzlysmit.smit.id.au

gnome-extensions pack --extra-source=gzzDialog.js --extra-source=CompactMenu.js --extra-source=log_message.js --schema=schemas/org.gnome.shell.extensions.hplip-menu2.gschema.xml --podir=po --gettext-domain=hplip-menu2 --force --out-dir=/home/grizzlysmit/Projects/gnome-shell/extensions /home/grizzlysmit/Projects/gnome-shell/extensions/hplip-menu2@grizzlysmit.smit.id.au

exa -F -laahigHb --colour-scale --time-style=full-iso --icons=always
   inode Permissions Links  Size User        Group       Date Modified                       Name
26352037 drwxr-xr-x     34     - grizzlysmit grizzlysmit 2025-07-24 15:46:39.996826303 +1000  ./
26217632 drwxr-xr-x      3     - grizzlysmit grizzlysmit 2018-03-06 18:20:02.734959839 +1000  ../
26349968 .rw-rw-r--      1  21Ki grizzlysmit grizzlysmit 2024-05-03 11:27:55.484319299 +1000  .shell-extension.zip
26353752 .rw-rw-r--      1  24Ki grizzlysmit grizzlysmit 2021-11-25 19:26:19.479090060 +1000  alternate-hplips-menu.zip
26352042 drwxrwxr-x      4     - grizzlysmit grizzlysmit 2024-05-26 03:32:33.908540232 +1000  apps-menu@gnome-shell-extensions.gcampax.github.com/
26353753 .rw-rw-r--      1  17Ki grizzlysmit grizzlysmit 2021-12-28 04:37:44.146266285 +1000  big-avatar@gustavoperedo.org.shell-extension.zip
26352038 drwxrwxr-x      4     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  Bottom_Panel@rmy.pobox.com/
26512363 drwxrwxr-x      8     - grizzlysmit grizzlysmit 2025-07-23 14:38:59.863644931 +1000  files-launcher@grizzlysmit.smit.id.au/
26349973 .rw-rw-r--      1  54Ki grizzlysmit grizzlysmit 2025-07-24 15:46:39.949824924 +1000  files-launcher@grizzlysmit.smit.id.au.shell-extension.zip
27559274 drwxrwxr-x      5     - grizzlysmit grizzlysmit 2025-07-24 15:42:56.782255700 +1000  fred@grizzlysmit.smit.id.au/
26387376 .rw-rw-r--      1 4.2Ki grizzlysmit grizzlysmit 2025-07-24 15:46:39.839821696 +1000  fred@grizzlysmit.smit.id.au.shell-extension.zip
26352043 drwxrwxr-x      7     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  gnome-shell-extension-taskbar/
26352044 drwxrwxr-x      6     - grizzlysmit grizzlysmit 2022-01-07 09:09:40.302644534 +1000  gnome-shell-extensions-gravatar/
26352045 drwxr-xr-x      3     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  gnome-shell-tw/
26353754 .rw-rw-r--      1 6.6Ki grizzlysmit grizzlysmit 2022-01-06 23:56:20.182307575 +1000  gravatar@gnome-shell-extensions.rouleau.io.shell-extension.zip
26352046 drwxrwxr-x      2     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  gravatar@grizzlysmit.id.au/
26353755 .rw-rw-r--      1 1.8Ki grizzlysmit grizzlysmit 2022-07-01 10:34:55.758925396 +1000  gravatar@grizzlysmit.id.au.shell-extension.zip
26352048 drwxrwxr-x      3     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  gravatar@jr.rlabs.io/
26353756 .rw-rw-r--      1 6.6Ki grizzlysmit grizzlysmit 2022-01-07 19:47:05.364419415 +1000  gravatar@jr.rlabs.io.shell-extension.zip
26352049 drwxrwxr-x      8     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  gsconnect@andyholmes.github.io/
26352051 drwxrwxr-x      8     - grizzlysmit grizzlysmit 2025-07-23 14:31:22.859671275 +1000  hplip-menu2@grizzlysmit.smit.id.au/
26346496 .rw-rw-r--      1  28Ki grizzlysmit grizzlysmit 2025-07-24 15:46:40.012826773 +1000  hplip-menu2@grizzlysmit.smit.id.au.shell-extension.zip
26352054 drwxrwxr-x      5     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  messagingmenu@lauinger-clan.de/
26352056 drwxrwxr-x      4     - grizzlysmit grizzlysmit 2020-11-07 22:39:21.087614053 +1000  multi-monitors-add-on/
46561771 drwxrwxr-x      7     - grizzlysmit grizzlysmit 2025-07-23 14:26:07.832210160 +1000  notes-with-history@grizzlysmit.smit.id.au/
26349665 .rw-rw-r--      1  53Ki grizzlysmit grizzlysmit 2025-07-24 15:46:39.894823310 +1000  notes-with-history@grizzlysmit.smit.id.au.shell-extension.zip
51393341 drwxrwxr-x      4     - grizzlysmit grizzlysmit 2025-03-15 16:42:15.414543423 +1000  old/
26352059 drwxrwxr-x      2     - grizzlysmit grizzlysmit 2024-04-29 17:31:02.281104910 +1000  openweather/
26352057 drwxrwxr-x      4     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  openweather-extension@jenslody.de/
26352060 drwxrwxr-x      9     - grizzlysmit grizzlysmit 2025-07-24 15:33:13.862750943 +1000  pack/
26352062 drwxrwxr-x      4     - grizzlysmit grizzlysmit 2022-01-05 22:49:47.185676938 +1000  pixel-saver/
26352064 drwxrwxr-x      2     - grizzlysmit grizzlysmit 2024-07-27 18:54:47.363559805 +1000  popupMenu/
26352065 drwxrwxr-x      4     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  quick-settings-avatar@d-go/
26352039 drwxrwxr-x      4     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  SettingsCenter@lauinger-clan.de/
26352067 drwxrwxr-x      3     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  ssh-connect-menu@edavidf/
26352040 drwxrwxr-x      5     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  SystemMenu@jonnius.github.com/
26352068 drwxrwxr-x      3     - grizzlysmit grizzlysmit 2024-05-06 16:52:51.078240764 +1000  tabstesting/
26352070 drwxr-xr-x      3     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  taskbar@grizzlysmit.smit.id.au/
26352041 drwxrwxr-x      6     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  TaskBar@zpydr/
26352071 drwxr-xr-x      2     - grizzlysmit grizzlysmit 2018-03-06 18:20:02.794960310 +1000  testing/
26352073 drwxrwxr-x      2     - grizzlysmit grizzlysmit 2023-09-27 15:27:06.024458938 +1000  tmp/
26352074 drwxrwxr-x      6     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  unite@hardpixel.eu/
26352075 drwxrwxr-x      4     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  weeks-start-on-monday@extensions.gnome-shell.fifi.org/
26352076 drwxrwxr-x      2     - grizzlysmit grizzlysmit 2024-05-12 07:02:26.268351182 +1000  workspace-switch-wraparound@theychx.org/

=end code

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
  pack.raku plugin new <key>   [--uuid=<Str>] [--name=<Str>] [--description=<Str>] [--gettext-domain=<Str>] [--settings-schema=<Str>] [--template=<Str>] [--credits=<Str>] [--prefs] [--schema-file] [--podirs] [--add-credits] [-a|--all-parmas|--all] [-f|--force] [-s|--silent] [-b|--backtrace] [-l|--dev-lang=<Str>] [-o|--output|--development-dir|--dev-dir=<Str>]  
  pack.raku plugin add <key> <uuid>  [<extra-sources> ...] [-p|--extension-dir=<Str>] [--podir=<Str>] [-f|--force] [-s|--silent] [-b|--backtrace] [-m|--mk-schema] [-l|--dev-lang=<Str>]
  pack.raku alias add-extra-sources <key>  [<extra-sources> ...]
  pack.raku alias set-schema <key> <schema-value>
  pack.raku alias set-podir <key> <podir-value>
  pack.raku alias set-gettext-domain <key> <gettext-domain-value>
  pack.raku alias set-out-dir <key> <out-dir-value>
  pack.raku alias set-force <key> <force-value>
  pack.raku alias set-package-dir <key> <package-dir-value>
  pack.raku alias set-extra-sources <key>  [<extra-sources> ...]
  pack.raku alias append-extra-sources <key>  [<extra-sources> ...]
  pack.raku alias remove-schema <key>
  pack.raku alias remove-podir <key>
  pack.raku alias remove-gettext-domain <key>
  pack.raku alias remove-out-dir <key>
  pack.raku alias remove-extra-sources <key>
  pack.raku alias get-schema <key>
  pack.raku alias get-podir <key>
  pack.raku alias get-gettext-domain <key>
  pack.raku alias get-out-dir <key>
  pack.raku alias get-extra-sources <key>
  pack.raku alias get-force <key>
  pack.raku alias get-package-dir <key>
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
=item2 assumes that the directory contains a C<.pack_args.json> file which contains all the arguments for B<gnome-extensions pack>.
=item1 C«[keys ...]»  a list of additional keys pointing to directories in the directory database containing B<gnome-shell> plugins same as key.
=item1 C«[-f|--force]»   overrides the force parameter in every C<.pack_args.json>.
=item1 C«[-c|--command=<Str>]»  overrides the command to list the current directory it is assumed this is the same as the output directory for all the plugins.
=item2 the default is B<ls -Flaghi --color=always> this can be overridden by the value of the B<LS_CMD> environment variable but the command-line value overrides both.
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
  pack.raku plugin new <key>  [--uuid=<Str>] [--name=<Str>] [--description=<Str>] [--gettext-domain=<Str>] [--settings-schema=<Str>] [--template=<Str>] [--credits=<Str>] [--prefs] [--schema-file] [--podirs] [--add-credits] [-a|--all-parmas|--all] [-f|--force] [-s|--silent] [-b|--backtrace] [-l|--dev-lang=<Str>] [-o|--output|--development-dir|--dev-dir=<Str>]

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
=item1 C«[--credits=<Str>]»          Set the credits lines If not set and C«--add-credits» or C«--all» is present then will be prompted for.
=item2                               B«The following parameters will not be prompted for.»
=item1 C«[--prefs]»                  Include prefs.js template.
=item1 C«[--schema-file]»            Add a schema file by name of C«schemas/org.gnome.shell.extensions.{$gettext-domain}.gschema.xml».
=item1 C«[--podirs]»                 Add a po directory with gettext files preloaded; plus a C«compile.sh» script to build and update the gettext files.
=item1 C«[--add-credits]»            Prompt for credits lines if C«--credits» not set.
=item1 C«[-a|--all-parmas|--all]»    Same as C«--podirs --schema-file --podirs --add-credits».
=item1 C«[-f|--force]»               Add the force parameter to the C«.pack_args.json» file.
=item1 C«[-s|--silent]»              Don't print out the steps taken defaults to C«False».
=item1 C«[-l|--dev-lang=<Str>]»      The language of the default C«*.po» file to generate this should be the language the strings are in in the original source defaults to B«en».
=item1 C«[-o|--output|--development-dir|--dev-dir=<Str>]»  The directory to develop the plugin from; defaults to the current dir.

L<Table of Contents|#table-of-contents>

=head2 Recommended Usage

It is recommended that you use the following command line to get pretty much everything in you could desire in the starting point of your plugin/extension.

=begin code :lang<bash>

pack.raku plugin new <key> --all --force

=end code

=item1 B«NB:»
=item2 The key C«<key>» must be replaced with a real key.

This whole development model assumes that you don't want to develop the plugin/extension live as is C«gnome-extensions create» model so I copy the plugin out line generated by C«gnome-extensions create» to another location I use C«~/Projects/gnome-shell/extensions/» and deleting the original that C«gnome-extensions create» generates.  

L<Table of Contents|#table-of-contents>

=end pod

multi sub MAIN('plugin', 'new', Str:D $key, Str :$uuid = Str, Str :$name = Str, Str :$description = Str,
                Str :$gettext-domain = Str, Str :$settings-schema = Str, Str :$template = Str, Str :$credits = Str,
                Bool:D :$prefs = False, Bool:D :$schema-file = False, Bool:D :$podirs = False,
                Bool:D :$add-credits = False, Bool:D :a(:all-parmas(:$all)) = False, 
                Bool:D :f(:$force) = False, Bool:D :s(:$silent) = False, Bool:D :b(:$backtrace) = False,
                Str:D :l(:$dev-lang) = ((%*ENV«DEV_LANG»:exists) ?? (~%*ENV«DEV_LANG») !! 'en'), 
                Str:D :o(:output(:development-dir(:$dev-dir))) = '.' --> int) {
    my Str:D $home = ~%*ENV«HOME»;
    my Str:D $xdg_config_home = (%*ENV«XDG_CONFIG_HOME»:exists ?? ~%*ENV«XDG_CONFIG_HOME» !! "$home/.local/share" );
    unless new-plugin($key, $uuid, $name, $description, $gettext-domain, $settings-schema, $template,
                      $credits, $prefs, $schema-file, $podirs, $force, $home, $xdg_config_home, $silent,
                      $backtrace, $dev-lang, ($dev-dir.IO.resolve.absolute.Str), $add-credits, $all) {
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
                Bool:D :b(:$backtrace) = False, Bool:D :m(:$mk-schema) = False, Bool:D :$mk-podir = False,
                Str:D :l(:$dev-lang) = ((%*ENV«DEV_LANG»:exists) ?? (~%*ENV«DEV_LANG») !! 'en'), 
                *@extra-sources --> int) {
    my Str:D $home = ~%*ENV«HOME»;
    my Str:D $xdg_config_home = (%*ENV«XDG_CONFIG_HOME»:exists ?? ~%*ENV«XDG_CONFIG_HOME» !! "$home/.local/share" );
    unless add-plugin($key, ($plugin-dir.IO.resolve.absolute.Str), $uuid, $podir, $force, $home, $xdg_config_home,
                $silent, $backtrace, $dev-lang, $mk-schema, $mk-podir, @extra-sources) {
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
