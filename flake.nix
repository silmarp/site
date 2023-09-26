{
  description = "A flake for my personal website using HUGO";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    terminal = {
      url = "github:panr/hugo-theme-terminal/2b14b3d4e5eab53aa45647490bb797b642a82a59";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, terminal }: 
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        themeName = ((builtins.fromTOML (builtins.readFile "${terminal}/theme.toml")).name);
      in
      {
        packages.website = pkgs.stdenv.mkDerivation rec {
          pname = "static-personal-website";
          version = "2023-03-20";
          src = ./src/.;
          nativeBuildInputs = [ pkgs.hugo ];
          configurePhase = ''
            mkdir -p "themes/terminal"
            cp -r ${terminal}/* "themes/${themeName}"
          '';
          buildPhase = "hugo";
          installPhase = "cp -r public $out";
        };
        defaultPackage = self.packages.${system}.website;
        devShell = pkgs.mkShell {
          packages = with pkgs; [
            hugo
          ];
        };
      }
    );
}
