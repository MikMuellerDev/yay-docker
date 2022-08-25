repository := mikmuellerdev/yay
tag := yay_v11.3.0_libalpm_v13.0.1

latest-tag:
	docker run -it \
		$(repository):latest \
		--version | sed -e 's/ /_/g; s/-//g; s/__/_/g'

docker:
	docker build \
		-t $(repository):$(tag) \
		-t $(repository):latest .

docker-push:
	docker push $(repository):$(tag)
	docker push $(repository):latest
