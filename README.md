# go-workspace.sh

## Copyright and Licensing

### Copyright Notice

The copyright for the software, documentation, and associated files are
held by the author.

    Copyright 2014 Todd A. Jacobs
    All rights reserved.

The AUTHORS file is also included in the source tree.

### Software License

![GPLv3 Logo][GPL3_PNG]

The software is licensed under the [GPLv3][GPLv3]. The LICENSE file is
included in the source tree.

### README License

![Creative Commons BY-NC-SA Logo][BY_NC_SA_PNG]

This README is licensed under the [Creative Commons
Attribution-NonCommercial-ShareAlike 3.0 United States
License][BY_NC_SA_3]

## Purpose

Configure a Go workspace and essential environment variables.

## Installation and Setup

Just place the script somewhere in your PATH, such as ~/bin or /usr/local/bin.

## Usage

    go-workspace.sh [-h|-u]
    go-workspace.sh [-g <GOPATH>] [-b <GOBIN>] [-s <SHELLRC>] [-d] [-v]

## Options:

    -h = show documentation
    -u = show usage
    -v = show variables and exit
    -d = debugging
    -g = GOPATH (path to Go tree)
    -b = GOBIN (path to binaries Go compiles)
    -s = SHELLRC (path to shell startup file)

----

[Project Home Page][HOME]

  [HOME]: https://github.com/CodeGnome/go-workspace
  [GPLv3]: http://www.gnu.org/copyleft/gpl.html
  [GPL3_PNG]: http://www.gnu.org/graphics/gplv3-88x31.png
  [BY_NC_SA_3]: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
  [BY_NC_SA_PNG]: http://i.creativecommons.org/l/by-nc-sa/3.0/us/88x31.png
