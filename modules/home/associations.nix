{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.activation.elixirAssociations = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.duti}/bin/duti -s com.microsoft.VSCode exs all
    ''
  );
}
