{ stdenv, lib, hugo, baseurl ? null}:

let
  terminal = fetchGit {
    url = "https://github.com/panr/hugo-theme-terminal";
    rev = "2b14b3d4e5eab53aa45647490bb797b642a82a59";
  };
  themeName = ((builtins.fromTOML (builtins.readFile "${terminal}/theme.toml")).name);


in
stdenv.mkDerivation {
          name = "silmar-site";
          pname = "silmar-website";
          version = "2023-03-20";
          src = ./src/.;
          nativeBuildInputs = [ hugo ];
          configurePhase = ''
            mkdir -p "themes/terminal"
            cp -r ${terminal}/* "themes/${themeName}"
          '';
          buildPhase = ''
            hugo ${lib.optionalString (baseurl != null) "--baseurl ${baseurl}"}
          '';
          installPhase = "cp -r public $out";
}
