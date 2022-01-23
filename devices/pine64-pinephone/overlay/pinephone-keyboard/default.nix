{ lib, stdenv, fetchgit, php, python3, sdcc }:

stdenv.mkDerivation {
  pname = "pinephone-keyboard";
  version = "unstable-2022-01-19";

  src = fetchgit {
    url = "https://xff.cz/git/pinephone-keyboard";
    rev = "024d52263ea8e1fdd06b1802e0d0ba2e6344c9bd";
    sha256 = "sha256-rO9991uBQA0jxHhF6+uTrpz2iwGPeifvIoBhnlGS52M=";
  };

  patches = [
    ./version.patch

    # It was removed in <https://xff.cz/git/pinephone-keyboard/commit/?id=013149dc89655578f142086d1fdd9f727c783843>
    ./remove-selftest.patch
  ];

  nativeBuildInputs = [ php python3 sdcc ];

  postPatch = ''
    patchShebangs firmware/build.sh
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/pinephone-keyboard
    cp build/ppkb-* $out/bin
    cp build/*.bin $out/share/pinephone-keyboard

    runHook postInstall
  '';

  meta = with lib; {
    description = "Userspace tools and firmware for the PinePhone keyboard";
    homepage = "https://xff.cz/git/pinephone-keyboard";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.zhaofengli ];
    platforms = platforms.unix;
  };
}
