#
# Copyright (c) 2022 chiya.dev
#
# Use of this source code is governed by the MIT License
# which can be found in the LICENSE file and at:
#
#   https://opensource.org/licenses/MIT
#
# This Dockerfile compiles Grasscutter and all required resources into a single
# self-contained Docker image.
#
# NOTE: alpine does not work: https://github.com/google/protobuf-gradle-plugin/issues/265
FROM openjdk:18-slim-buster as build
WORKDIR /gc

# build grasscutter
COPY ./gc ./
RUN chmod +x gradlew && ./gradlew jar

FROM openjdk:18-slim-buster
WORKDIR /gc

# add resources first: allow docker to cache this layer for reuse
COPY ./bin/dimbreath/TextMap ./resources/TextMap
COPY ./bin/dimbreath/Subtitle ./resources/Subtitle
COPY ./bin/dimbreath/Readable ./resources/Readable
COPY ./bin/radioegor/2.5.52/Data/_BinOutput ./resources/BinOutput
COPY ./bin/dimbreath/ExcelBinOutput ./resources/ExcelBinOutput
COPY ./bin/losttree/DecompiledLua/Lua ./resources/Scripts

# add fixed excels
COPY ./bin/*ExcelConfigData.json ./resources/ExcelBinOutput/

RUN \
  apt-get update && \
  apt-get -y install tini locales && \
  rm -rf /var/lib/apt/lists/*

# https://stackoverflow.com/a/28406007
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

COPY ./certs/cert.p12 ./keystore.p12
COPY ./gc/keys ./keys
COPY ./gc/data ./data

COPY --from=build /gc/grasscutter-*.jar ./grasscutter.jar

ENV \
  LANG="en_US.UTF-8" \
  LANGUAGE="en_US:en" \
  LC_ALL="en_US.UTF-8"

EXPOSE 443/tcp 22102/udp
ENTRYPOINT ["/usr/bin/tini", "--", "java", "-jar", "/gc/grasscutter.jar"]
