.PHONY: clean build dep-tree test docker-build

UID := $(shell id -u)
GID := $(shell id -g)
KEYCLOAK_VERSION ?= 26.6.2
GRADLE_USER_HOME_DIR ?= $(CURDIR)/.gradle-user
DOCKER_GRADLE_BASE = docker run --rm --user "$(UID):$(GID)" \
	-e HOME=/var/gradle \
	-e GRADLE_USER_HOME=/var/gradle/.gradle \
	-v "$(CURDIR)":/workspace \
	-v "$(GRADLE_USER_HOME_DIR)":/var/gradle/.gradle \
	-w /workspace
DOCKER_GRADLE_IMAGE = gradle:jdk17
GRADLEW = ./gradlew --no-daemon -Pdependency.keycloak.version="$(KEYCLOAK_VERSION)"

clean:
	mkdir -p "$(GRADLE_USER_HOME_DIR)"
	$(DOCKER_GRADLE_BASE) $(DOCKER_GRADLE_IMAGE) $(GRADLEW) clean

build: clean
	mkdir -p "$(GRADLE_USER_HOME_DIR)"
	$(DOCKER_GRADLE_BASE) $(DOCKER_GRADLE_IMAGE) $(GRADLEW) build

dep-tree:
	mkdir -p "$(GRADLE_USER_HOME_DIR)"
	$(DOCKER_GRADLE_BASE) $(DOCKER_GRADLE_IMAGE) $(GRADLEW) dependencies --configuration compileClasspath

test:
	mkdir -p "$(GRADLE_USER_HOME_DIR)"
	$(DOCKER_GRADLE_BASE) $(DOCKER_GRADLE_IMAGE) $(GRADLEW) test

docker-build:
	docker build --build-arg keycloak_version="$(KEYCLOAK_VERSION)" -t keycloak-bcrypt .
