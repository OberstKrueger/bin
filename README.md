# bin

A collection of CLI tools that I have created for myself. They are kept in this monorepo to simplify dependency updates and shared
shared functionality.

## bandwidth

USAGE: bandwidth [\<inputs\> ...]

ARGUMENTS:
  \<inputs\>

OPTIONS:
  -h, --help              Show help information.

## music

USAGE: music [--debug] [--sort]

OPTIONS:
  -d, --debug             Prints debug information about the playlists.
  -s, --sort              Sorts debug information by average playcount.
  -h, --help              Show help information.

## random

USAGE: random [--repeat \<repeat\>] [\<first\>] [\<second\>]

ARGUMENTS:
  \<first\>
  \<second\>

OPTIONS:
  -r, --repeat \<repeat\>    (default: 1)
  -h, --help              Show help information.
