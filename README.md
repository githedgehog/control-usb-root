# control-usb-root

This repo contains the artifacts from flatcar that we in hedgehog use to build
our images. Vlab VMs, control node, and gateway node.

## Steps to bump the latest version

The flatcar version number is saved in two files, `justfile` and the
`gen-control-usb-root.sh`. Keep them updated and matching.

1. Get the desired stable release number from [their stable
   releases](https://stable.release.flatcar-linux.net/amd64-usr/) for example
`4152.2.2`
1. `just build  4152.2.2`
1. `just push `
1. `git tag -s v4152.2.2-hh1 -m 'bumping flatcar'`
1. `git push origin v4152.2.2-hh1`


## Notes

`gen-control-usb-root.sh` is intended to run on ubuntu, it uses the command
`grub-install`. On Red Hat based distros this identical command is named
`grub2-install`.


## Contents of this repo

* `images/` - this directory contains a file, `efi.img`. That file is placed
  inside the root of the iso which is what allows us to boot an iso from a UEFI
based system. `efi.img` is not expected to changed often. It is created via
`efi_img_iso9660` in the `gen-control-usb-root.sh` the function is not run in
the normal course of execution and is activated via flag.
* `flatcar_production*` - these files are release artifacts downloaded from
  flatcar.org
* `boot` - directory containing files needed to boot flatcar. This is generated
  by the `script control-usb-root.sh`
* `EFI` - directory containing files needed to boot flatcar. This is generated
  by the `script control-usb-root.sh`
