clean:
	docker rmi gollvm:base
	docker rmi gollvm:latest

gollvm:
	docker build -t gollvm:latest -f Dockerfile .

gollvm-native:
	./hack/build_gollvm.sh