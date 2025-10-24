# syntax=docker/dockerfile:1
FROM nixos/nix

ENTRYPOINT ["nix", "--system-features", "kvm", "--extra-experimental-features", "nix-command flakes", "build"]
