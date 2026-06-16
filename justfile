# Print list of available recipes
default:
  @just --list

version_dirty := `[ -z "$(git status -s)" ] || echo "-$(date +"%H%M%S")"`
version := `git describe --tags --dirty --always` + version_dirty

flatcar_version := "4593.2.3"

# Print version that will be used in the build
version:
  @echo "Using version {{version}} with flatcar version {{flatcar_version}}"

# Build control-usb-root
build: && version
  ./gen-control-usb-root.sh {{flatcar_version}}


# Publish control-usb-root
push: && version
  oras push ghcr.io/githedgehog/fabricator/control-usb-root:{{version}} boot EFI images flatcar_production_*


local-push:
  oras push --plain-http 127.0.0.1:30000/githedgehog/fabricator/control-usb-root:v{{flatcar_version}}-hh9 boot EFI images flatcar_production_*

# ISO Build
iso-build:
  mkdir -p iso_tree
  cp -r boot iso_tree
  cp -r  EFI iso_tree
  cp -r  images/efi.img iso_tree
  cp -r  flatcar_production_pxe* iso_tree
  sed -i -e 's/ *flatcar\.first_boot=1//g' -e 's# */oem\.cpio\.gz##g' ./iso_tree/boot/grub/grub.cfg
  xorrisofs -eltorito-alt-boot -e 'efi.img' -no-emul-boot -append_partition 2 0xef ./iso_tree/efi.img -o flatcar-{{flatcar_version}}.iso ./iso_tree

# Build and Push an iso
iso-push: iso-build
  oras push ghcr.io/githedgehog/fabricator/control-usb-root:{{version}} flatcar-{{flatcar_version}}.iso

