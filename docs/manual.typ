## Usage

### Basic usage

Importing the module:

```typ
#import "@preview/rdkit-structure:0.1.0": *
```


#### Drawing molecules

You can draw molecules using the `render_molecule` function:

**NOTE:** [typed-smiles](https://github.com/GeronimoCastano/typed-smiles), and [molchemist](https://github.com/rice8y/molchemist) are more convenient for converting SMILES/MOL/SDF to svg, so I recommend using them.
I usually use molchemist and typed-smiles, and I use this plugin only  when some of the valid SMILES is not accepted in those plugins.

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

Using read() function, you can draw structures from smi or sdf file as follows

```
#render_molecule(read("aspirin.smi"))

#render_molecule(read("Conformer3D_COMPOUND_CID_2244.sdf"))
```


For more information about the specification of SMILES notation, you can check the [Daylight SMILES official documentation](http://www.daylight.com/dayhtml/doc/theory/theory.smiles.html).

The input option and drawing option is same as RDKit-cffi function arguments.
Original cffi api usage (https://github.com/rdkit/rdkit/blob/master/Code/MinimalLib/cffi_test.c) might help you.



**NOTE: ** rdkit-structure outputs elements highlighted svg by default. If you want to disable highlighting, use other plugins.

Wedged bond in Trigonal-bipyramidal (`@TB`), octahedral (`@OH`), and allenal (`@AL`) is available in this plugin, but it may cause some bugs.

#### Drawing reaction schemes
You can draw Reaction SMILES (RXNSMILES) and Reaction SDF using the `render_reaction` function:


```typst
//template
#render_reaction("reactant '>' agent '>' product")
```
```

```

```typst
#render_reaction("[CH3:1][OH:2]>>[CH2:1]=[OH0:2]")
#render_reaction("[CH3:1][OH:2]>>[CH2:1]=[OH0:2]")
```

rdkit-structure doesn't supports reverse reaction and caption of reaction condition.
The typst package [typed-smiles](https://github.com/GeronimoCastano/typed-smiles) has more option writing reaction schemas.


