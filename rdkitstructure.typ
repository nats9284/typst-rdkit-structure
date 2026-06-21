#let plugin = plugin("rdkit-structure.wasm")

#let draw_molecule(text) = {
	let render = str(plugin.render_molecule(bytes(text)))
  image(
    bytes(output.at(svg),
    format: "svg",
    width: 350pt,
    height: 300pt,
  )
