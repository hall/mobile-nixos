{ mobile-nixos
, fetchFromGitLab
, fetchurl
, ...
}:

mobile-nixos.kernel-builder {
  version = "5.16.0-rc5";
  configfile = ./config.aarch64;

  src = fetchFromGitLab {
    owner = "mobian1";
    repo = "devices/rockchip-linux";
    rev = "3c90f5eca702b5906e4707affadabd51c8f08603"; # update-rc5
    sha256 = "sha256-dSbSWQYtziYYG+WS3UjKXJS8HFpImhheCKGr+pU+d/M=";
  };

  # Apply mobian debian-style bundled patches.
  prePatch = ''
    for f in $(cat debian/patches/series); do
      patch -p1 < "debian/patches/$f";
    done
  '';

  patches = [
    ./0001-arm64-dts-rockchip-set-type-c-dr_mode-as-otg.patch
    ./0001-usb-dwc3-Enable-userspace-role-switch-control.patch
    ./0001-dts-pinephone-pro-Setup-default-on-and-panic-LEDs.patch

    # patchurl is required since it's a bundle of multiple commits,
    # and fetchpatch's normalization ruins the ordering
    (fetchurl {
      url = "https://github.com/dreemurrs-embedded/Pine64-Arch/raw/32639373a6332822faec5952d844c62e3acb6e2f/PKGBUILDS/pine64/linux-megi/pp-keyboard.patch";
      sha256 = "sha256-N8+ZhKGgafWknvekThhutMX6coOu/QHUX0eY1k0Ax1Q=";
    })
  ];

  postInstall = ''
    echo ":: Installing FDTs"
    mkdir -p $out/dtbs/rockchip
    cp -v "$buildRoot/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dtb" "$out/dtbs/rockchip/"
  '';

  isModular = false;
  isCompressed = false;
}
