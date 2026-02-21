{ pkgs, ... }:
{
  imports = [
    ./home.nix
    ./direnv.nix
    ./font.nix
    ./fastfetch.nix
    ./fzf.nix
    ./git.nix
    ./lsd.nix
    ./neovim.nix
    ./vscode.nix
    ./wezterm.nix
    ./yazi.nix
    ./zsh.nix
  ];
  home = {
    username = "nico";
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/nico" else "/home/nico";
    packages = with pkgs; [ ];
    stateVersion = "25.11";
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
}
