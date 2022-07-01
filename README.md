Pack:
=====

1. [Introduction](#introduction)
1. [USAGE](#usage)

## Introduction

Create and maintain the `$dir/.pack_args.json` config file, and use said file to construct a `gnome-extensions pack` command line; in order to create the package used buy `gnome-shell` to install it's plugins.

1. [Do: actaully make the package](#do-actaully-make-the-package)
1. [Create](#create)
1. [Add](#add)
1. [set schema](#set-schema)
1. [set podir](#set-podir)
1. [set gettext-domain](#set-gettext-domain)
1. [set out-dir](#set-out-dir)
1. [set force](#set-force)
1. [add-extra-sources](#add-extra-sources)
1. [set package-dir](#set-package-dir)
1. [set extra-sources](#set-extra-sources)
1. [append extra-sources](#append-extra-sources)
1. [remove schema](#remove-schema)
1. [remove podir](#remove-podir)
1. [remove gettext-domain](#remove-gettext-domain)
1. [remove out-dir](#remove-out-dir)
1. [remove extra-sources](#remove-extra-sources)
1. [get schema](#get-schema)
1. [get podir](#get-podir)
1. [get gettext-domain](#get-gettext-domain)
1. [get out-dir](#get-out-dir)
1. [get extra-sources](#get-extra-sources)
1. [get force](#get-force)
1. [get package-dir](#get-package-dir)

## USAGE

```sh
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
```

## Do: actaully make the package

This acctaully makes the plugin package.

Calls `gnome-extensions pack` with the arguments specified in `$dir/.pack_args.json`  to build the gnome plugin package 

```sh
pack.raku [-f|--force] do <dir>
```

e.g.

```sh
$ pack.raku --force do hplip-menu2@grizzlysmit.smit.id.au
```
calls:

```sh
gnome-extensions pack --schema=schemas/org.gnome.shell.extensions.hplip-menu2.gschema.xml --podir=po --gettext-domain=hplip-menu2 --force --out-dir=/home/grizzlysmit/Projects/gnome-shell/extensions hplip-menu2@grizzlysmit.smit.id.au
```
