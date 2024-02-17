import 'package:chemical_structural_formula_viewer/extention.dart';
import 'package:vector_math/vector_math_64.dart';

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

  Atom copyWith() {
    return Atom(atomLabel, id, x, y, numHgens: numHgens);
  }
}

enum BondType { single, double, triple }

enum BondPosition { center, left, right }

class BondStyle {
  BondType bondType;
  BondPosition bondPosition;
  BondStyle(
      {this.bondType = BondType.single,
      this.bondPosition = BondPosition.center});
  @override
  String toString() {
    return 'BondStyle{bondType: $bondType, bondLength: $bondPosition}';
  }
}

class Bond {
  BondStyle bondStyle;

  int beginAtom;
  int endAtom;

  Bond(this.bondStyle, this.beginAtom, this.endAtom);

  @override
  String toString() {
    return 'Bond{beginAtom: $beginAtom, endAtom: $endAtom, bondStyle: $bondStyle}';
  }

  Bond copyWith() {
    return Bond(bondStyle, beginAtom, endAtom);
  }

  bool get isSingleBond => bondStyle.bondType == BondType.single;
  bool get isDoubleBond => bondStyle.bondType == BondType.double;
  bool get isTripleBond => bondStyle.bondType == BondType.triple;
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

  void fixBondPosition() {
    for (var bond in bonds) {
      if (bond.bondStyle.bondType == BondType.single) continue;
      var atom1 = bond.bAtom(atoms);
      var atom2 = bond.eAtom(atoms);
      var bondVector = bond.bondVector(atoms);
      var atomsUporDown = bonds.where((element) {
        //get only the bonds that are connected to the current bond
        if (element == bond) return false;
        return element.beginAtom == bond.beginAtom ||
            element.endAtom == bond.beginAtom ||
            element.beginAtom == bond.endAtom ||
            element.endAtom == bond.endAtom;
      }).map((anotherBond) {
        print('e: $anotherBond');

        //get the atoms that are connected to the current bond
        Vector2 anotherBondVector = anotherBond.bondVector(atoms);
        if (anotherBond.endAtom == bond.beginAtom ||
            anotherBond.endAtom == bond.endAtom) {
          anotherBondVector = -anotherBondVector;
        }

        var angle = anotherBondVector.angleTo(bondVector);
        print('angle: $angle');
        if (angle >= 0) {
          return 1;
        } else {
          return -1;
        }
      }).reduce((value, element) => value + element);

      switch (atomsUporDown) {
        case < 0:
          bond.bondStyle.bondPosition = BondPosition.right;
          break;
        case 0:
          bond.bondStyle.bondPosition = BondPosition.center;
          break;
        case > 0:
          bond.bondStyle.bondPosition = BondPosition.left;
          break;
      }
      // bond.bondStyle.bondPosition = BondPosition.left;
    }
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
