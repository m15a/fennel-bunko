{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fennel = {
      url = "sourcehut:~technomancy/fennel/main";
      flake = false;
    };
    fenneldoc = {
      url = "gitlab:andreyorst/fenneldoc/master";
      flake = false;
    };
    fnlfmt = {
      url = "sourcehut:~technomancy/fnlfmt/main";
      flake = false;
    };
    faith = {
      url = "sourcehut:~technomancy/faith/main";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... } @ inputs:
  let
    overlay = import ./nix/overlay.nix { inherit inputs; };
  in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
        mkTestShell = { fennel, faith }:
        pkgs.mkShell {
          buildInputs = [ fennel faith ];
          FENNEL_PATH = "${faith}/bin/?";
        };
      in
      {
        devShells = rec {
          ci-test-luajit = mkTestShell {
            fennel = pkgs.fennel.luajit;
            faith = pkgs.faith.luajit;
          };
          ci-test-lua5_1 = mkTestShell {
            fennel = pkgs.fennel.lua5_1;
            faith = pkgs.faith.lua5_1;
          };
          ci-test-lua5_2 = mkTestShell {
            fennel = pkgs.fennel.lua5_2;
            faith = pkgs.faith.lua5_2;
          };
          ci-test-lua5_3 = mkTestShell {
            fennel = pkgs.fennel.lua5_3;
            faith = pkgs.faith.lua5_3;
          };
          ci-test-lua5_4 = mkTestShell {
            fennel = pkgs.fennel.lua5_4;
            faith = pkgs.faith.lua5_4;
          };
          ci-lint = pkgs.mkShell {
            buildInputs = [ pkgs.fnlfmt ];
          };

          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              fennel.default
              faith.default
              fnlfmt
              fenneldoc
            ] ++ (with lua5_3.pkgs; [
              # NOTE: lua5_3.pkgs.readline is currently broken.
              readline
            ]);
            FENNEL_PATH = "${pkgs.faith.default}/bin/?";
          };
        };
      });
}
