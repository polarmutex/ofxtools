{
  description = "ofxtools";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  # TODO https://github.com/breuerfelix/highzer/blob/master/shell.nix (poetry2nix)

  outputs = { self, nixpkgs, ... }@inputs: inputs.flake-utils.lib.eachSystem [
    "x86_64-linux"
  ]
    (system:
      let pkgs = import nixpkgs {
        inherit system;
      };
      in
      {
        devShell = pkgs.mkShell rec {
          name = "ofxtools-prj";
          packages = with pkgs; [
            # python
            python3
            poetry
          ];
          nativeBuildInputs = [ pkgs.pkg-config ];
          DBUS_PATH = "${pkgs.dbus}";
          shellHook = ''
            export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib/
            source $(poetry env info --path)/bin/activate
          '';
        };
      });
}
