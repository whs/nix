{
  lib, stdenv,
  fetchFromGitHub,
  git, pkg-config, libusb1, ncurses, zlib, zstd, libiio, libad9361, librtlsdr,
  
  history ? true,
  rtlsdr ? true,
  plutosdr ? true,
  biastee ? true
}:
let
  # When updating version, make sure upstream do not edit Makefile or files in debian/
  version = "3.14.1604";
  sha256 = "sha256-4t8XQyKHJVbF3x9Y7/eT8AjzVw4MH/pWkIy34rEIN+U=";
in stdenv.mkDerivation {
  pname = "readsb";
  inherit version;
  src = fetchFromGitHub {
    owner = "wiedehopf";
    repo = "readsb";
    rev = "v${version}";
    inherit sha256;
  };

  outputs = [ "out" "man" ];

  patches = [
    # Patch the Makefile to use READSB_VERSION instead of calling git
    ./readsb-make.patch
  ];
  
  makeFlags = [
    "READSB_VERSION=${version}-nix-${sha256}"
  ]
    ++ lib.optionals history [ "HISTORY=yes" ]
    ++ lib.optionals plutosdr [ "PLUTOSDR=yes" ]
    ++ lib.optionals biastee [ "HAVE_BIASTEE=yes" ]
    ++ lib.optionals rtlsdr [ "RTLSDR=yes" "AIRCRAFT_HASH_BITS=15" ]
    ++ lib.optionals stdenv.hostPlatform.isAarch32 [ "CPPFLAGS=-DSC16Q11_TABLE_BITS=8" ];
  
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ncurses zlib zstd ]
    ++ lib.optionals plutosdr [ libiio libad9361 ]
    ++ lib.optionals rtlsdr [ librtlsdr ];
  propagatedBuildInputs = lib.optionals rtlsdr [ librtlsdr ];

  installPhase = ''
    mkdir -p $out/bin
    cp -a readsb $out/bin/readsb
    cp -a viewadsb $out/bin/viewadsb

    mkdir -p $man/share/man/man1
    cp debian/*.1 $man/share/man/man1/

    mkdir -p $man/share/doc/readsb/
    cp debian/README.* $man/share/doc/readsb/
  '';

  # https://github.com/NixOS/nixpkgs/issues/40797
  NIX_CFLAGS_LINK = "-lgcc_s";
  
  meta = {
    description = "Readsb is a Mode-S/ADSB/TIS decoder for RTLSDR, BladeRF, Modes-Beast and GNS5894 devices";
    homepage = "https://github.com/wiedehopf/readsb";
    license = lib.licenses.gpl3Plus;
    mainProgram = "readsb";
    platforms = lib.platforms.linux;
  };
}
