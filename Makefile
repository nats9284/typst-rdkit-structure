VERSION := $(shell grep '^version' typst.toml | awk -F ' = ' '{print $$2}' | tr -d '"')

release_wasm :
	cd rdkit_interface; \
	make -f Makefile_release rdkit-structure.wasm

debug_wasm :
	cd rdkit_interface; \
	make -f Makefile_debug rdkit-structure.wasm


format :
	cd rdkit_interface; \
	make  -f Makefile_debug format


clean :
	cd rdkit_interface; \
	make  -f Makefile_debug clean

pkg :
	mkdir -p ./pkg
	mkdir -p ./pkg/rdkit_interface
	mkdir -p ./pkg/src
	mkdir -p ./pkg/examples
	cp ./rdkit_interface/rdkit-structure.wasm ./pkg/rdkit_interface/
	cp ./src/*.typ ./pkg/src/
	cp ./examples/*.smi ./pkg/examples/
	cp ./examples/*.sdf ./pkg/examples/
	cp ./lib.typ ./pkg/lib.typ
	cp ./README.md ./pkg/README.md
	cp ./typst.toml ./pkg/typst.toml
	cp ./LICENSE ./pkg/LICENSE

wasi-stub :
	git clone https://github.com/typst-community/wasm-minimal-protocol.git
	cd wasm-minimal-protocol; \
	git checkout wasi-stub-0.3.0; \
	cd crates/wasi-stub ; \
	cargo build --release 

test: wasm
	typst compile --root . ./tests/test.typ
