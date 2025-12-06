{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, libacars, libsndfile, paho-mqtt-c, soapysdr-with-plugins }:

stdenv.mkDerivation rec {
  pname = "acarsdec";
  version = "4.4";

  src = fetchFromGitHub {
    owner = "f00b4r0";
    repo = "acarsdec";
    rev = "v${version}";
    hash = "sha256-ZIkUQVb8SlKDKtMrQg2jOlGupfVPLA+hbeJ/qvI2vEk=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libacars libsndfile paho-mqtt-c soapysdr-with-plugins ];

  cmakeFlags = [ "-Dsoapy=ON" ];

  meta = with lib; {
    description = "ACARS SDR decoder";
    homepage = "https://github.com/f00b4r0/acarsdec/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    mainProgram = "acarsdec";
  };
}
