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
    return 'Bond{biginAtom: $biginAtom, endAtom: $endAtom, bondStyle: $bondStyle}';
  }
}

class BoundingBox {
  double x;
  double y;
  double width;
  double height;

  BoundingBox(this.x, this.y, this.width, this.height);

  BoundingBox.fromDoublelist(List<double> list)
      : x = list[0],
        y = list[1],
        width = list[2],
        height = list[3];

  @override
  String toString() {
    return 'BoundingBox{x: $x, y: $y, width: $width, height: $height}';
  }

  //return a new BoundingBox that is the result of adding this BoundingBox to another BoundingBox (union of the two BoundingBoxes)
  BoundingBox operator +(BoundingBox other) {
    double x = this.x < other.x ? this.x : other.x;
    double y = this.y < other.y ? this.y : other.y;
    double width = (this.x + this.width) > (other.x + other.width)
        ? (this.x + this.width) - x
        : (other.x + other.width) - x;
    double height = (this.y + this.height) > (other.y + other.height)
        ? (this.y + this.height) - y
        : (other.y + other.height) - y;
    return BoundingBox(x, y, width, height);
  }

  BoundingBox copyWith() {
    return BoundingBox(x, y, width, height);
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
