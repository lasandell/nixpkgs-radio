{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, airspy, fftwFloat, hackrf, libbladeRF, mosquitto, openssl, rtl-sdr
, sdrplay, soapysdr-with-plugins, uhd, zeromq, zlib
, sdrplaySupport ? false
}:

stdenv.mkDerivation rec {
  pname = "meshtastic-sniffer";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "alphafox02";
    repo = "meshtastic-sniffer";
    rev = "v${version}";
    hash = "sha256-+vdwX5c6oi6Dhm9slg8aMYiMl3nI8+ywdCR5jaAiDfk=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    airspy fftwFloat hackrf libbladeRF mosquitto openssl rtl-sdr
    soapysdr-with-plugins uhd zeromq zlib
  ]
  ++ lib.optionals sdrplaySupport [ sdrplay ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail '-march=native' ""
  '';

  meta = with lib; {
    description = "Wideband passive Meshtastic LoRa receiver";
    homepage = "https://github.com/alphafox02/meshtastic-sniffer";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "meshtastic-sniffer";
  };
}
