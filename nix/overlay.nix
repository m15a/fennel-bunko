{ inputs }:

final: prev:

let
  fennelWith = { lua }:
  final.callPackage ./pkgs/fennel {
    src = inputs.fennel;
    inherit lua;
  };

  faithWith = { fennel }:
  final.callPackage ./pkgs/faith {
    src = inputs.faith;
    inherit fennel;
  };
in

rec {
  fennel = fennel-lua5_3;

  fennel-luajit = fennelWith { lua = final.luajit; };
  fennel-lua5_1 = fennelWith { lua = final.lua5_1; };
  fennel-lua5_2 = fennelWith { lua = final.lua5_2; };
  fennel-lua5_3 = fennelWith { lua = final.lua5_3; };
  fennel-lua5_4 = fennelWith { lua = final.lua5_4; };

  faith = faith-lua5_3;

  faith-luajit = faithWith { fennel = final.fennel-luajit; };
  faith-lua5_1 = faithWith { fennel = final.fennel-lua5_1; };
  faith-lua5_2 = faithWith { fennel = final.fennel-lua5_2; };
  faith-lua5_3 = faithWith { fennel = final.fennel-lua5_3; };
  faith-lua5_4 = faithWith { fennel = final.fennel-lua5_4; };

  fnlfmt = final.callPackage ./pkgs/fnlfmt {
    src = inputs.fnlfmt;
    lua = final.luajit;
  };

  fenneldoc = final.callPackage ./pkgs/fenneldoc {
    src = inputs.fenneldoc;
    lua = final.luajit;
  };
}
