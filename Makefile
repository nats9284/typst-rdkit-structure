VERSION := $(shell grep '^version' typst.toml | awk -F ' = ' '{print $$2}' | tr -d '"')

release_wasm :
	cd rdkit_interface; \
	make -f Makefile_release rdkit-structure.wasm

debug_wasm :
	cd rdkit_interface; \
	make -f Makefile_debug rdkit-structure.wasm


format:
	cd rdkit_interface; \
	make  -f Makefile_debug format

link :
	mkdir -p ~/.cache/typst/packages/preview/rdkit-cffi
	rm -rf ~/.cache/typst/packages/preview/rdkit-cffi/$(VERSION)
	ln -s "$(CURDIR)" ~/.cache/typst/packages/preview/rdkit-cffi/$(VERSION)

module :
	mkdir -p ./rdkit-structure
	mkdir -p ./rdkit-cffi/rdkit_interface
	mkdir -p ./rdkit-cffi/src
	cp ./rdkit_interface/rdkit-structure.wasm ./rdkit-cffi/rdkit_interface/rdkit-structure.wasm
	cp ./rdkit_interface/protocol.typ ./rdkit-cffi/rdkit_interface/protocol.typ
	cp ./src/*.typ ./rdkit_interface/src/
	cp ./lib.typ ./rdkit-structure/lib.typ
	cp ./README.md ./rdkit-structure/README.md
	cp ./typst.toml ./rdkit-structure/typst.toml
	cp ./LICENSE ./rdkit-structure/LICENSE

clean : clean-link
	cd rdkit_interface; \
	make  -f Makefile_debug clean

clean-link:
	rm -rf ~/.cache/typst/packages/preview/rdkit-structure

wasi-stub:
	git clone https://github.com/typst-community/wasm-minimal-protocol.git
	cd wasm-minimal-protocol; \
	git checkout wasi-stub-0.3.0; \
	cd crates/wasi-stub ; \
	cargo build --release 

wasmpg:
	git clone -n --depth=1 --filter=tree:0 https://github.com/Robotechnic/WebAssembly-protocol-generator.git
	cd WebAssembly-protocol-generator; \
	cargo build --release

manual: wasm
	typst compile --root . ./doc/manual.typ
