#let plugin_base = plugin("../rdkit_interface/rdkit-structure.wasm")

// In this file Typst internal function that change elements symbol to arbitrary symbol, is implemented.
// for example, overlaying elements Cl of c1ccccc1[Cl] (chlorobenzene) to X is c1ccccc1X (halogenized benzene).
//

#let get_bond_coords(svg) ={
  plugin_base.get_bond_coords

}

