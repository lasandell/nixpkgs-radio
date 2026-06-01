pkgs:

pkgs.mkShell {
  shellHook = ''
    export PATH=${pkgs.soapysdr}/bin:$PATH
    export SOAPY_SDR_ROOT=${pkgs.soapysdr}
  '';
}