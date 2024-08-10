{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, libmirisdr5, soapysdr }:

stdenv.mkDerivation rec {
  pname = "soapymiri";
  version = "unstable-2023-09-21";

  src = fetchFromGitHub {
    owner = "ericek111";
    repo = "SoapyMiri";
    rev = "ae106fac0f33dc675e1284e7efb5e3d9dbeb3d94";
    sha256 = "sha256-sxyfWV+od6E3TD25ipzRLhEtjBHql7KIkDhtdDsu1wQ=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libmirisdr5 soapysdr ];

  meta = with lib; {
    description = "SoapySDR driver for libmirisdr";
    longDescription = "An open-source alternative for the SDRPlay API";
    homepage = "https://github.com/ericek111/SoapyMiri";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
