{ src, stdenv, lua, pandoc }:

stdenv.mkDerivation rec {
  pname = "fennel";
  version = "1.4.1-dev";

  inherit src;

  nativeBuildInputs = [
    lua
    pandoc
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

  postBuild = ''
    patchShebangs .
  '';

  passthru = { inherit lua; };
}
