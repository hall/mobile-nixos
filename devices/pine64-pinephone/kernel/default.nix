{
  mobile-nixos
, fetchFromGitHub
, fetchpatch
, fetchurl
, ...
}:

mobile-nixos.kernel-builder {
  version = "5.13.7";
  configfile = ./config.aarch64;
  src = fetchFromGitHub {
    # https://github.com/megous/linux
    owner = "megous";
    repo = "linux";
    # orange-pi-5.13
    rev = "b1f383fd3c70e21a8062fdc3f59403d2a26edc9f";
    sha256 = "0m1jhkq6lxp12a302r80qbz8l1sdmqnwfymg1lx68c91dm7j3wkf";
  };
  patches = [
    ./0001-dts-pinephone-Setup-default-on-and-panic-LEDs.patch
    (fetchpatch {
      url = "https://github.com/mobile-nixos/linux/commit/372597b5449b7e21ad59dba0842091f4f1ed34b2.patch";
      sha256 = "1lca3fdmx2wglplp47z2d1030bgcidaf1fhbnfvkfwk3fj3grixc";
    })

    # patchurl is required since it's a bundle of multiple commits,
    # and fetchpatch's normalization ruins the ordering
    (fetchurl {
      url = "https://github.com/dreemurrs-embedded/Pine64-Arch/raw/32639373a6332822faec5952d844c62e3acb6e2f/PKGBUILDS/pine64/linux-megi/pp-keyboard.patch";
      sha256 = "sha256-N8+ZhKGgafWknvekThhutMX6coOu/QHUX0eY1k0Ax1Q=";
    })
  ];

  # Install *only* the desired FDTs
  postInstall = ''
    echo ":: Installing FDTs"
    mkdir -p "$out/dtbs/allwinner"
    cp -v $buildRoot/arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone-*.dtb $out/dtbs/allwinner/
  '';

  isCompressed = false;
}
