# rdkit-structure

A simple RDKit binding for Typst using the WebAssembly plugin system.
You can draw a chemical structure easily by Writing SMILES string or importing smi or sdf file.


## Acknowledgements
This plugin uses [RDKit](https://github.com/rdkit/rdkit) internally.
This project would not have been possible without the valuable work of the RDKit community.
Big Thanks to the contributors of RDKit.
This project includes portions of a Makefile copied and modified from [diagraph] (https://github.com/Robotechnic/diagraph), which is licensed under the MIT License. The original copyright notice has been preserved.

## Usage

### Basic usage

This plugin is quite simple to use, you just need to import it:

```typ
#import "@preview/rdkit-structure:0.1.0": *
```


#### Drawing molecules

You can draw molecules using the `render_molecule` function:

[typed-smiles](https://github.com/GeronimoCastano/typed-smiles), and [molchemist](https://github.com/rice8y/molchemist) are faster and efficient for only converting SMILES/MOL/SDF to svg, so if you want to use it, please do!
Unlike these plugins, rdkit-structure outputs elements highlighted svg by default.

Wedged bond in Trigonal-bipyramidal (`@TB`), octahedral (`@OH`), and allenal (`@AL`) is not available in this plugin now.

This plugin supports Molblock, SDF, SMILES (including OpenSMILES chirality classes), reaction SMILES/SMARTS as an input format.




```typ
#render_molecule("Oc1ccccc1")
```

```typ
#render_molecule( "\n\
  Mrv2311 05242408162D          \n\
\n\
  0  0  0     0  0            999 V3000\n\
M  V30 BEGIN CTAB\n\
M  V30 COUNTS 14 15 0 0 0\n\
M  V30 BEGIN ATOM\n\
M  V30 1 C 2.0006 -1.54 0 0\n\
M  V30 2 N 2.0006 -3.08 0 0\n\
M  V30 3 C 0.6669 -3.85 0 0\n\
M  V30 4 C -0.6668 -3.08 0 0\n\
M  V30 5 C -0.6668 -1.54 0 0\n\
M  V30 6 C -2.0006 -0.77 0 0\n\
M  V30 7 C 0.6669 -0.77 0 0\n\
M  V30 8 C 0.6669 0.77 0 0\n\
M  V30 9 C -0.6668 1.54 0 0\n\
M  V30 10 C -2.0006 0.77 0 0\n\
M  V30 11 C -0.6668 3.08 0 0\n\
M  V30 12 C 0.6669 3.85 0 0\n\
M  V30 13 C 2.0006 3.08 0 0\n\
M  V30 14 C 2.0006 1.54 0 0\n\
M  V30 END ATOM\n\
M  V30 BEGIN BOND\n\
M  V30 1 1 1 2\n\
M  V30 2 2 2 3\n\
M  V30 3 1 3 4\n\
M  V30 4 2 4 5\n\
M  V30 5 1 5 6\n\
M  V30 6 1 7 5 CFG=3\n\
M  V30 7 2 7 1\n\
M  V30 8 1 7 8\n\
M  V30 9 2 8 9\n\
M  V30 10 1 9 10\n\
M  V30 11 1 9 11\n\
M  V30 12 2 11 12\n\
M  V30 13 1 12 13\n\
M  V30 14 2 13 14\n\
M  V30 15 1 8 14\n\
M  V30 END BOND\n\
M  V30 END CTAB\n\
M  END\n")



```
For more information about the specification of SMILES notation, you can check the [Daylight SMILES official documentation](http://www.daylight.com/dayhtml/doc/theory/theory.smiles.html).

The input option and drawing option is same as RDKit-cffi function arguments.
Original cffi api usage (https://github.com/rdkit/rdkit/blob/master/Code/MinimalLib/cffi_test.c) might help you.

#### Drawing reaction schemes
You can draw Reaction SMILES (RXNSMILES) using the `render_reaction` function:


```
``` template
reactant '>' agent '>' product
```
```

```typ
#render_reaction("[CH3:1][OH:2]>>[CH2:1]=[OH0:2]")
#render_reaction("[CH3:1][OH:2]>>[CH2:1]=[OH0:2]")
```

rdkit-structure doesn't supports reverse reaction and caption of reaction condition.
The typst package [typed-smiles](https://github.com/GeronimoCastano/typed-smiles) has more option writing reaction schemas.

#### Substituting Atom's Symbols
You can draw reaction using the `render_reaction` function:


```typ
#render_reaction("[CH3:1][OH:2]>>[CH2:1]=[OH0:2]")
```


### Error Handling
"plugin panicked: unreachable function executed" error means failed to parse SMILES 
Maybe your SMILES or SDF file is invalid.

### Why is error message lacking of readability?
Since WASI call is stubbed by [wasi-stub](https://github.com/typst-community/wasm-minimal-protocol/tree/master), plugin can't output the log.


## Building from source
### prerequisites

- CMake version<=3.29 required
Building with CMake 4 cause an error because it builds library as shared library.
So you should use Cmake whose version is or less than 3.29.

- Pkg-config

- [Emscripten](https://github.com/emscripten-core/emscripten)


This project was built with Emscripten `5.0.7`.
```bash
Before building, you just need to set PATH environmental variable
source <path-to-emsdk>/emsdk_env.sh

- Wasi stub

Some functions need to be stubbed for compatibility with the WebAssembly plugin system.
The [wasi-stub](https://github.com/typst-community/wasm-minimal-protocol/tree/master)  executable is specifically designed for the Typst plugin system.


You just need to run `build.sh` to build the wasm file. All libraries are downloaded and built automatically.

There are also some other make commands:

- `make clean`: Clean the build folder and the link
- `make test`: Generate the test pdf

##Contributing
Feel free to asking usage/technical questions or submit issues.
Contributions and feature requests are absolutely welcome.
###Features that may be added in the future:

- Changing elements symbol to arbitrary symbols
  For example: represents halogenized benzene by substituting symbol an element Cl of c1ccccc1[Cl]  (chlorobenzene) into X.
               represents tertiary amin by substituting on elements C of "C(C)N(C)" (trimethyl amin) into  R_1, R_2, R_3.

- Optimize the instantiation of module using wizer.h

- Format svg to ACS 1996 style



## License


Portions of this Makefile are copied and modified from [Robotechnic/diagraph/Makefile](https://github.com/Robotechnic/diagraph/tree/main/Makefile)].

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Log
### 0.1.0

Initial working version
