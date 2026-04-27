IMAGE ?= registry.gregdev.dev/library/mosquitto-exporter
VERSION := $(shell grep -E 'Version\s*=\s*"' version.go | sed -E 's/.*"([^"]+)".*/\1/')

.PHONY: version build push release

version:
	@echo $(VERSION)

build:
	docker build -t $(IMAGE):$(VERSION) -t $(IMAGE):latest .

push:
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest

release: build push
