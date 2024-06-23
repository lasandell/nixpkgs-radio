{ stdenv, lib, fetchFromGitHub, atk, cairo, fpc, gdk-pixbuf, glib, gtk2,
  lazarus, openssl, pango, patchelf, xorg }:

stdenv.mkDerivation rec {
  pname = "cqrprop";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "ok2cqr";
    repo = "cqrprop";
    rev = "v${version}";
    sha256 = "sha256-yG2BTaz51fK1rp0Pu/BpoTqB5IO0U9QtTL3N1WgCHI8=";
  };

  nativeBuildInputs = [ fpc lazarus ];

  buildInputs = [ atk cairo gdk-pixbuf glib gtk2 openssl pango xorg.libX11 ];

  makeFlags = [ "DESTDIR=$(out)" ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'CC=lazbuild' 'CC=lazbuild --lazarusdir=${lazarus}/share/lazarus' \
      --replace-fail '/usr/' '/'

    # See https://github.com/ok2cqr/cqrprop/issues/4
    substituteInPlace src/fShowPropForm.pas \
      --replace-fail 'http://www.hamqsl.com/solar2.php' 'https://www.hamqsl.com/solar2.php'
    substituteInPlace src/fOptions.pas \
      --replace-fail 'http://www.hamqsl.com/solar2.php' 'https://www.hamqsl.com/solar2.php'
  '';

  postFixup = ''
    # Add libraries including dynamically loaded openssl
    patchelf --set-rpath "${lib.makeLibraryPath buildInputs}" $out/bin/cqrprop
  '';

  meta = with lib; {
    description = "Display radio propagation data on your desktop";
    homepage = https://github.com/ok2cqr/cqrprop;
    license = licenses.gpl2;
    platforms = platforms.linux;
    mainProgram = "cqrprop";
  };
}