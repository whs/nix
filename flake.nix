{
	outputs = { self, nixpkgs, flake-utils }: {
		nixosModules.readsb = import ./readsb/module.nix;
		nixosModules.crisp-status-local = import ./crisp-status-local/module.nix;
	} // flake-utils.lib.eachDefaultSystem (system: 
		let
			pkgs = import nixpkgs { inherit system; };
			stdenv = pkgs.stdenv;
			lib = pkgs.lib;
		in {
			packages = pkgs.callPackage ./default.nix {};
		}
	);
}
