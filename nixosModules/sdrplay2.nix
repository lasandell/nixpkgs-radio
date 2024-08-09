{ config, pkgs, ... }:

let
  pluginPath = pkg: "${pkg}/${pkgs.soapysdr.passthru.searchPath}";
in {
  services.udev.packages = [ pkgs.sdrplay2 ];

  environment.variables = {
    SOAPY_SDR_PLUGIN_PATH = pluginPath pkgs.soapysdrplay2;
  };
}
