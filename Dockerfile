FROM openjdk:18-alpine3.15 as build
WORKDIR /grasscutter

COPY ./grasscutter ./

ENV GRADLE_OPTS="-Dfile.encoding=utf-8"
RUN chmod +x gradlew && ./gradlew jar

FROM openjdk:18-alpine3.15
WORKDIR /grasscutter

RUN apk add --no-cache tini

COPY ./bin/dimbreath/TextMap ./resources/TextMap
COPY ./bin/dimbreath/Subtitle ./resources/Subtitle
COPY ./bin/dimbreath/Readable ./resources/Readable
COPY ./bin/radioegor/2.5.52/Data/_BinOutput ./resources/BinOutput
COPY ./bin/dimbreath/ExcelBinOutput ./resources/ExcelBinOutput

COPY ./grasscutter/keys ./keys
COPY ./grasscutter/data ./data
COPY ./cert.p12 ./keystore.p12

COPY --from=build /grasscutter/grasscutter.jar ./grasscutter.jar

EXPOSE 443/tcp 22102/udp
ENTRYPOINT ["/sbin/tini", "--", "java", "-jar", "/grasscutter/grasscutter.jar"]
