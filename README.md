This README is modified from original work by [Robotechnic/diagraph/README.md](https://github.com/Robotechnic/diagraph/README.md)

# rdkit-structure

A simple RDKit binding for Typst using the WebAssembly plugin system.
This plugin uses [RDKit's cffi wrapper](https://github.com/rdkit/rdkit) internally.
RDKit-cffi supports many chemical formats, and they provide substructure search using SMARTS, and  not only visualize chemical structure, 
Thanks to RDKit developers
Robotechnic

## Usage

### Basic usage

This plugin is quite simple to use, you just need to import it:

```typ
#import "@preview/rdkit-structure:0.1.0": *
```


#### Draw molecules

You can draw molecules using the `render_molecule` function:

```typ
#render_molecule("Oc1ccccc1", "")
```


For more information about the specification of SMILES notation, you can check the [official documentation](http://www.daylight.com/dayhtml/doc/theory/theory.smiles.html).

You can use sdf format also.
#render_molecule("")


#### Draw reaction schemes
You can draw reaction using the `render_reaction` function:


```typ
#render_reaction("[CH3:1][OH:2]>>[CH2:1]=[OH0:2]", "")
```


## Build

This project was built with emscripten `3.1.46`.
Before building, you just need to set PATH environmental variable.

```bash
source <path-to-emsdk>/emsdk_env.sh
```
Apart from that, you just need to run `make wasm` to build the wasm file. All libraries are downloaded and built automatically to get the right version that works.

There are also some other make commands:

- `make link`: Link the project to the typst plugin folder
- `make clean`: Clean the build folder and the link
- `make clean-link`: Only clean the link
- `make module`: It copy the files needed to run the plugin in a folder called `graphviz` in the current directory
- `make manual`: Generate the manual pdf
- `make wasi-stub`: Build the wasi stub executable, it require a rust toolchain properly configured

### Wasi stub

Some functions need to be stubbed to work with the webassembly plugin system. The `wasi-stub` executable is a special one fitting the needs of the typst plugin system. You can find the source code [here](https://github.com/typst-community/wasm-minimal-protocol/tree/master). It is important to use this one as the default subbed functions are not the same and the makefile is suited for this one.


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Log
### 0.1.0

Initial working version
