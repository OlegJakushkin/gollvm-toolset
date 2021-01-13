clean:
	docker rm $(shell docker ps -aq)
	docker rmi -f gollvm:latest || true

gollvm:
	docker build -t gollvm:latest -f Dockerfile.gollvm .

gollvm-proxy:
	docker build -t gollvm:latest -f Dockerfile.gollvm . --build-arg USING_PROXY=$(USING_PROXY) --build-arg TIME_STAMP="$(shell date)"

gc:
	docker build -t gc:latest -f Dockerfile.gc .

gc-proxy:
	docker build -t gc:latest -f Dockerfile.gc . --build-arg USING_PROXY=$(USING_PROXY)

gollvm-native:
	./hack/build_gollvm.sh