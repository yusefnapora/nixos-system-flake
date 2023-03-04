{ lib, nixosConfig, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isAarch64 isLinux;

  cfg = nixosConfig.yusef.obs;

  asahi-wrapper = pkgs.symlinkJoin {
    name = "obs";
    paths = [ pkgs.obs-studio ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/obs \
        --set "MESA_GL_VERSION_OVERRIDE" "3.3" \
        --set "MESA_GLES_VERSION_OVERRIDE" "3.0" \
        --set "MESA_GLSL_VERSION_OVERRIDE" "330"
    '';
  };

  isAsahi = (isAarch64 && isLinux);
  obs-package = if isAsahi then asahi-wrapper else pkgs.obs-studio;
in {
  config = mkIf cfg.enable {

    programs.obs-studio = {
      enable = true;
      package = obs-package;
    }; 

    home.packages = [
      # also install shotcut video editor for simple edits
      pkgs.shotcut

      # and the obs-cli utility so we can script things
      pkgs.yusef.obs-cli
    ];

  };
}
