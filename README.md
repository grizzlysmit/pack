App::pack
=========

app pack.raku
=============

Table of Contents
-----------------

  * [NAME](#name)

  * [AUTHOR](#author)

  * [VERSION](#version)

  * [TITLE](#title)

  * [SUBTITLE](#subtitle)

  * [COPYRIGHT](#copyright)

  * [Introduction](#introduction)

    * [Motivation](#motivation)

      * [A brief tutorial.](#a-brief-tutorial)

      * [To create a new plugin just call](#to-create-a-new-plugin-just-call)

      * [If you want to manage an existing extension then use](#if-you-want-to-manage-an-existing-extension-then-use)

      * [To package a extension just call](#to-package-a-extension-just-call)

  * [Pack](#pack)

    * [key => directory methods](#key--directory-methods)

    * [key => directory management methods](#key--directory-management-methods)

    * [Editor functions/methods](#editor-functionsmethods)

    * [USAGE stuff](#usage-stuff)

  * [pack.raku --help](#pack)

  * [pack.raku do --help](#packraku-do---help)

  * [pack.raku create --help](#packraku-create---help)

  * [pack.raku add](#packraku-add)

  * [pack.raku set schema](#packraku-set-schema)

  * [pack.raku set podir](#packraku-set-podir)

  * [pack.raku set gettext-domain](#packraku-set-gettext-domain)

  * [pack.raku set out-dir](#packraku-set-out-dir)

  * [pack.raku set force](#packraku-set-force)

  * [pack.raku add-extra-sources](#packraku-add-extra-sources)

  * [pack.raku set package-dir](#packraku-set-package-dir)

  * [pack.raku set extra-sources](#packraku-set-extra-sources)

  * [pack.raku append extra-sources](#packraku-append-extra-sources)

  * [pack.raku remove schema](#packraku-remove-schema)

  * [pack.raku remove podir](#packraku-remove-podir)

  * [pack.raku remove gettext-domain](#packraku-remove-gettext-domain)

  * [pack.raku remove out-dir](#packraku-remove-out-dir)

  * [pack.raku remove extra-sources](#packraku-remove-extra-sources)

  * [pack.raku get schema](#packraku-get-schema)

  * [pack.raku get podir](#packraku-get-podir)

  * [pack.raku get gettext-domain](#packraku-get-gettext-domain)

  * [pack.raku get out-dir](#packraku-get-out-dir)

  * [pack.raku get extra-sources](#packraku-get-extra-sources)

  * [pack.raku get force](#packraku-get-force)

  * [pack.raku get package-dir](#packraku-get-package-dir)

  * [Top of Table of Contents](#table-of-contents)

key => directory methods
========================

  * [pack.raku alias add](#packraku-alias-add)

  * [pack.raku alias do --help](#packraku-alias-do---help)

  * [pack.raku plugin new --help](#packraku-plugin-new---help)

    * [Recommended Usage](#recommended-usage)

  * [pack.raku plugin add](#packraku-plugin-add)

  * [pack.raku alias add-extra-sources](#packraku-alias-add-extra-sources)

  * [pack.raku alias set-schema](#packraku-alias-set-schema)

  * [pack.raku alias set-podir](#packraku-alias-set-podir)

  * [pack.raku alias set-gettext-domain](#packraku-alias-set-gettext-domain)

  * [pack.raku alias set-out-dir](#packraku-alias-set-out-dir)

  * [pack.raku alias set-force](#packraku-alias-set-force)

  * [pack.raku alias set-package-dir](#packraku-alias-set-package-dir)

  * [pack.raku alias set-extra-sources](#packraku-alias-set-extra-sources)

  * [pack.raku alias append-extra-sources](#packraku-alias-append-extra-sources)

  * [pack.raku alias remove-schema](#packraku-alias-remove-schema)

  * [pack.raku alias remove-podir](#packraku-alias-remove-podir)

  * [pack.raku alias remove-gettext-domain](#packraku-alias-remove-gettext-domain)

  * [pack.raku alias remove-out-dir](#packraku-alias-remove-out-dir)

  * [pack.raku alias remove-extra-sources](#packraku-alias-remove-extra-sources)

  * [pack.raku alias get-schema](#packraku-alias-get-schema)

  * [pack.raku alias get-podir](#packraku-alias-get-podir)

  * [pack.raku alias get-gettext-domain](#packraku-alias-get-gettext-domain)

  * [pack.raku alias get-out-dir](#packraku-alias-get-out-dir)

  * [pack.raku alias get-extra-sources](#packraku-alias-get-extra-sources)

  * [pack.raku alias get-force](#packraku-alias-get-force)

  * [pack.raku alias get-package-dir](#packraku-alias-get-package-dir)

  * [Top of Table of Contents](#table-of-contents)

key => directory management methods
-----------------------------------

  * [pack.raku edit configs](#packraku-edit-configs)

  * [pack.raku list keys](#packraku-list-keys)

  * [pack.raku list all](#packraku-list-all)

  * [pack.raku delete](#packraku-delete)

  * [pack.raku del](#packraku-del)

  * [pack.raku trash](#packraku-trash)

  * [pack.raku tidy file](#packraku-tidy-file)

  * [pack.raku comment](#packraku-comment)

  * [pack.raku list trash](#packraku-list-trash)

  * [pack.raku empty trash](#packraku-empty-trash)

  * [pack.raku undelete](#packraku-undelete)

  * [pack.raku show stats](#packraku-show-stats)

  * [pack.raku show statistics](#packraku-show-statistics)

  * [pack.raku backup db](#packraku-backup-db)

  * [pack.raku restore db](#packraku-restore-db)

  * [pack.raku menu restore db](#packraku-menu-restore-db)

  * [pack.raku list db backups](#packraku-list-db-backups)

  * [Top of Table of Contents](#table-of-contents)

Editor functions/methods
========================

  * [pack.raku list editors](#packraku-list-editors)

  * [pack.raku editors stats](#packraku-editors-stats)

  * [pack.raku list editors backups](#packraku-list-editors-backups)

  * [pack.raku backup editors](#packraku-backup-editors)

  * [pack.raku restore editors](#packraku-restore-editors)

  * [pack.raku set editor](#packraku-set-editor)

  * [pack.raku set override GUI_EDITOR](#packraku-set-override-GUI_EDITOR)

  * [pack.raku menu restore editors](#packraku-menu-restore-editors)

  * [Top of Table of Contents](#table-of-contents)

USAGE stuff
===========

  * [pack.raku USAGE](#packraku-USAGE)

  * [multi sub GENERATE-USAGE](#multi-sub-GENERATE-USAGE)

  * [Top of Table of Contents](#table-of-contents)

NAME
====

App::pack 

AUTHOR
======

Francis Grizzly Smit (grizzly@smit.id.au)

VERSION
=======

v0.1.42

TITLE
=====

pack

SUBTITLE
========

A Raku program to manage the use of **gnome-extensions pack**, it has too many arguments this makes it easy.

COPYRIGHT
=========

GPL V3.0+ [LICENSE](https://github.com/grizzlysmit/Usage-Utils/blob/main/LICENSE)

[Top of Top of Document](#table-of-contents)

Introduction
============

This is a Raku program to manage the use of **gnome-extensions**, originally **gnome-extensions pack**, it has too many arguments this makes it easy, as it puts all the arguments in a configuration file. 

Motivation
----------

The original motivation was that the command **gnome-extensions pack** has too many arguments this takes care of that making it easier to package up your gnome-shell extensions; at the expense of setting up a configuration file once, and there are methods for that. 

Now in addition I wrap **gnome-extensions create** as well, plus I create extra stuff like the schema file, the credits field in the `metadata.json` file; it also creates the po dir and creates **compile.sh** to populate it with the gettext stuff, and to process the schema file into it's binary form.

A brief tutorial.
-----------------

### To create a new plugin just call 

```bash
pack.raku plugin new <key> --all --force
```

You can alternately use `--prefs --schema-file --podirs --add-credits` leave out the `--prefs` out if you don't need settings (i.e. a prefs.js file), you can leave out `--schema-file` if you do not need a schema file, you can leave `--podirs` if you don't want internationalisation, you can leave of `--add-credits` if you don't want to add credits and you can leave off `--force` if you don't want the force parameter when packaging the extension.

The program will prompt for all the parameters it requires once run it will have created a basic extension and moved it into a development location; **by default the current directory from which you ran `pack.raku plugin new` from**. The underlying program **gnome-extensions create** creates the extension in the directory of the live extensions I move it to the specified development area so you don't mess up your development computer while working, I recommend testing on a VM or at least a less important computer. 

**NB: I use the words "plugin" and "extension" interchangeably.**

  * [(See pack.raku plugin new)](#packraku-plugin-new---help)

[Table of Contents](#table-of-contents)

#### example

```bash
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
Str $credits = "Francis Grizzly Smit ©2025\nLicence GPL v3+"
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
```

[Table of Contents](#table-of-contents)

### If you want to manage an existing extension then use

```bash
pack.raku plugin add <key> <uuid> [<extra-sources1> <extra-sources2> ...] --force --mk-schema
```

  * [(See pack.raku plugin add)](#packraku-plugin-add)

[Table of Contents](#table-of-contents)

### To package a extension just call 

```bash
pack.raku alias do <key> --force
```

#### Or to package many this

```bash
pack.raku alias do <key0> <key1> <key2> ... <keyn> --force
```

  * [See pack.raku alias do --help](#packraku-alias-do---help).

[Table of Contents](#table-of-contents)

### pack

```bash
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
```

[Table of Contents](#table-of-contents)

pack.raku do --help
===================

```bash
pack.raku do --help

Usage:
  pack.raku do <dir> [<dirs> ...] [-f|--force] [-c|--command=<Str>] [-q|--quiet|--silent]
```

[Table of Contents](#table-of-contents)

Where

  * dir is a directory containing a **gnome-shell** plugin

    * assumes that the directory contains a `.pack_args.json` file which containes all the arguments for **gnome-extensions pack**.

  * `[dirs ...]` a list of aditional directories containing **gnome-shell** plugins same as dir.

  * `[-f|--force]` overrides the force parameter in every `.pack_args.json`.

  * `[-c|--command=<Str>]` overrides the command to list the current directory it is asummed this is the same as the output directory for all the plugins.

    * the default is **ls -Flaghi --color=always** this can be overriden by the value of the **LS_CMD** environment variable but the command-line value overrides both.

  * `[-q|--quiet|--silent]` if present then all non-error output is suppressed.

[Table of Contents](#table-of-contents)

pack.raku create --help
=======================

```bash
Usage:
  pack.raku create <package-dir> [<extra-sources> ...] [-s|--schema=<Str>] [-p|--podir=<Str>] [-g|--gettext-domain=<Str>] [-o|--out-dir=<Str>] [-f|--force]
```

Create the `.pack_args.json` file.

Where

  * `<package-dir>` Directory containing plugin.

  * `[<extra-sources> ...]` A list of extra files to add to the package.

  * `[-s|--schema=<Str>]` The path to the schema file.

  * `[-p|--podir=<Str>]` The path to the po files.

  * `[-g|--gettext-domain=<Str>]` The gettext domain.

  * `[-o|--out-dir=<Str>]` The directory to place the package file in.

  * `[-f|--force]` set the force option.

[Table of Contents](#table-of-contents)

pack.raku add
=============

```bash
pack.raku add --help

Usage:
  pack.raku add <package-dir> [<extra-sources> ...] [-s|--schema=<Str>] [-p|--podir=<Str>] [-g|--gettext-domain=<Str>] [-o|--out-dir=<Str>] [-f|--force] [-F|--stomp-force] [-S|--stomp]
```

Modifiy add to the `.pack_args.json` file.

Where

  * `<package-dir>` Directory containing plugin.

  * `[<extra-sources> ...]` A list of extra files to add to the package.

  * `[-s|--schema=<Str>]` The path to the schema file.

  * `[-p|--podir=<Str>]` The path to the po files.

  * `[-g|--gettext-domain=<Str>]` The gettext domain.

  * `[-o|--out-dir=<Str>]` The directory to place the package file in.

  * `[-f|--force]` set the force option.

  * `[-F|--stomp-force]` If present then the value of --force wins regradless.

  * `[-S|--stomp]` If present then @extra-sources stomps on whatever was before otherwise they are spliced together.

[Table of Contents](#table-of-contents)

pack.raku set schema
====================

```bash
pack.raku set schema --help

Usage:
  pack.raku set schema <package-dir> <schema-value>
```

Set the value of schema in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

  * `<schema-value>` new value of schema.

[Table of Contents](#table-of-contents)

pack.raku set podir
===================

```bash
pack.raku set podir --help

Usage:
  pack.raku set podir <package-dir> <podir-value>
```

Set the value of podir in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

  * `<podir-value>` new value of podir.

    * podir is the path of the directory containing the po files.

[Table of Contents](#table-of-contents)

pack.raku set gettext-domain
============================

```bash
pack.raku set gettext-domain --help

Usage:
  pack.raku set gettext-domain <package-dir> <gettext-domain-value>
```

Set the value of gettext-domain in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

  * `<gettext-domain-value>` new value of gettext-domain.

[Table of Contents](#table-of-contents)

pack.raku set out-dir
=====================

```bash
pack.raku set out-dir --help

Usage:
  pack.raku set out-dir <package-dir> <out-dir-value>
```

Set the value of out-dir in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

  * `<out-dir-value>` new value of out-dir.

[Table of Contents](#table-of-contents)

pack.raku set force
===================

```bash
pack.raku set force --help

Usage:
  pack.raku set force <package-dir> <force-value>
```

Set the value of force in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

  * `<force-value>` new value of force.

[Table of Contents](#table-of-contents)

pack.raku add-extra-sources
===========================

```bash
pack.raku add-extra-sources --help

Usage:
  pack.raku add-extra-sources <package-dir> [<extra-sources> ...]
```

Add to the value of extra-sources in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

  * `[<extra-sources> ...]` additional extra-sources.

[Table of Contents](#table-of-contents)

pack.raku set package-dir
=========================

```bash
pack.raku set package-dir --help

Usage:
  pack.raku set package-dir <package-dir> <package-dir-value>
```

Set the value of package-dir in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

  * `<package-dir-value>` new value of package-dir.

    * probably useless as `<package-dir>` and `<package-dir-value>` are to be expected to be the same generally, but if needed it's here.

[Table of Contents](#table-of-contents)

pack.raku set extra-sources
===========================

```bash
pack.raku set extra-sources --help

Usage:
  pack.raku set extra-sources <package-dir> [<extra-sources> ...]
```

Set the value of extra-sources in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

  * `[<extra-sources> ...]` new value of extra-sources.

[Table of Contents](#table-of-contents)

pack.raku append extra-sources
==============================

```bash
pack.raku append extra-sources --help

Usage:
  pack.raku append extra-sources <package-dir> [<extra-sources> ...]
```

Append `[<extra-sources> ...]` to the value of extra-sources in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

  * `[<extra-sources> ...]` value to append to extra-sources.

[Table of Contents](#table-of-contents)

pack.raku remove schema
=======================

```bash
pack.raku remove schema --help

Usage:
  pack.raku remove schema <package-dir>
```

Remove the value of schema in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

[Table of Contents](#table-of-contents)

pack.raku remove podir
======================

```bash
pack.raku remove podir --help

Usage:
  pack.raku remove podir <package-dir>
```

Remove the value of podir in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

[Table of Contents](#table-of-contents)

pack.raku remove gettext-domain
===============================

```bash
pack.raku remove gettext-domain --help

Usage:
  pack.raku remove gettext-domain <package-dir>
```

Remove the value of gettext-domain in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

[Table of Contents](#table-of-contents)

pack.raku remove out-dir
========================

```bash
pack.raku remove out-dir --help

Usage:
  pack.raku remove out-dir <package-dir>
```

Remove the value of out-dir in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

[Table of Contents](#table-of-contents)

pack.raku remove extra-sources
==============================

```bash
pack.raku remove extra-sources --help

Usage:
  pack.raku remove extra-sources <package-dir>
```

Truncate the value of extra-sources in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

[Table of Contents](#table-of-contents)

pack.raku get schema
====================

```bash
pack.raku get schema --help

Usage:
  pack.raku get schema <package-dir>
```

Get the value of schema in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

[Table of Contents](#table-of-contents)

pack.raku get podir
===================

```bash
pack.raku get podir --help

Usage:
  pack.raku get podir <package-dir>
```

Get the value of podir in `<package-dir>/.pack_args.json`

  * `NB: podir is the path to the directory containing the po files.`

Where

  * `<package-dir>` Directory containing plugin.

[Table of Contents](#table-of-contents)

pack.raku get gettext-domain
============================

```bash
pack.raku get gettext-domain --help

Usage:
  pack.raku get gettext-domain <package-dir>
```

Get the value of gettext-domain in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

[Table of Contents](#table-of-contents)

pack.raku get out-dir
=====================

```bash
pack.raku get out-dir --help

Usage:
  pack.raku get out-dir <package-dir>
```

Get the value of out-dir in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

[Table of Contents](#table-of-contents)

pack.raku get extra-sources
===========================

```bash
pack.raku get extra-sources --help

Usage:
  pack.raku get extra-sources <package-dir>
```

Get the value of extra-sources in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

[Table of Contents](#table-of-contents)

pack.raku get force
===================

```bash
pack.raku get force --help

Usage:
  pack.raku get force <package-dir>
```

Get the value of force in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

[Table of Contents](#table-of-contents)

pack.raku get package-dir
=========================

```bash
pack.raku get package-dir --help

Usage:
  pack.raku get package-dir <package-dir>
```

Get the value of package-dir in `<package-dir>/.pack_args.json`

Where

  * `<package-dir>` Directory containing plugin.

    * kind of redundant as it needs `package-dir` to get `package-dir`.

[Table of Contents](#table-of-contents)

pack.raku alias add
===================

```bash
pack.raku alias add --help

Usage:
  pack.raku alias add <key> <target>  [-s|--set|--force] [-c|--comment=<Str>]
```

Where 

  * `<key>` is a faily arbitray key.

  * `<target>` is a path to a directory containing a **gnome-shell** plugin.

  * `[-s|--set|--force]` if present then add the key directory pair even if it requires overwriting an existing entry.

  * `[-c|--comment=<Str>]` A comment to describe the key directory pair.

[Table of Contents](#table-of-contents)

pack.raku alias do --help
=========================

```bash
Usage:
  pack.raku alias do <key> [<keys> ...] [-f|--force] [-c|--command=<Str>] [-q|--quiet|--silent]
```

Where

  * key is a key pointing to a directory in the directory database containing a **gnome-shell** plugin

    * assumes that the directory contains a `.pack_args.json` file which containes all the arguments for **gnome-extensions pack**.

  * `[keys ...]` a list of aditional keys pointing to directories in the directory database containing **gnome-shell** plugins same as key.

  * `[-f|--force]` overrides the force parameter in every `.pack_args.json`.

  * `[-c|--command=<Str>]` overrides the command to list the current directory it is asummed this is the same as the output directory for all the plugins.

    * the default is **ls -Flaghi --color=always** this can be overriden by the value of the **LS_CMD** environment variable but the command-line value overrides both.

  * `[-q|--quiet|--silent]` if present then all non-error output is suppressed.

[Table of Contents](#table-of-contents)

pack.raku plugin new --help
===========================

```bash
pack.raku plugin new --help

Usage:
  pack.raku plugin new <key>  [--uuid=<Str>] [--name=<Str>] [--description=<Str>] [--gettext-domain=<Str>] [--settings-schema=<Str>] [--template=<Str>] [--credits=<Str>] [--prefs] [--schema-file] [--podirs] [--add-credits] [-a|--all-parmas|--all] [-f|--force] [-s|--silent] [-b|--backtrace] [-l|--dev-lang=<Str>] [-o|--output|--development-dir|--dev-dir=<Str>]
```

Make a new plugin/extension for gnome-shell Create a new plugin using `gnome-extensions create` and move it to a development area and set it up for `pack.raku alias do` etc.

Where

  * `<key>` A key which will be used to select the extension you wish to work with.

    * This is the only mandatory parameter.

      * **All the following 6 parameters can be left out and the program will prompt for them.**

      * And it is recommended to leave `--template` to be prompted for as this can be tricky to do manually.

  * `[--uuid=<Str>]` The unique identifier of the new extension.

  * `[--name=<Str>]` The user-visible name of the new extension.

  * `[--description=<Str>]` A short description of what the extension does.

  * `[--gettext-domain=<Str>]` The gettext domain used by the extension.

  * `[--settings-schema=<Str>]` The GSettings schema used by the extension.

  * `[--template=<Str>]` The template to use for the new extension.

  * `[--credits=<Str>]` Set the credits lines If not set and `--add-credits` or `--all` is present then will be prompted for.

    * **The following parameters will not be prompted for.**

  * `[--prefs]` Include prefs.js template.

  * `[--schema-file]` Add a schema file by name of `schemas/org.gnome.shell.extensions.{$gettext-domain}.gschema.xml`.

  * `[--podirs]` Add a po directory with gettext files preloaded; plus a `compile.sh` script to build and update the gettext files.

  * `[--add-credits]` Prompt for credits lines if `--credits` not set.

  * `[-a|--all-parmas|--all]` Same as `--podirs --schema-file --podirs --add-credits`.

  * `[-f|--force]` Add the force parameter to the `.pack_args.json` file.

  * `[-s|--silent]` Don't print out the steps taken defaults to `False`.

  * `[-l|--dev-lang=<Str>]` The language of the default `*.po` file to generate this should be the language the strings are in in the original source defaults to **en**.

  * `[-o|--output|--development-dir|--dev-dir=<Str>]` The directory to develop the plugin from; defaults to the current dir.

[Table of Contents](#table-of-contents)

Recommended Usage
-----------------

It is recommended that you use the following command line to get pretty much everything in you could desire in the starting point of your plugin/extension.

```bash
pack.raku plugin new <key> --all --force
```

  * **NB:**

    * The key `<key>` must be replaced with a real key.

This whole development model assumes that you don't want to develop the plugin/extension live as is `gnome-extensions create` model so I copy the plugin out line generated by `gnome-extensions create` to another location I use `~/Projects/gnome-shell/extensions/` and deleting the original that `gnome-extensions create` generates. 

[Table of Contents](#table-of-contents)

pack.raku plugin add
====================

```bash
pack.raku plugin add  --help

Usage:
  pack.raku plugin add <key> <uuid> [<extra-sources> ...] [-p|--extension-dir=<Str>] [--podir=<Str>] [-f|--force] [-s|--silent] [-b|--backtrace] [-m|--mk-schema] [-l|--dev-lang=<Str>]
```

Use this to add an existing extension into management by `pack.raku`.

Where

  * `<key>` The key to reference this extension by (mandatory).

  * `<uuid>` The unique id of the extension (mandatory).

    * The key directory pair will be `<key> => $extension-dir/$uuid.`

      * The description in the `metadata.json` file will form the pairs comment.

  * `[<extra-sources> ...]` An arbitrarily long list of additional files to add to the extensions package.

    * can be files other than JavaScript source.

  * `[-p|--extension-dir=<Str>]` The directory the plugin lives in defaults to `.` the current directory.

  * `[--podir=<Str>]` The name of the directory where the internationalisation source is kept defaults to `'po'`.

    * **NB:** Will generate the `compile.sh` file if it doesn't already exist.

  * `[-f|--force]` The force parameter for `.pack_args.json` file.

  * `[-s|--silent]` If True then don't show progress or error messages defaults to False.

  * `[-b|--backtrace]` Show backtrace info on error (only works if not silent).

  * `[-m|--mk-schema]` Make the schema file if it doesn't exist.

  * `[-l|--dev-lang=<Str>]` The language of the default `*.po` file to generate this should be the language the strings are in in the original source defaults to **en**.

Typical use:

```bash
pack.raku plugin add <key> <uuid> [<extra-sources1> <extra-sources2> ...] --force --mk-schema
```

[Table of Contents](#table-of-contents)

pack.raku alias add-extra-sources
=================================

```bash
pack.raku alias add-extra-sources --help

Usage:
  pack.raku alias add-extra-sources <key> [<extra-sources> ...]
```

Add sources to the **extra-sources** list.

Where

  * `<key>` The key of the extension to add to.

  * `[<extra-sources> ...]` Additional sources to add to the **extra-sources** list.

[Table of Contents](#table-of-contents)

pack.raku alias set-schema
==========================

```bash
pack.raku alias set-schema --help

Usage:
  pack.raku alias set-schema <key> <schema-value>
```

Set the value of the **schema**.

Where

  * `<key>` The key of the extension to add to.

  * `<schema-value>` New value of schema.

[Table of Contents](#table-of-contents)

pack.raku alias set-podir
=========================

```bash
pack.raku alias set-podir --help

Usage:
  pack.raku alias set-podir <key> <podir-value>
```

Set the value of podir in `<package-dir>/.pack_args.json`

Where

  * `<key>` The key of the extension.

  * `<podir-value>` New value of podir.

    * podir is the path of the directory containing the po files, relative to the extensions development directory.

[Table of Contents](#table-of-contents)

pack.raku alias set-gettext-domain
==================================

```bash
pack.raku alias set-gettext-domain --help

Usage:
  pack.raku alias set-gettext-domain <key> <gettext-domain-value>
```

Set the value of `gettext-domain` in `<package-dir>/.pack_args.json`

Where

  * `<key>` The key of the extension.

  * `<gettext-domain-value>` New value of gettext-domain.

[Table of Contents](#table-of-contents)

pack.raku alias set-out-dir
===========================

```bash
pack.raku alias set-out-dir --help

Usage:
  pack.raku alias set-out-dir <key> <out-dir-value>
```

Set the value of out-dir in `<package-dir>/.pack_args.json`

Where

  * `<key>` The key of the extension.

  * `<out-dir-value>` New value of out-dir.

[Table of Contents](#table-of-contents)

pack.raku alias set-force
=========================

```bash
pack.raku alias set-force --help

Usage:
  pack.raku alias set-force <key> <force-value>
```

Set the value of force in `<package-dir>/.pack_args.json`

Where

  * `<key>` The key of the extension.

  * `<force-value>` New value of force.

[Table of Contents](#table-of-contents)

pack.raku alias set-package-dir
===============================

```bash
pack.raku alias set-package-dir --help

Usage:
  pack.raku alias set-package-dir <key> <package-dir-value>
```

Add to the value of extra-sources in `<package-dir>/.pack_args.json`

Where

  * `<key>` The key of the extension.

  * `[<extra-sources> ...]` Additional extra-sources.

[Table of Contents](#table-of-contents)

pack.raku alias set-extra-sources
=================================

```bash
pack.raku alias set-extra-sources --help

Usage:
  pack.raku alias set-extra-sources <key> [<extra-sources> ...]
```

Set the value of extra-sources in `<package-dir>/.pack_args.json`

Where

  * `<key>` The key of the extension.

  * `[<extra-sources> ...]` New value of extra-sources.

[Table of Contents](#table-of-contents)

pack.raku alias append-extra-sources
====================================

```bash
pack.raku alias append-extra-sources --help

Usage:
  pack.raku alias append-extra-sources <key> [<extra-sources> ...]
```

Append `[<extra-sources> ...]` to the value of extra-sources in `<package-dir>/.pack_args.json`

Where

  * `<key>` The key of the extension.

  * `[<extra-sources> ...]` List of values to append to extra-sources.

[Table of Contents](#table-of-contents)

pack.raku alias remove-schema
=============================

```bash
pack.raku alias remove-schema --help

Usage:
  pack.raku alias remove-schema <key>
```

Remove the value of schema in `<package-dir>/.pack_args.json`

Where

  * `<key>` The key of the extension.

[Table of Contents](#table-of-contents)

pack.raku alias remove-podir
============================

```bash
pack.raku alias remove-podir --help

Usage:
  pack.raku alias remove-podir <key>
```

Remove the value of `podir` in `<package-dir>/.pack_args.json`

Where

  * `<key>` The key of the extension.

[Table of Contents](#table-of-contents)

pack.raku alias remove-gettext-domain
=====================================

```bash
pack.raku alias remove-gettext-domain --help

Usage:
  pack.raku alias remove-gettext-domain <key>
```

Remove the value of gettext-domain in `<package-dir>/.pack_args.json`

Where

  * `<key>` The key of the extension.

[Table of Contents](#table-of-contents)

pack.raku alias remove-out-dir
==============================

```bash
pack.raku alias remove-out-dir --help

Usage:
  pack.raku alias remove-out-dir <key>
```

Remove the value of out-dir in `<package-dir>/.pack_args.json`

Where

  * `<key>` The key of the extension.

[Table of Contents](#table-of-contents)

pack.raku alias remove-extra-sources
====================================

```bash
pack.raku alias remove-extra-sources --help

Usage:
  pack.raku alias remove-extra-sources <key>
```

Truncate the `extra-sources` list in `<package-dir>/.pack_args.json`.

Where

  * `<key>` The key of the extension.

[Table of Contents](#table-of-contents)

pack.raku alias get-schema
==========================

```bash
pack.raku alias get-schema --help

Usage:
  pack.raku alias get-schema <key>
```

Get the value of schema in `<package-dir>/.pack_args.json`

Where

  * `<key>` The key of the extension.

[Table of Contents](#table-of-contents)

pack.raku alias get-podir
=========================

```bash
pack.raku alias get-podir --help

Usage:
  pack.raku alias get-podir <key>
```

Get the value of `podir` in `<package-dir>/.pack_args.json`

  * **NB: `podir` is the path to the directory containing the po files.**

Where

  * `<key>` The key of the extension.

[Table of Contents](#table-of-contents)

pack.raku alias get-gettext-domain
==================================

```bash
pack.raku alias get-gettext-domain --help

Usage:
  pack.raku alias get-gettext-domain <key>
```

Get the value of `gettext-domain` in `<package-dir>/.pack_args.json`

Where

  * `<key>` The key of the extension.

[Table of Contents](#table-of-contents)

pack.raku alias get-out-dir
===========================

```bash
pack.raku alias get-out-dir --help

Usage:
  pack.raku alias get-out-dir <key>
```

  * `<key>` The key of the extension.

[Table of Contents](#table-of-contents)

pack.raku alias get-extra-sources
=================================

```bash
pack.raku alias get-extra-sources --help

Usage:
  pack.raku alias get-extra-sources <key>
```

Get the value of the `extra-sources` list in `<package-dir>/.pack_args.json`.

Where

  * `<key>` The key of the extension.

[Table of Contents](#table-of-contents)

pack.raku alias get-force
=========================

```bash
pack.raku alias get-force --help

Usage:
  pack.raku alias get-force <key>
```

Get the value of force in `<package-dir>/.pack_args.json`

Where

  * `<key>` The key of the extension.

[Table of Contents](#table-of-contents)

pack.raku alias get-package-dir
===============================

```bash
pack.raku alias get-package-dir --help

Usage:
  pack.raku alias get-package-dir <key>
```

Get the value of package-dir in `<package-dir>/.pack_args.json`

Where

  * `<key>` The key of the extension.

[Table of Contents](#table-of-contents)

pack.raku edit configs
======================

    pack.raku edit configs --help

    Usage:
      pack.raku edit configs

Open all configuration files for editing, avoid for expert use only and there are better ways, mostly.

[Table of Contents](#Table-of-Contents)

pack.raku list keys
===================

```bash
pack.raku list keys --help

Usage:
  pack.raku list keys [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
```

Where

  * `[<prefix>]` If present then search for keys starting with the string value.

  * `[-c|--color|--colour]` If present then show with ANSI colours.

  * `[-s|--syntax]` If present will override colour setting and display with syntax highlighted colours.

  * `[-l|--page-length[=Int]]` Set the page length before headers are re-shown.

  * `[-p|--pattern=<Str>]` A Raku regex to use to search for the matching keys.

  * `[-e|--ecma-pattern=<Str>]` A ECMA262Regex regex to use to search for the matching keys.

    * **NB: uses a imperfect library to convert the EMCA262Regex to a Raku one.** 

List all or a subset of the keys avaiable.

[Table of Contents](#table-of-contents)

pack.raku list all
==================

```bash
pack.raku list all --help

Usage:
  pack.raku list all [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
```

List the keys in the database.

Where

  * `[<prefix>]` If present then search for keys, directories or comments starting with the string value.

  * `[-c|--color|--colour]` If present then show with ANSI colours.

  * `[-s|--syntax]` If present will override colour setting and display with syntax highlighted colours.

  * `[-l|--page-length[=Int]]` Set the page length before headers are re-shown.

  * `[-p|--pattern=<Str>]` A raku regex to use to search for the matching keys, directories or comments.

  * `[-e|--ecma-pattern=<Str>]` A ECMA262Regex regex to use to search for the matching keys, directories or comments.

    * **NB:** uses a imperfect library to convert the EMCA262Regex to a raku one.

List all or a subset of the keys avaiable.

[Table of Contents](#table-of-contents)

pack.raku delete
================

```bash
pack.raku delete --help

Usage:
  pack.raku delete [<keys> ...] [-d|--delete|--do-not-trash]
```

Delete the specified key/directory paths from the database.

Where

  * `[<keys> ...]` the keys of the key/directory pairs that you want to delete.

  * `[-d|--delete|--do-not-trash]` If true then actually delete otherwise trash.

    * Trash means keep record but commented out.

[Table of Contents](#table-of-contents)

pack.raku del
=============

```bash
pack.raku delete --help

Usage:
  pack.raku del [<keys> ...] [-d|--delete|--do-not-trash]
```

Delete the specified key/directory paths from the database.

  * `NB: alias for delete`

Where

  * `[<keys> ...]` the keys of the key/directory pairs that you want to delete.

  * `[-d|--delete|--do-not-trash]` If true then actually delete otherwise trash.

    * Trash means keep record but commented out.

[Table of Contents](#table-of-contents)

pack.raku trash
===============

```bash
pack.raku delete --help

Usage:
  pack.raku delete [<keys> ...]
```

Trash the specified key/directory paths from the database.

Where

  * `[<keys> ...]` the keys of the key/directory pairs that you want to trash.

[Table of Contents](#table-of-contents)

pack.raku tidy file
===================

```bash
pack.raku tidy file --help

Usage:
  pack.raku tidy file
```

Tidy up the database file.

  * Pointless really just for when your feeling OCD.

[Table of Contents](#table-of-contents)

pack.raku comment
=================

```bash
pack.raku comment --help

Usage:
  pack.raku comment <key> <comment>  [-k|--kind=<Str where \{ ... } >]
```

Add a comment to an entry.

  * `<key>` The key of the record to add the comment to.

  * `<comment>` The comment.

  * `[-k|--kind=<Str where \{ ... } >]` The kind of record to add the comment to.

    * the possible values of $kind are one of ('neither', 'normal', 'commented', 'both').

    * default value is 'normal'.

[Table of Contents](#table-of-contents)

pack.raku list trash
====================

```bash
pack.raku list trash --help

Usage:
  pack.raku list trash [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
```

List the trashed keys in the database.

Where

  * `[<prefix>]` If present then search for keys, directories or comments starting with the string value.

  * `[-c|--color|--colour]` If present then show with ANSI colours.

  * `[-s|--syntax]` If present will override colour setting and display with syntax highlighted colours.

  * `[-l|--page-length[=Int]]` Set the page length before headers are re-shown.

  * `[-p|--pattern=<Str>]` A raku regex to use to search for the matching keys, directories or comments.

  * `[-e|--ecma-pattern=<Str>]` A ECMA262Regex regex to use to search for the matching keys, directories or comments.

    * **NB:** uses a imperfect library to convert the EMCA262Regex to a raku one.

[Table of Contents](#table-of-contents)

pack.raku empty trash
=====================

```bash
pack.raku empty trash --help

Usage:
  pack.raku empty trash
```

Delete all trashed/commented records.

[Table of Contents](#table-of-contents)

pack.raku undelete
==================

```bash
pack.raku undelete --help

Usage:
  pack.raku undelete [<keys> ...]
```

Undelete the specified keys.

  * `[<keys> ...]` The keys of the records to undelete.

[Table of Contents](#table-of-contents)

pack.raku show stats
====================

```bash
pack.raku show stats --help

Usage:
  pack.raku show stats [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
```

Show the stats for the database.

Where

  * `[<prefix>]` If present then search for keys starting with the string value.

  * `[-c|--color|--colour]` If present then show with ANSI colours.

  * `[-s|--syntax]` If present will override colour setting and display with syntax highlighted colours.

  * `[-p|--pattern=<Str>]` A Raku regex to use to search for the matching keys.

  * `[-e|--ecma-pattern=<Str>]` A ECMA262Regex regex to use to search for the matching keys..

    * **NB: uses a imperfect library to convert the EMCA262Regex to a Raku one.**

    * **NB: pattern and ecma-pattern search by the quantity keys, note the values.**

[Table of Contents](#table-of-contents)

pack.raku show statistics
=========================

```bash
pack.raku show stats --help

Usage:
  pack.raku show statistics [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
```

Show the statistics for the database.

  * `alias for show stats.`

Where

  * `[<prefix>]` If present then search for keys starting with the string value.

  * `[-c|--color|--colour]` If present then show with ANSI colours.

  * `[-s|--syntax]` If present will override colour setting and display with syntax highlighted colours.

  * `[-p|--pattern=<Str>]` A Raku regex to use to search for the matching keys.

  * `[-e|--ecma-pattern=<Str>]` A ECMA262Regex regex to use to search for the matching keys..

    * **NB: uses a imperfect library to convert the EMCA262Regex to a Raku one.**

    * **NB: pattern and ecma-pattern search by the quantity keys, note the values.**

[Table of Contents](#table-of-contents)

pack.raku backup db
===================

```bash
pack.raku backup db --help

Usage:
  pack.raku backup db  [-w|--win-format|--use-windows-formatting]
```

Backup the db file.

  * `[-w|--win-format|--use-windows-formatting]` Use windows compatible file names for the backup file.

    * **NB:** The backup file looks like pack.p_ck.2025-06-02T00:02:07.886302+10:00 normally but if you use this option then it will be like pack.p_ck.2025-07-05T09.29.03·560644+10.00 as : is a special char in windows filename names.

[Table of Contents](#table-of-contents)

pack.raku restore db
====================

```bash
pack.raku restore db --help

Usage:
  pack.raku restore db [<restore-from>]
```

Restore the db file from restore-from.

Where

  * `[<restore-from>]` A path to a restore file.

[Table of Contents](#table-of-contents)

pack.raku menu restore db
=========================

```bash
pack.raku menu restore db --help

Usage:
  pack.raku menu restore db [<message>]  [-c|--color|--colour] [-s|--syntax]
```

Use a text menu to present options for database file restore

  * `[<message>]` A message to display above the menu (currently not used in colour and syntax modes).

  * `[-c|--color|--colour]` Use ANSI colour mode.

  * `[-s|--syntax]` Use ANSI colour mode with syntax highlighting.

    * **NB:** looks like:

```bash
pack.raku menu restore db "testing one two three" 
testing one two three
         0	.rw-rw-r-- 394.0B grizzlysmit grizzlysmit 2025-06-02T07:49:56.429315+10:00 pack.p_ck.2025-06-02T00:02:07.886302+10:00
         1	.rw-rw-r-- 495.0B grizzlysmit grizzlysmit 2025-07-05T09:30:11.002659+10:00 pack.p_ck.2025-07-05T09:30:47.997666+10:00
         2	cancel
use cancel, bye, bye bye, quit, q, or 2 to quit
choose a candidate 0..2 =:> q
```

in ascii/UTF-8 mode.

[Table of Contents](#table-of-contents)

pack.raku list db backups
=========================

```bash
pack.raku list db backups --help

Usage:
  pack.raku list db backups [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
```

List the db backups in the standard directory.

Where

  * `[<prefix>]` List only those whose name starts with prefix (case insensitive).

  * `[-c|--color|--colour] [-s|--syntax]` List in colour..

  * `[-s|--syntax]` List in syntax highlighted colour.

  * `[-l|--page-length[=Int]]` List in pages of length $page-length.

  * `[-p|--pattern=<Str>]` List only those matching this Raku regex.

  * `[-e|--ecma-pattern=<Str>]` List only those matching this EMCA262Regex regex.

  * `The EMCA262Regex library doesn't support ignore case well.` .

[Table of Contents](#table-of-contents)

pack.raku list editors
======================

```bash
pack.raku list editors --help

Usage:
  pack.raku list editors  [-f|--prefix=<Str>] [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
```

List the contents of the db file.

Where

  * `[<prefix>]` List only those whose name starts with prefix (case insensitive).

  * `[-c|--color|--colour] [-s|--syntax]` List in colour..

  * `[-s|--syntax]` List in syntax highlighted colour.

  * `[-l|--page-length[=Int]]` List in pages of length $page-length.

  * `[-p|--pattern=<Str>]` List only those matching this Raku regex.

  * `[-e|--ecma-pattern=<Str>]` List only those matching this EMCA262Regex regex.

  * `The EMCA262Regex library doesn't support ignore case well.` .

```bash
pack.raku list editors

Editors | Actual Editor  
=========================
gedit   |                
gvim    |             *  
kate    |                
xemacs  |                
=========================
```

[Table of Contents](#table-of-contents)

pack.raku editors stats
=======================

```bash
pack.raku editors stats --help

Usage:
  pack.raku editors stats [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
```

Show the statistics for the editors database.

Where

  * `[<prefix>]` If present then search for keys starting with the string value.

  * `[-c|--color|--colour]` If present then show with ANSI colours.

  * `[-s|--syntax]` If present will override colour setting and display with syntax highlighted colours.

  * `[-p|--pattern=<Str>]` A Raku regex to use to search for the matching keys.

  * `[-e|--ecma-pattern=<Str>]` A ECMA262Regex regex to use to search for the matching keys..

    * **NB: uses a imperfect library to convert the EMCA262Regex to a Raku one.**

    * **NB: pattern and ecma-pattern search by the quantity keys, note the values.**

```bash
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
```

[Table of Contents](#table-of-contents)

pack.raku list editors backups
==============================

```bash
pack.raku list editors backups --help

Usage:
  pack.raku list editors backups [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
```

Show the statistics for the editors database.

Where

  * `[<prefix>]` If present then search for keys starting with the string value.

  * `[-c|--color|--colour]` If present then show with ANSI colours.

  * `[-s|--syntax]` If present will override colour setting and display with syntax highlighted colours.

  * `[-p|--pattern=<Str>]` A Raku regex to use to search for the matching keys.

  * `[-e|--ecma-pattern=<Str>]` A ECMA262Regex regex to use to search for the matching keys..

    * **NB: uses a imperfect library to convert the EMCA262Regex to a Raku one.**

    * **NB: pattern and ecma-pattern search by the quantity keys, note the values.**

```bash
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
```

[Table of Contents](#table-of-contents)

pack.raku backup editors
========================

```bash
pack.raku backup editors --help

Usage:
  pack.raku backup editors  [-w|--use-windows-formatting]
```

Backup the editors db file.

  * `[-w|--win-format|--use-windows-formatting]` Use windows compatible file names for the backup file.

    * **NB:** The backup file looks like editors.2025-06-02T00:02:07.886302+10:00 normally but if you use this option then it will be like editors.2025-07-05T09.29.03·560644+10.00 as : is a special char in windows filename names.

[Table of Contents](#table-of-contents)

pack.raku restore editors
=========================

```bash
pack.raku restore editors --help

Usage:
  pack.raku restore editors <restore-from>
```

Restore the editors db file from restore-from.

Where

  * `[<restore-from>]` A path to a restore file.

[Table of Contents](#table-of-contents)

pack.raku set editor
====================

```bash
pack.raku set editor --help

Usage:
  pack.raku set editor <editor> [<comment>]
```

Set the default editor to use.

Where

  * `<editor>` The editor to make default.

  * `[<comment>]` A comment to put against the editor.

[Table of Contents](#table-of-contents)

pack.raku set override GUI_EDITOR
=================================

```bash
pack.raku set override GUI_EDITOR --help

Usage:
  pack.raku set override GUI_EDITOR <value> [<comment>]
```

Set the value of the override-GUI_EDITOR parameter 

Where

  * `<value>` The value of the parameter (True or False).

  * `[<comment>]` A comment to place against the parameter.

[Table of Contents](#table-of-contents)

pack.raku menu restore editors
==============================

```bash
pack.raku menu restore editors --help

Usage:
  pack.raku menu restore editors [<message>]  [-c|--color|--colour] [-s|--syntax]
```

Restore the editors db using a menu of backups from the standard directory.

Where

  * `[<message>]` A message to display above the menu only works in monochrome version.

  * `[-c|--color|--colour]` Use ANSI colour mode.

  * `[-s|--syntax]` Use ANSI colour mode and syntax highlighting.

[Table of Contents](#table-of-contents)

pack.raku USAGE
===============

```bash
pack.raku USAGE [-n|--nocolor|--nocolour]
```

Shows the USAGE without this method purpose is to implement the coloured usage.

Where

  * `[-n|--nocolor|--nocolour]` Show the usage in monochrome.

[Table of Contents](#table-of-contents)

multi sub GENERATE-USAGE
========================

```raku
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
```

Does the real work generating the colored usage.

[Table of Contents](#table-of-contents)



