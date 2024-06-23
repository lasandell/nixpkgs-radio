{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, libacars, libsndfile, paho-mqtt-c, soapysdr-with-plugins }:

stdenv.mkDerivation rec {
  pname = "acarsdec";
  version = "unstable-2023-04-08";

  src = fetchFromGitHub {
    owner = "TLeconte";
    repo = "acarsdec";
    rev = "7920079b8e005c6c798bd478a513211daf9bbd25";
    hash = "sha256-SE8amDCtyJlqMMoGOoT80t3Ponws1VDTt/e7HpDdmXI=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libacars libsndfile paho-mqtt-c soapysdr-with-plugins ];

  cmakeFlags = [ "-Dsoapy=ON" ];

  meta = with lib; {
    description = "ACARS SDR decoder";
    homepage = https://github.com/TLeconte/acarsdec;
    license = licenses.gpl2;
    platforms = platforms.linux;
    mainProgram = "acarsdec";
  };
}
