{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fennel-tools = {
      url = "github:m15a/flake-fennel-tools";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, fennel-tools, ... }:
    let
      overlay = import ./nix/overlay.nix;
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            fennel-tools.overlays.default
            overlay
          ];
        };

        mkTestShell = { faith }:
          pkgs.mkShell {
            buildInputs = [
              faith
              faith.fennel
            ];
            FENNEL_PATH = "${faith}/bin/?";
          };

        luaVersions = [
          "luajit"
          "lua5_1"
          "lua5_2"
          "lua5_3"
          "lua5_4"
        ];

        inherit (pkgs.lib) listToAttrs mapAttrs nameValuePair;
      in
      {
        devShells = (mapAttrs
          (_: l: mkTestShell { faith = pkgs."faith-stable-${l}"; })
          (listToAttrs
            (map (l: nameValuePair "ci-test-stable-${l}" l) luaVersions))) // {
          ci-lint = pkgs.mkShell {
            buildInputs = [
              pkgs.fennel-stable-luajit
              pkgs.fnlfmt
            ];
          };

          default =
            let
              fennel = pkgs.fennel-unstable-lua5_3;
              faith = pkgs.faith-unstable-lua5_3;
            in
            pkgs.mkShell {
              buildInputs = [
                fennel
                faith
                pkgs.fnlfmt
                pkgs.fenneldoc
              ] ++ (with fennel.lua.pkgs; [
                # NOTE: lua5_4.pkgs.readline is currently broken.
                readline
              ]);
              FENNEL_PATH = "${faith}/bin/?";
            };
        };
      });
}
