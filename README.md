# Grassdocker

This repository provides a [Dockerfile][1] that can be used to build a completely self-contained Docker image for [Grasscutter][2]. It tracks the **development branch** and is confirmed to be working with Genshin 2.6.

The resulting image is about 1.4 GB in size and has:

- All required resources (bins, excels, etc.) baked into the image
- Fixed reliquary excels with weight props
- Proper image layering and multistaged build
- Proper TLS root and server certificates with DNS names for `mihoyo.com`, `yuanshen.com` and `hoyoverse.com`
- No unnecessary dependencies in the resulting image

I do not provide any prebuilt Docker image on Docker Hub at the moment.

## Building

1. Clone the repository with all required submodules.

```sh
git clone --recurse-submodules -j8 git@github.com:chiyadev/Grassdocker.git
```

2. Run the build script with the image name. "grassdocker" is provided as an example which can be changed.

```sh
./build.sh grassdocker
```

## Running

Running this Docker image is very simple. Refer to [this script](server.sh) or the [compose file](docker-compose.yaml) as an example.

## Connecting

1. Import the [root certificate](certs/root.pem) that comes with this repository into the client's trusted certificate authority store.

2. Follow the Grasscutter [connection guide][3] as usual.

[1]: https://docs.docker.com/engine/reference/builder/
[2]: https://github.com/Grasscutters/Grasscutter
[3]: https://github.com/Grasscutters/Grasscutter/wiki
