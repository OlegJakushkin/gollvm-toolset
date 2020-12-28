clean:
	docker rm $(docker ps -aq)
	docker rmi -f gollvm:latest || true

gollvm:
	docker build -t gollvm:latest -f Dockerfile .

gollvm-native:
	./hack/build_gollvm.sh