{ pkgs, ... }:

let
  pluginPath = pkg: "${pkg}/${pkgs.soapysdr.passthru.searchPath}";
in {
  services.sdrplayApi.enable = true;

  environment.variables = {
    SOAPY_SDR_PLUGIN_PATH = pluginPath pkgs.soapysdrplay;
  };
}
