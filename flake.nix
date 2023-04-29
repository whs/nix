{
	outputs = { self, nixpkgs, flake-utils }: {
		nixosModules.readsb = import ./readsb/module.nix;
	} // flake-utils.lib.eachDefaultSystem (system: 
		let
			pkgs = import nixpkgs { inherit system; };
			stdenv = pkgs.stdenv;
			lib = pkgs.lib;
		in {
			packages = {
				readsb = pkgs.callPackage ./readsb/package.nix {};
			};
		}
	);
}
