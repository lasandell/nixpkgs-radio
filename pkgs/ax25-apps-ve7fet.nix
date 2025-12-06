{ stdenv, lib, fetchFromGitHub, autoreconfHook, libax25, ncurses }:

stdenv.mkDerivation rec {
  pname = "ax25-apps-ve7fet";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "ve7fet";
    repo = "linuxax25";
    rev = "ax25apps-${version}";
    sha256 = "sha256-w/sTXSKw1MVVcZL/bwwGGy4SCxLzD+4HfCxpilN2A+s=";
  };

  sourceRoot = "source/ax25apps";

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libax25 ncurses ];

  postPatch = ''
    substituteInPlace pathnames.h \
      --replace-fail 'AX25_SYSCONFDIR"' '"/etc/ax25/' \
      --replace-fail 'AX25_LOCALSTATEDIR"' '"/var/ax25/'
  '';

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=implicit-function-declaration"
  ];

  meta = with lib; {
    description = "AX.25 ham radio applications (ve7fet fork)";
    homepage = "https://linux-ax25.in-berlin.de/wiki/Main_Page";
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
  };
}
