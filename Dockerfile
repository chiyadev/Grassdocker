FROM openjdk:18-alpine3.15 as build
WORKDIR /grasscutter

COPY . ./
RUN chmod +x gradlew && ./gradlew jar

FROM openjdk:18-alpine3.15
WORKDIR /grasscutter

COPY --from=build /grasscutter/Grasscutter ./Grasscutter

EXPOSE 443 22102
