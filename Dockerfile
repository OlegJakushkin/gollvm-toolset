FROM ubuntu:18.04

ENV TZ Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt install -y build-essential wget cmake git python3 ninja-build m4 libssl-dev

RUN wget https://github.com/Kitware/CMake/releases/download/v3.18.0/cmake-3.18.0.tar.gz && \
	tar -xvf cmake-3.18.0.tar.gz && mkdir cmake_build && cd cmake_build && \
	cmake ../cmake-3.18.0 && make && make install

WORKDIR /root/

ARG USING_PROXY
RUN if [ -z "$USING_PROXY" ] ; then \
	git clone https://github.com/llvm/llvm-project.git ; else \
	git clone https://mirrors.tuna.tsinghua.edu.cn/git/llvm-project.git ; fi

ENV LLVM_SRC_PATH=llvm-project/llvm
ENV GOLLVM_SRC_PATH=$LLVM_SRC_PATH/tools/gollvm

RUN if [ -n "$USING_PROXY" ] ; then \
	git config --global http.https://go.googlesource.com.proxy $USING_PROXY && \
	git config --global https.https://go.googlesource.com.proxy $USING_PROXY ; fi

ARG TIME_STAMP
RUN git clone https://go.googlesource.com/gollvm $LLVM_SRC_PATH/tools/gollvm
RUN git clone https://go.googlesource.com/gofrontend $GOLLVM_SRC_PATH/gofrontend

RUN git clone https://github.com/libffi/libffi.git $GOLLVM_SRC_PATH/libgo/libffi
RUN git clone https://github.com/ianlancetaylor/libbacktrace.git $GOLLVM_SRC_PATH/libgo/libbacktrace


ENV BUILD_DIR=llvm-project/release
RUN mkdir -p $BUILD_DIR && cd $BUILD_DIR && \
	cmake ../llvm -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_ENABLE_ASSERTIONS=On -DLLVM_ENABLE_RTTI=On -DLLVM_USE_LINKER=gold -G Ninja && \
	ninja gollvm && ninja install-gollvm && ninja install