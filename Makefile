clean:
	docker rmi gollvm:latest || true

gollvm:
	docker build -t gollvm:latest -f Dockerfile .

gollvm-native:
	./hack/build_gollvm.sh