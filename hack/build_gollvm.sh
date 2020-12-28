#!/bin/bash

git clone https://github.com/llvm/llvm-project.git

LLVM_SRC_PATH=llvm-project/llvm
GOLLVM_SRC_PATH=$LLVM_SRC_PATH/tools/gollvm

git clone https://go.googlesource.com/gollvm $LLVM_SRC_PATH/tools
git clone https://go.googlesource.com/gofrontend $GOLLVM_SRC_PATH/gofrontend

git clone https://github.com/libffi/libffi.git $GOLLVM_SRC_PATH/libgo/libffi
git clone https://github.com/ianlancetaylor/libbacktrace.git $GOLLVM_SRC_PATH/libgo/libbacktrace


BUILD_DIR=llvm-project/release
mkdir -p $BUILD_DIR && cd $BUILD_DIR
cmake ../llvm -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_ENABLE_ASSERTIONS=On -DLLVM_ENABLE_RTTI=On -DLLVM_USE_LINKER=gold -G Ninja
ninja gollvm -j8 && ninja install-gollvm
