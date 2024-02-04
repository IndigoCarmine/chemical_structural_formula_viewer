class Atom {
  String atomLabel;
  int numHgens;
  int id;

  double x;
  double y;

  Atom(this.atomLabel, this.id, this.x, this.y, {this.numHgens = 0});

  @override
  String toString() {
    return 'Atom{atomLabel: $atomLabel, id: $id, x: $x, y: $y}';
  }
}

enum BondStyle { single, double, triple }

class Bond {
  BondStyle bondStyle;

  int biginAtom;
  int endAtom;

  Bond(this.bondStyle, this.biginAtom, this.endAtom);

  @override
  String toString() {
    return 'Bond{biginAtom: $biginAtom, endAtom: $endAtom}';
  }
}

class BoundingBox {
  double x;
  double y;
  double width;
  double height;

  BoundingBox(this.x, this.y, this.width, this.height);

  @override
  String toString() {
    return 'BoundingBox{x: $x, y: $y, width: $width, height: $height}';
  }
}

class Fragment {
  String name;
  Set<Atom> atoms;
  Set<Bond> bonds;

  BoundingBox boundingBox;

  Fragment(
      {required this.name,
      required this.atoms,
      required this.bonds,
      required this.boundingBox});

  @override
  String toString() {
    return 'Fragment{name: $name, atoms: $atoms, bonds: $bonds}';
  }
}

class StructurePage {
  String name;
  Set<Fragment> fragments;

  BoundingBox boundingBox;

  StructurePage(
      {required this.name, required this.fragments, required this.boundingBox});

  @override
  String toString() {
    return 'StructurePage{name: $name, fragments: $fragments}';
  }
}
