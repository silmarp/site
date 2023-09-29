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
        packages = rec {
          silmar-website = pkgs.callPackage ./default.nix {};
          default = silmar-website;
        };

        devShells = { 
          default = pkgs.mkShell {
            packages = with pkgs; [
              hugo
            ];
          };
        };
      }
    );
}
