ARG gradle_version=jdk17
ARG keycloak_version=26.6.2

FROM gradle:${gradle_version} AS build

ARG keycloak_version

WORKDIR /app

COPY . .

RUN gradle assemble -Pdependency.keycloak.version=${keycloak_version}

FROM quay.io/keycloak/keycloak:${keycloak_version}

COPY --from=build /app/build/libs/*.jar /opt/keycloak/providers/
