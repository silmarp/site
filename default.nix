{ stdenv, lib, hugo, baseurl ? null}:

let
  terminal = fetchGit {
    url = "https://github.com/panr/hugo-theme-terminal";
    rev = "c7770bc85ec6754adcb7f5fbe09867c1890ecc19";
  };
  themeName = ((builtins.fromTOML (builtins.readFile "${terminal}/theme.toml")).name);


in
stdenv.mkDerivation {
          name = "silmar-site";
          pname = "silmar-website";
          version = "2025-02-22";
          src = ./src/.;
          nativeBuildInputs = [ hugo ];
          configurePhase = ''
            mkdir -p "themes/${themeName}"
            cp -r ${terminal}/* "themes/${themeName}"
          '';
          buildPhase = ''
            hugo ${lib.optionalString (baseurl != null) "--baseurl ${baseurl}"}
          '';
          installPhase = "cp -r public $out";
}
