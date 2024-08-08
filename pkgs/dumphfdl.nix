{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, czmq, fftwFloat, glib, libacars,
  libconfig, liquid-dsp, pcre2, soapysdr-with-plugins, sqlite }:

stdenv.mkDerivation rec {
  pname = "dumphfdl";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "szpajder";
    repo = "dumphfdl";
    rev = "v${version}";
    hash = "sha256-M4WjcGA15Kp+Hpp+I2Ndcx+oBqaGxEeQLTPcSlugLwQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    czmq
    fftwFloat
    glib
    libacars
    libconfig
    liquid-dsp
    pcre2
    soapysdr-with-plugins
    sqlite
  ];

  cmakeFlags = [ "-DSOAPYSDR=ON" "-DSQLITE=ON" ];

  meta = with lib; {
    description = "Multichannel HFDL decoder";
    homepage = "https://github.com/szpajder/dumphfdl";
    changelog = "https://github.com/szpajder/dumphfdl/blob/master/CHANGELOG.md";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "dumphfdl";
  };
}
