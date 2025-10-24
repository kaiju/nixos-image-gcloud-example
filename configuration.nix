{ lib, ... }:
{

  networking.hostName = "example";
  system.stateVersion = "25.11";

  nix.settings = {
    experimental-features = "nix-command flakes";
  };

  # Google Compute image builder-specific configuration
  image.modules.google-compute = {
    # Give us an easily predictable image filename so CI is less of a chore
    image.baseName = "image";
  };

  /*
    oslogin's NSS plugin causes nscd/nsncd segfaults when resolving group IDs to a Google identity.
    Typically this manifests as an inability to sudo and long pauses for any process that attempts to resolve
    a group ID.

    https://github.com/NixOS/nixpkgs/issues/218813
    https://github.com/GoogleCloudPlatform/guest-oslogin/issues/33
    https://github.com/GoogleCloudPlatform/guest-oslogin/issues/90

    As a workaround, we just remove oslogin from the group enties in nsswitch.conf
  */
  system.nssDatabases.group = lib.mkForce [
    "files"
    "systemd"
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

}
