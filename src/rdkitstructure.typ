#let plugin_base = plugin("../rdkit_interface/rdkit-structure.wasm")

#let get_svg_slice(s) = {
  let start_matched = str(s).match("<svg")
  let end_matched = str(s).match("</svg>")
  if start_matched.len() == 0 {
    panic("Cannot find svg images")
  }
    let svg_slice = s.slice(start_matched.at("start"), end_matched.at("end"))
  return svg_slice
}
#let draw_molecule(mol_string, mol_opt: "", show_opt: "") = {
	let molsvg = get_svg_slice(str(plugin_base.render_molecule(bytes(mol_string), bytes(mol_opt), bytes(show_opt))))
  image(
    bytes(molsvg),
    format: "svg",
  )
}
#let draw_reaction(rxn_string, rxn_opt: "", show_opt: "") = {
	let molsvg = get_svg_slice(str(plugin_base.render_reaction(bytes(rxn_string), bytes(rxn_opt), bytes(show_opt))))
  image(
    bytes(molsvg),
    format: "svg",
  )
}

#let get_version() = {
	let version = str(plugin_base.get_version()
  return version
}
