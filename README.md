# whs's nix flakes
This repository contains various flake that I use

## Usage

First, enable nix flakes if you haven't:

```sh
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Then in your flake, add this repository

```nix
{
	inputs = {
		whs.url = "github:whs/nix";
	}
}
```

## Packages
### readsb
Available as standalone packages or as NixOS module.

Tested to be working on x86_64 or cross compiled to Raspberry Pi 1B/B+ (armv6hf)

#### Package options

* history: Build with history support (default: true)
* rtlsdr: Build with RTL-SDR support (default: true)
* plutosdr: Build with PlutoSDR support (default: true)
* biastee: Build with Bias Tee support (default: true)

#### NixOS options

* services.readsb.enable: Whether readsb is enabled. This also automatically configure your system for RTL-SDR (default: false)
* services.readsb.package: Which readsb package to use
* services.readsb.options: Command line argument to readsb as a set (default: same as upstream Debian default options)
* services.readsb.openFirewallOutput: Whether output firewall ports (30002, 30003, 30005) should be opened (default: true)
* services.readsb.openFirewallInput: Whether input firewall ports (30001, 30004, 30104) should be opened (default: false)

## License
[The MIT License](LICENSE)
