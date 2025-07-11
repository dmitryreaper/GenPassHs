{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.haskellPackages.ghc
    pkgs.haskellPackages.cabal-install
    pkgs.gtk4
    pkgs.gobject-introspection
    pkgs.haskellPackages.gi-gtk
	pkgs.pkg-config
	pkgs.pcre2
	pkgs.expat
	pkgs.xorg.libXdmcp
	pkgs.mount
	pkgs.util-linux.dev
	pkgs.libselinux
	pkgs.libsepol
	pkgs.fribidi
	pkgs.libthai
    pkgs.libxml2
	pkgs.libdatrie
	pkgs.libadwaita
	pkgs.libsysprof-capture
	pkgs.lerc
	pkgs.appstream
	pkgs.glib

	#gtk3
	pkgs.libxkbcommon
	pkgs.libepoxy
	pkgs.xorg.libXtst
  ];

  shellHook = ''
    echo "Добро пожаловать в окружение разработки gi-gtk!"
  '';
}
