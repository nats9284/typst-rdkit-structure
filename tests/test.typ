#import "../src/rdkitstructure.typ":*

#draw_molecule("c1cc(O)ccc1")


#draw_molecule("c1cc(O)ccc1", show_opt: "{\"width\":150, \"height\":150}")
#draw_molecule("[H]C", mol_opt: "{\"removeHs\":false}")

#draw_reaction("[CH3:1][OH:2]>>[CH2:1]=[OH0:2]")
#draw_reaction("[CH3:1][OH:2]>>[CH2:1]=[OH0:2]", show_opt: "{\"width\":150, \"height\":150}")

#let asperin =read("../examples/Aspirin.smi")
#draw_molecule(asperin)

#draw_molecule("C12=C3C4=C5C6=C1C7=C8C9=C1C%10=C%11C(=C29)C3=C2C3=C4C4=C5C5=C9C6=C7C6=C7C8=C1C1=C8C%10=C%10C%11=C2C2=C3C3=C4C4=C5C5=C%11C%12=C(C6=C95)C7=C1C1=C%12C5=C%11C4=C3C3=C5C(=C81)C%10=C23")
#let fullerenes=read("../examples/fullerenes.sdf")
#draw_molecule(fullerenes)

