App::pack
=========

Module Pack
===========

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

  * [pack.raku do --help](#packraku-do---help)

  * [pack.raku create --help](#packraku-create---help)

  * [pack.raku alias add](#packraku-alias-add)

  * [pack.raku alias do --help](#packraku-alias-do---help)

  * [pack.raku edit configs](#packraku-edit-configs)

  * [pack.raku list keys](#packraku-list-keys)

  * [pack.raku list all](#packraku-list-all)

NAME
====

App::pack 

AUTHOR
======

Francis Grizzly Smit (grizzly@smit.id.au)

VERSION
=======

v0.1.0

TITLE
=====

pack

SUBTITLE
========

A Raku program to manage the use of **gnome-extensions pack**, it has too many arguments this makes it easy.

COPYRIGHT
=========

GPL V3.0+ [LICENSE](https://github.com/grizzlysmit/Usage-Utils/blob/main/LICENSE)

[Top of Document](#table-of-contents)

Introduction
============

This is a Raku program to manage the use of **gnome-extensions pack**, it has too many arguments this makes it easy. 

Motivation
----------

The command **gnome-extensions pack** has too many arguments this takes care of that making it easier to package up your gnome-shell extensions. 

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
```

pack.raku do --help
===================

```bash
pack.raku do --help

Usage:
  pack.raku do <dir> [<dirs> ...] [-f|--force] [-c|--command=<Str>] [-q|--quiet|--silent]

L<Table of Contents|#table-of-contents>
```

Where

  * dir is a directory containing a **gnome-shell** plugin

    * assumes that the directory contains a `.pack_args.json` file which containes all the arguments for **gnome-extensions pack**.

  * **[dirs ...]** a list of aditional directories containing **gnome-shell** plugins same as dir.

  * **[-f|--force]** overrides the force parameter in every `.pack_args.json`.

  * **[-c|--command=<Str>]** overrides the command to list the current directory it is asummed this is the same as the output directory for all the plugins.

    * the default is **ls -Flaghi --color=always** this can be overriden by the value of the **LS_CMD** environment variable but the command-line value overrides both.

  * **[-q|--quiet|--silent]** if present then all non-error output is suppressed.

[Table of Contents](#table-of-contents)

```bash
Usage:
  pack.raku create <package-dir> [<extra-sources> ...] [-s|--schema=<Str>] [-p|--podir=<Str>] [-g|--gettext-domain=<Str>] [-o|--out-dir=<Str>] [-f|--force]
```

pack.raku create --help
=======================

Create the `.pack_args.json` file.

Where

  * **<package-dir>** Directory containing plugin.

  * **[<extra-sources> ...]** A list of extra files to add to the package.

  * **[-s|--schema=<Str>]** The path to the schema file.

  * **[-p|--podir=<Str>]** The path to the po files.

  * **[-g|--gettext-domain=<Str>]** The gettext domain.

  * **[-o|--out-dir=<Str>]** The directory to place the package file in.

  * **[-f|--force]** set the force option.

[Table of Contents](#table-of-contents)

pack.raku alias add
===================

```bash
pack.raku alias add --help

Usage:
  pack.raku alias add <key> <target>  [-s|--set|--force] [-c|--comment=<Str>]
```

Where 

  * **<key>** is a faily arbitray key.

  * **<target>** is a path to a directory containing a **gnome-shell** plugin.

  * **[-s|--set|--force]** if present then add the key directory pair even if it requires overwriting an existing entry.

  * **[-c|--comment=<Str>]** A comment to describe the key directory pair.

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

  * **[keys ...]** a list of aditional keys pointing to directories in the directory database containing **gnome-shell** plugins same as key.

  * **[-f|--force]** overrides the force parameter in every `.pack_args.json`.

  * **[-c|--command=<Str>]** overrides the command to list the current directory it is asummed this is the same as the output directory for all the plugins.

    * the default is **ls -Flaghi --color=always** this can be overriden by the value of the **LS_CMD** environment variable but the command-line value overrides both.

  * **[-q|--quiet|--silent]** if present then all non-error output is suppressed.

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

  * **[<prefix>]** If present then search for keys starting with the string value.

  * **[-c|--color|--colour]** If present then show with ANSI colours.

  * **[-s|--syntax]** If present will override colour setting and dispaly with syntax highlighted colours.

  * **[-l|--page-length[=Int]]** Set the page length before headers are reshown.

  * **[-p|--pattern=<Str>]** A raku regex to use to search for the matching keys.

  * **[-e|--ecma-pattern=<Str>]** A ECMA262Regex regex to use to search for the matching keys.

    * **NB:** uses a imperfect library to convert the EMCA262Regex to a raku one.

List all or a subset of the keys avaiable.

[Table of Contents](#table-of-contents)

pack.raku list all
==================

```bash
pack.raku list all --help

Usage:
  pack.raku list all [<prefix>]  [-c|--color|--colour] [-s|--syntax] [-l|--page-length[=Int]] [-p|--pattern=<Str>] [-e|--ecma-pattern=<Str>]
```

Where

  * **[<prefix>]** If present then search for keys, directories or comments starting with the string value.

  * **[-c|--color|--colour]** If present then show with ANSI colours.

  * **[-s|--syntax]** If present will override colour setting and dispaly with syntax highlighted colours.

  * **[-l|--page-length[=Int]]** Set the page length before headers are reshown.

  * **[-p|--pattern=<Str>]** A raku regex to use to search for the matching keys, directories or comments.

  * **[-e|--ecma-pattern=<Str>]** A ECMA262Regex regex to use to search for the matching keys, directories or comments.

    * **NB:** uses a imperfect library to convert the EMCA262Regex to a raku one.

List all or a subset of the keys avaiable.

[Table of Contents](#table-of-contents)



