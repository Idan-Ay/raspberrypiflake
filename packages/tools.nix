{pkgs, lib, ...}:
{
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  programs.git.enable = true;
  programs.neovim.enable = true;

  programs.java = {
    enable = true;
    package = pkgs.javaPackages.compiler.temurin-bin.jre-25;
  };

  environment.systemPackages = lib.mkAfter (with pkgs; [
      gh
  ]);
}
