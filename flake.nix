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
			packages = {
				readsb = pkgs.callPackage ./readsb/package.nix {};
				crisp-status-local = pkgs.callPackage ./crisp-status-local/package.nix {};
				google-ops-agent = (pkgs.callPackage ./google-ops-agent/package.nix {}).ops-agent-go;
			};
		}
	);
}
