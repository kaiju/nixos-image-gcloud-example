# NixOS Image Building for Google Cloud Compute Engine

The only thing better than having declarative configuration management as a first class feature of your OS is leveraging it to build deployable images from your system configuration. No more hacking together Ansible and Packer or shoving overwrought shell scripts into cloud-init!

NixOS provides [modules](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/image/images.nix) that can be used to build a variety of images. In this example we'll use the [`google-compute`](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/google-compute-image.nix) module to build an image suitable for deploying on Google Cloud.

## Building

On NixOS:
```
# nixos-rebuild build-image --flake '.#example' --image-variant google-compute
```

Alternatively with Nix on other Linux environments:
```
# nix build '.#nixosConfigurations.example.config.system.build.images.google-compute'
```

Upload image result to GCS:

```
# gcloud storage cp result/image.raw.tar.gz gs://<bucket>/
```

Create new Compute Engine image:

```
gcloud compute images create nixos-example-image --source-uri gs://<bucket>/image.raw.tar.gz
```

## Cloud Build

The image build & publish process can also be automated with Cloud Build. `cloudbuild.yaml` is a pipeline that creates a Nix builder, builds the system image, uploads it to GCS, and creates a new image in Compute Engine.

```
gcloud builds submit . --substitutions="_BUCKET=<bucket>,SHORT_SHA=$(git rev-parse --short HEAD)"
```

