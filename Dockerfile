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
COPY ./bin/kokoboya/Resources ./resources

COPY ./certs/cert.p12 ./keystore.p12
COPY ./gc/keys ./keys
COPY ./gc/data ./data

RUN apt-get update
RUN apt-get -y install tini

COPY --from=build /gc/grasscutter-*.jar ./grasscutter.jar

EXPOSE 443/tcp 22102/udp
ENTRYPOINT ["/usr/bin/tini", "--", "java", "-jar", "/gc/grasscutter.jar"]
