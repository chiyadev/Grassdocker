# NOTE: alpine does not work: https://github.com/google/protobuf-gradle-plugin/issues/265
FROM openjdk:18-slim-buster as build
WORKDIR /grasscutter

COPY ./grasscutter ./

# ENV GRADLE_OPTS="-Dfile.encoding=utf-8"
RUN chmod +x gradlew && ./gradlew jar

FROM openjdk:18-slim-buster
WORKDIR /grasscutter

RUN apt-get update
RUN apt-get -y install tini

COPY ./bin/dimbreath/TextMap ./resources/TextMap
COPY ./bin/dimbreath/Subtitle ./resources/Subtitle
COPY ./bin/dimbreath/Readable ./resources/Readable
COPY ./bin/radioegor/2.5.52/Data/_BinOutput ./resources/BinOutput
COPY ./bin/dimbreath/ExcelBinOutput ./resources/ExcelBinOutput

# fixed excels
COPY ./bin/*ExcelConfigData.json ./resources/ExcelBinOutput/

COPY ./cert.p12 ./keystore.p12
COPY ./grasscutter/keys ./keys
COPY ./grasscutter/data ./data

COPY --from=build /grasscutter/grasscutter-*.jar ./grasscutter.jar

EXPOSE 443/tcp 22102/udp
ENTRYPOINT ["/usr/bin/tini", "--", "java", "-jar", "/grasscutter/grasscutter.jar"]
