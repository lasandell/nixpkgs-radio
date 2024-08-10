pkgs:

let
  pluginPath = pkg: "${pkg}/${pkgs.soapysdr.passthru.searchPath}";
in
pkgs.mkShell {
  shellHook = ''
    export PATH=${pkgs.soapysdr}/bin:$PATH
    export SOAPY_SDR_ROOT=${pkgs.soapysdr}
    export SOAPY_SDR_PLUGIN_PATH=${pluginPath pkgs.soapysdrplay2}
  '';
}