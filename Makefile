.PHONY: rmz-image
rmz-image:
	docker build -t ghcr.io/profclems/rmz:latest ./storagenode/rmz

.PHONEY: push-rmz-image
push-rmz-image:
	docker push ghcr.io/profclems/rmz:latest
