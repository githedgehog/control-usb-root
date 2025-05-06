# Print list of available recipes
default:
  @just --list

version_dirty := `[ -z "$(git status -s)" ] || echo "-$(date +"%H%M%S")"`
version := `git describe --tags --dirty --always` + version_dirty

flatcar_version := "4152.2.3"

# Print version that will be used in the build
version:
  @echo "Using version {{version}} with flatcar version {{flatcar_version}}"

# Build control-usb-root
build: && version
  ./gen-control-usb-root.sh {{flatcar_version}}


# Publish control-usb-root
push: && version
  oras push ghcr.io/githedgehog/fabricator/control-usb-root:{{version}} boot EFI images flatcar_production_*
