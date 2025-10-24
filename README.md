# NixOS Image Building for Google Cloud Compute Engine

NixOS provides several modules that can be used to build images from system configurations. The `google-compute` image builder can be used to build images for Google Cloud Compute Engine.

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

The image build & publish process can also be automated with Cloud Build. `cloudbuild.yaml` is an example pipeline that creates a Nix builder, builds the system image, uploads it to GCS, and creates a new image in Compute Engine.

```
gcloud --project fulcra-artifacts builds submit . --substitutions="_BUCKET=<bucket>,SHORT_SHA=$(git rev-parse --short HEAD)"
```

