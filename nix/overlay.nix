final: prev:

{
  faith = prev.faith.overrideAttrs (_: {
    patches = [ ./patches/faith.patch ];
  });

  faith-unstable = prev.faith-unstable.overrideAttrs (_: {
    patches = [ ./patches/faith.patch ];
  });

  fnlfmt = prev.fnlfmt.overrideAttrs (_: {
    patches = [ ./patches/fnlfmt.patch ];
  });

  fnlfmt-unstable = prev.fnlfmt-unstable.overrideAttrs (_: {
    patches = [ ./patches/fnlfmt.patch ];
  });
}
