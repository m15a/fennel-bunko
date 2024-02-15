{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fenneldoc = {
      url = "git+https://github.com/Olical/fenneldoc?submodules=1";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... } @ inputs:
  let
    overlay = final: prev: {
      fenneldoc = final.stdenv.mkDerivation rec {
        pname = "fenneldoc";
        version = "1.0.1";
        src = inputs.fenneldoc;
        buildInputs = [
          final.lua5_4
          final.lua5_4.pkgs.fennel
        ];
        postPatch = ''
          sed -i Makefile -e 's|\./fenneldoc|lua ./fenneldoc|'
        '';
        makeFlags = [
          "VERSION=${version}"
          "PREFIX=$(out)"
        ];
      };
    };
  in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            fenneldoc
          ] ++ (with lua.pkgs; [
            fennel
            readline
          ]);
        };
      });
}
