import 'package:chemical_structural_formula_viewer/elements.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:math';

extension Vector2Ex on Vector2 {
  //angle when v2 rotate to x axis
  double angle({Vector2? refVec}) {
    if (refVec == null) return atan2(y, x);
    return atan2(y, x) - atan2(refVec.y, refVec.x);
  }
}

extension BondEx on Bond {
  Atom bAtom(Set<Atom> atoms) =>
      atoms.firstWhere((element) => beginAtom == element.id);
  Atom eAtom(Set<Atom> atoms) =>
      atoms.firstWhere((element) => endAtom == element.id);

  Vector2 bPos(Set<Atom> atoms) => Vector2(bAtom(atoms).x, bAtom(atoms).y);
  Vector2 ePos(Set<Atom> atoms) => Vector2(eAtom(atoms).x, eAtom(atoms).y);

  Vector2 bondVector(Set<Atom> atoms) => ePos(atoms) - bPos(atoms);

  void fixDoubleBondPosision(Set<Atom> atoms, Set<Bond> bonds) {
    if (bondStyle.bondType == BondType.single) return;
    var bondVector = this.bondVector(atoms);
    var atomsUporDown = bonds.where((element) {
      //get only the bonds that are connected to the current bond
      if (element == this) return false;
      return element.beginAtom == beginAtom ||
          element.endAtom == beginAtom ||
          element.beginAtom == endAtom ||
          element.endAtom == endAtom;
    }).map((anotherBond) {
      //get the atoms that are connected to the current bond
      Vector2 anotherBondVector = anotherBond.bondVector(atoms);
      if (anotherBond.endAtom == beginAtom || anotherBond.endAtom == endAtom) {
        anotherBondVector = -anotherBondVector;
      }

      var angle = anotherBondVector.angleTo(bondVector);
      if (angle >= 0) {
        return 1;
      } else {
        return -1;
      }
    }).reduce((value, element) => value + element);

    switch (atomsUporDown) {
      case < 0:
        bondStyle.bondPosition = BondPosition.left;
        break;
      case 0:
        bondStyle.bondPosition = BondPosition.center;
        break;
      case > 0:
        bondStyle.bondPosition = BondPosition.right;
        break;
    }
    // bondStyle.bondPosition = BondPosition.left;
  }
}
