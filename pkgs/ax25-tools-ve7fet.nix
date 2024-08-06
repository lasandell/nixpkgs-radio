{ stdenv, lib, fetchFromGitHub, autoreconfHook, libax25-ve7fet, zlib }:

stdenv.mkDerivation rec {
  pname = "ax25-tools-ve7fet";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "ve7fet";
    repo = "linuxax25";
    rev = "ax25tools-${version}";
    sha256 = "sha256-EKCL/z/oqFRbpuuqGyjkvAAAZY8WKxn/0DQdWdZr8Us=";
  };

  sourceRoot = "source/ax25tools";

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libax25-ve7fet zlib ];

  postPatch = ''
    substituteInPlace pathnames.h --replace 'AX25_SYSCONFDIR"' '"/etc/ax25/'
    substituteInPlace pathnames.h --replace 'AX25_LOCALSTATEDIR"' '"/var/ax25/'
  '';

  meta = with lib; {
    description = "Non-GUI tools used to configure an AX.25 enabled computer (ve7fet fork)";
    homepage = "https://github.com/ve7fet/linuxax25";
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
  };
}
