{
  lib, pkgs, stdenv, rustPlatform
}:
let
	version = "2.46.1";

	opsAgentSrc = pkgs.fetchFromGitHub {
		owner = "GoogleCloudPlatform";
		repo = "ops-agent";
		rev = "tags/${version}";
		hash = "sha256-yJerH48T7hj03wekodqYI/LMMZBtR9fKT8keK/hATkM=";
	};
in rec {
	ops-agent-go = pkgs.buildGoModule {
		pname = "google-ops-agent";
		inherit version;
		src = opsAgentSrc;
		vendorHash = "sha256-dsDyMNduxQq+mIWLz2WuExwvVLlsBRLoS2snzJIJXus=";
		subPackages = ["cmd/agent_wrapper" "cmd/google_cloud_ops_agent_diagnostics" "cmd/google_cloud_ops_agent_engine"];
	};
}
