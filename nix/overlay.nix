{ inputs }:

final: prev: {
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
          -e 's|\./fennel|lua fennel|'
    '';
    makeFlags = [
      "PREFIX=$(out)"
    ];
  };
  fenneldoc = final.stdenv.mkDerivation rec {
    pname = "fenneldoc";
    version = "1.0.1-dev";
    src = inputs.fenneldoc;
    nativeBuildInputs = [
      final.luajit
      final.luajit.pkgs.fennel
    ];
    postPatch = ''
      sed -i Makefile -e 's|\./fenneldoc|lua fenneldoc|'
    '';
    makeFlags = [
      "VERSION=${version}"
      "PREFIX=$(out)"
    ];
  };
  fnlfmt = final.stdenv.mkDerivation {
    pname = "fnlfmt";
    version = "0.3.2-dev";
    src = inputs.fnlfmt;
    nativeBuildInputs = [
      final.luajit
      final.luajit.pkgs.fennel
    ];
    patches = [
      ./patches/fnlfmt.patch
    ];
    postPatch = ''
      sed -i Makefile -e 's|./fennel|lua fennel|'
    '';
    makeFlags = [ "PREFIX=$(out)" ];
  };
}
