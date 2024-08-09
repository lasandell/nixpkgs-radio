{ stdenv, lib, fetchFromGitHub, autoPatchelfHook, cmake, pkg-config, sdrplay2, soapysdr }:

stdenv.mkDerivation rec {
  pname = "soapysdrplay2";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapySDRPlay2";
    rev = "soapy-sdrplay-${version}";
    sha256 = "sha256-UI+t43DqinZZHlII1rlSyiIP1n2w91RP4MExs1q4IXE=";
  };

  nativeBuildInputs = [ autoPatchelfHook cmake pkg-config ];

  buildInputs = [ sdrplay2 soapysdr ];

  postPatch = ''
    substituteInPlace Registration.cpp \
      --replace-fail \"sdrplay \"sdrplay2 \
      --replace-fail \"SDRplay \"SDRplay2
    substituteInPlace Settings.cpp \
      --replace-fail \"SDRplay \"SDRplay2
  '';

  cmakeFlags = [
    "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/"
  ];

  meta = with lib; {
    description = "Soapy SDR module for SDRplay (legacy)";
    homepage = "https://github.com/pothosware/SoapySDRPlay2";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
