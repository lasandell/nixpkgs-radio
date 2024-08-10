{ config, pkgs, ... }:

let
  pluginPath = pkg: "${pkg}/${pkgs.soapysdr.passthru.searchPath}";
in {
  services.udev.packages = [ pkgs.libmirisdr5 ];

  environment.variables = {
    SOAPY_SDR_PLUGIN_PATH = pluginPath pkgs.soapymiri;
  };
}
