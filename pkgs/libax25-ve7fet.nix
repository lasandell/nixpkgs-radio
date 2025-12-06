{ stdenv, lib, fetchFromGitHub, autoreconfHook, zlib }:

stdenv.mkDerivation rec {
  pname = "libax25-ve7fet";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "ve7fet";
    repo = "linuxax25";
    rev = "libax25-${version}";
    sha256 = "sha256-5fGknA53JwmQk5/ak46J6v5aOwd/Na0oW7kfD6dGUdQ=";
  };

  sourceRoot = "source/libax25";

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ zlib ];

  postPatch = ''
      substituteInPlace pathnames.h \
      --replace-fail 'AX25_SYSCONFDIR"' '"/etc/ax25/'
  '';

  meta = with lib; {
    description = "AX.25 library for ham radio applications (ve7fet fork)";
    homepage = "https://github.com/ve7fet/linuxax25";
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
  };
}
