# control-usb-root

This repo contains the artifacts from flatcar that we in hedgehog use to build
our images. Vlab VMs, control node, and gateway node.

## Steps to bump the latest version

The flatcar version number is saved in two files, `justfile` and the
`gen-control-usb-root.sh`. Keep them updated and matching.

1. Select the desired stable release number from [their stable
   releases](https://stable.release.flatcar-linux.net/amd64-usr/) for example
`4152.2.2`
1. edit the `justfile` to include the selected relase, e.g. `4152.2.2`
1. edit the `gen-control-usb-root.sh` to include the selected release
1. `git tag -s v4152.2.2-hh1 -m 'bumping flatcar'`
1. `git push origin v4152.2.2-hh1`
1. The CI is setup to run `just push` after a tag has been pushed so that 
   the artifacts are generated and sent to oras
1. go to the fabricator repo and update the existing tag to the tag pushed in
   the previous step. At the time of writing it is in 3 places, across two
   files. `pkg/fab/README.md` and `pkg/fab/versions.go`. The real test is to
   run `just test` inside of fabricator to ensure all locations are in sync.


## Notes

`gen-control-usb-root.sh` is intended to run on ubuntu, it uses the command
`grub-install`. On Red Hat based distros this identical command is named
`grub2-install`. Additionally the Red Hat  based distributions use `grub2` in
the file paths, this subtle difference is irksome.


## Contents of this repo

* `images/` - this directory contains a file, `efi.img`. That file is placed
  inside the root of the iso which is what allows us to boot an iso from a UEFI
based system. `efi.img` is not expected to changed often. It is created via
`efi_img_iso9660` in the `gen-control-usb-root.sh` the function is run in
the normal course of execution.
* `flatcar_production*` - these files are release artifacts downloaded from
  flatcar.org
* `boot` - directory containing files needed to boot flatcar. This is generated
  by the `script control-usb-root.sh`
* `EFI` - directory containing files needed to boot flatcar. This is generated
  by the `script control-usb-root.sh`
