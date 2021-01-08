clean:
	docker rm $(shell docker ps -aq)
	docker rmi -f gollvm:latest || true

gollvm:
	docker build -t gollvm:latest -f Dockerfile .

gollvm-proxy:
	docker build -t gollvm:latest -f Dockerfile . --build-arg USING_PROXY=$(USING_PROXY) --build-arg TIME_STAMP="$(shell date)"

gollvm-native:
	./hack/build_gollvm.sh