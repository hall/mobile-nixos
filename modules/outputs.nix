{ config, lib, ... }:

let
  inherit (lib)
    mkOption
  ;
in
{
  options = {
    mobile = {
      outputs = {
        default = mkOption {
          description = ''
            Default most likely desired output for this Mobile NixOS build.

            The default depends on the system type in use.
          '';
          # Mark internal so that the documentation does not expose a bogus description.
          internal = true;
        };
      };
    };
  };
}
