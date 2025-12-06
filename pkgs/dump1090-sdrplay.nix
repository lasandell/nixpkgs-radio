{ lib, stdenv, fetchFromGitHub, pkg-config, rtl-sdr, sdrplay }:

stdenv.mkDerivation rec {
  pname = "dump1090-sdrplay";
  version = "unstable-2023-08-28";

  src = fetchFromGitHub {
    owner = "SDRplay";
    repo = "dump1090";
    rev = "b5a60d233057c5b904db3950efa29b6f1393fa2c";
    sha256 = "sha256-dMtq1ZCUUDaW4Wp/hG5xndvLCR9B9zE/s2y/HB/Quzc=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ rtl-sdr sdrplay ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'PKG_CONFIG_PATH=' '#PKG_CONFIG_PATH='
  '';

  buildFlags = ["PREFIX=${placeholder "out"}"];

  doCheck = true;

  installPhase = ''
    mkdir -p $out/bin $out/share
    cp -v dump1090 $out/bin/dump1090-sdrplay
    cp -v view1090 $out/bin/view1090-sdrplay
    cp -vr public_html $out/share/dump1090
  '';

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=calloc-transposed-args"
  ];

  meta = with lib; {
    description = "ADS-B Ground Station System Decoder";
    homepage = "https://github.com/SDRplay/dump1090";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "dump1090-sdrplay";
  };
}