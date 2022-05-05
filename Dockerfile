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

COPY ./gc ./
RUN chmod +x gradlew && ./gradlew jar

FROM openjdk:18-slim-buster
WORKDIR /gc

RUN apt-get update
RUN apt-get -y install tini

COPY ./bin/dimbreath/TextMap ./resources/TextMap
COPY ./bin/dimbreath/Subtitle ./resources/Subtitle
COPY ./bin/dimbreath/Readable ./resources/Readable
COPY ./bin/radioegor/2.5.52/Data/_BinOutput ./resources/BinOutput
COPY ./bin/dimbreath/ExcelBinOutput ./resources/ExcelBinOutput

# add fixed excels
COPY ./bin/*ExcelConfigData.json ./resources/ExcelBinOutput/

COPY ./certs/cert.p12 ./keystore.p12
COPY ./gc/keys ./keys
COPY ./gc/data ./data

COPY --from=build /gc/grasscutter-*.jar ./grasscutter.jar

EXPOSE 443/tcp 22102/udp
ENTRYPOINT ["/usr/bin/tini", "--", "java", "-jar", "/gc/grasscutter.jar"]
