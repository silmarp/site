{
  description = "A flake for my personal website using HUGO";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: 
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.website = pkgs.stdenv.mkDerivation rec {
          pname = "static-personal-website";
          version = "2023-03-20";
          src = ./src/.;
          nativeBuildInputs = [ pkgs.hugo ];
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
