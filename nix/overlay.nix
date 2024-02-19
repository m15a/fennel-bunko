final: prev:

{
  faith = prev.faith.overrideAttrs (_: {
    patches = [ ./patches/faith.patch ];
  });

  fnlfmt = prev.fnlfmt.overrideAttrs (_: {
    patches = [ ./patches/fnlfmt.patch ];
  });
}
