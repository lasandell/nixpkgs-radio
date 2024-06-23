{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, jansson, libxml2, zlib }:

stdenv.mkDerivation rec {
  pname = "libacars";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "szpajder";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2n1tuKti8Zn5UzQHmRdvW5Q+x4CXS9QuPHFQ+DFriiE=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ jansson libxml2 zlib ];

  postPatch = ''
    substituteInPlace libacars/libacars.pc.in --replace \
      'libdir=''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@' \
      'libdir=@CMAKE_INSTALL_FULL_LIBDIR@'
  '';

  meta = with lib; {
    description = "A library for decoding various ACARS message payloads";
    homepage = https://github.com/szpajder/libacars;
    changelog = "https://github.com/szpajder/libacars/blob/master/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
