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

        fennelVersions = [
          "stable"
          "unstable"
        ];

        luaVersions = [
          "lua5_1"
          "lua5_2"
          "lua5_3"
          "lua5_4"
          "luajit"
        ];

        inherit (pkgs.lib) listToAttrs cartesianProductOfSets;

        buildPackageSet = { builder, args }:
          listToAttrs (map builder args);
      in
      {
        devShells =
          (buildPackageSet {
            builder = pkgs.mkTestShell;
            args = cartesianProductOfSets {
              fennelVersion = fennelVersions;
              luaVersion = luaVersions;
            };
          }) // {
            ci-check-format = pkgs.mkShell {
              buildInputs = [
                pkgs.fennel-luajit
                pkgs.fnlfmt-unstable
              ];
            };
            ci-generate-docs = pkgs.mkShell {
              buildInputs = [
                pkgs.fennel-luajit
                pkgs.fenneldoc
              ];
            };
            default =
              let
                fennel = pkgs.fennel-unstable-lua5_3;
              in
              pkgs.mkShell {
                buildInputs = [
                  fennel
                  pkgs.faith-unstable
                  pkgs.fnlfmt-unstable
                  pkgs.fenneldoc
                  pkgs.fennel-ls
                ] ++ (with fennel.lua.pkgs; [
                  # NOTE: lua5_4.pkgs.readline is currently broken.
                  readline
                ]);
                FENNEL_PATH = "${pkgs.faith-unstable}/bin/?";
              };
          };
      });
}
