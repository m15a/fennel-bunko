{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fennel = {
      url = "sourcehut:~technomancy/fennel/main";
      flake = false;
    };
    fenneldoc = {
      url = "git+https://github.com/Olical/fenneldoc?submodules=1";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... } @ inputs:
  let
    overlay = final: prev: {
      fennel = final.stdenv.mkDerivation rec {
        pname = "fennel";
        version = "1.4.1-dev";
        src = inputs.fennel;
        nativeBuildInputs = [
          final.lua5_3
          final.pandoc
        ];
        postPatch = ''
          # FIXME: maninst function and run ./fennel do not work.
          sed -i Makefile \
              -e 's|$(call maninst,$(doc),$(DESTDIR)$(MAN_DIR)/$(doc))|$(shell mkdir -p $(dir $(DESTDIR)$(MAN_DIR)$(doc)) && cp $(doc) $(DESTDIR)$(MAN_DIR)/$(doc))|' \
              -e 's|\./fennel|lua ./fennel|'
        '';
        makeFlags = [
          "PREFIX=$(out)"
        ];
      };
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
            fennel
            fenneldoc
          ] ++ (with lua5_3.pkgs; [
            readline
          ]);
        };
      });
}
