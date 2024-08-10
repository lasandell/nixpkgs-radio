{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, soapysdr, libusb }:

stdenv.mkDerivation rec {
  pname = "libmirisdr5";
  version = "unstable-2024-06-20";

  src = fetchFromGitHub {
    owner = "ericek111";
    repo = "libmirisdr-5";
    rev = "78a874b30a4c3161251b8e12ffb6443f29005eb3";
    sha256 = "sha256-uOaBDTEEaRlWZvWMttJ86xEOK+UFYGA+PTd5E3spFuE=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libusb ];

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    cp ../mirisdr.rules $out/lib/udev/rules.d
  '';

  meta = with lib; {
    description = "Library for interfacing with SDRPlay";
    homepage = "https://github.com/ericek111/libmirisdr-5";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
