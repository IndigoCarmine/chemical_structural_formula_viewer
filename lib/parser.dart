import 'package:chemical_structural_formula_viewer/elements.dart';
import 'package:xml/xml.dart';

T2? _try<T1, T2>(T2? Function(T1) f, T1? x) => x == null ? null : f(x);

//  cml parser
StructurePage? parseCml(String xml) {
  var document = XmlDocument.parse(xml);
  var fragments = <Fragment>[];
  var pageBoundingBox = BoundingBox(0, 0, 0, 0);
  for (var mol in document.findAllElements('molecule')) {
    var atoms = mol.findElements('atomArray').first.childElements;
    var bonds = mol.findAllElements('bondArray').first.childElements;
    var atomList = <Atom>[];
    var bondList = <Bond>[];
    var molBoundingBox = BoundingBox(0, 0, 0, 0);
    for (var atom in atoms) {
      String? textId = atom.getAttribute('id');
      if (textId == null) return null;
      int id = int.tryParse(textId.substring(1)) ?? 0;
      double x = _try(double.tryParse, atom.getAttribute('x2')) ?? 0.0;
      double y = _try(double.tryParse, atom.getAttribute('y2')) ?? 0.0;
      String atomLabel = atom.getAttribute('elementType') ?? "None";
      molBoundingBox
        ..height = molBoundingBox.height < y ? molBoundingBox.height : y
        ..width = molBoundingBox.width > x ? molBoundingBox.width : x;

      Atom a = Atom(atomLabel, id, x, y);

      a.numHgens = _try(int.tryParse, atom.getAttribute('hydrogenCount')) ?? 0;

      atomList.add(a);
    }
    for (var bond in bonds) {
      var atoms = bond.getAttribute('atomRefs2')?.split(' ') ?? ['a0', 'a0'];
      var beginAtom = int.tryParse(atoms[0].substring(1)) ?? 0;
      var endAtom = int.tryParse(atoms[1].substring(1)) ?? 0;
      var bondStyle = switch (bond.getAttribute('order')) {
        "1" => BondStyle.single,
        "2" => BondStyle.double,
        "3" => BondStyle.triple,
        _ => BondStyle.single
      };

      bondList.add(Bond(bondStyle, beginAtom, endAtom));
    }
    fragments.add(Fragment(
        name: mol.getAttribute('title') ?? "None",
        atoms: atomList.toSet(),
        bonds: bondList.toSet(),
        boundingBox: molBoundingBox));
    pageBoundingBox
      ..height = pageBoundingBox.height < molBoundingBox.height
          ? pageBoundingBox.height
          : molBoundingBox.height
      ..width = pageBoundingBox.width > molBoundingBox.width
          ? pageBoundingBox.width
          : molBoundingBox.width;
  }
  return StructurePage(
      name: "CML", fragments: fragments.toSet(), boundingBox: pageBoundingBox);
}

String a = '''
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE CDXML SYSTEM "http://www.cambridgesoft.com/xml/cdxml.dtd" >
<CDXML
 CreationProgram="ChemDraw 22.2.0.3300"
 Name="untitled.cdxml"
 BoundingBox="175.71 127.54 232.29 192.86"
 WindowPosition="0 0"
 WindowSize="-1718026240 0"
 WindowIsZoomed="yes"
 FractionalWidths="yes"
 InterpretChemically="yes"
 ShowAtomQuery="yes"
 ShowAtomStereo="no"
 ShowAtomEnhancedStereo="yes"
 ShowAtomNumber="no"
 ShowResidueID="no"
 ShowBondQuery="yes"
 ShowBondRxn="yes"
 ShowBondStereo="no"
 ShowTerminalCarbonLabels="no"
 ShowNonTerminalCarbonLabels="no"
 HideImplicitHydrogens="no"
 LabelFont="3"
 LabelSize="18"
 LabelFace="1"
 CaptionFont="20"
 CaptionSize="18"
 CaptionFace="1"
 HashSpacing="3.40"
 MarginWidth="2.83"
 LineWidth="4.25"
 BoldWidth="4.25"
 BondLength="29.99"
 BondSpacing="12"
 ChainAngle="120"
 LabelJustification="Auto"
 CaptionJustification="Left"
 AminoAcidTermini="HOH"
 ShowSequenceTermini="yes"
 ShowSequenceBonds="yes"
 ShowSequenceUnlinkedBranches="no"
 ResidueWrapCount="40"
 ResidueBlockCount="10"
 PrintMargins="36 36 36 36"
 MacPrintInfo="00030000012C012C000000000D3E093AFFC5FFC50D7909750367057B03E000020000012C012C000000000D3E093A000100000064000000010001010100020001270F000100010000000000000000000000000002001901900000000000600000000000000000000100000000000000000000000000000000"
 ChemPropName=""
 ChemPropFormula="Chemical Formula: "
 ChemPropExactMass="Exact Mass: "
 ChemPropMolWt="Molecular Weight: "
 ChemPropMOverZ="m/z: "
 ChemPropAnalysis="Elemental Analysis: "
 ChemPropBoilingPt="Boiling Point: "
 ChemPropMeltingPt="Melting Point: "
 ChemPropCritTemp="Critical Temp: "
 ChemPropCritPres="Critical Pres: "
 ChemPropCritVol="Critical Vol: "
 ChemPropGibbs="Gibbs Energy: "
 ChemPropLogP="Log P: "
 ChemPropMR="MR: "
 ChemPropHenry="Henry&apos;s Law: "
 ChemPropEForm="Heat of Form: "
 ChemProptPSA="tPSA: "
 ChemPropCLogP="CLogP: "
 ChemPropCMR="CMR: "
 ChemPropLogS="LogS: "
 ChemPropPKa="pKa: "
 ChemPropID=""
 ChemPropFragmentLabel=""
 color="1"
 bgcolor="0"
 RxnAutonumberStart="1"
 RxnAutonumberConditions="no"
 RxnAutonumberStyle="Roman"
 RxnAutonumberFormat="(#)"
><colortable>
<color r="0" g="0" b="0"/>
<color r="1" g="1" b="1"/>
<color r="1" g="0" b="0"/>
<color r="1" g="1" b="0"/>
<color r="0" g="1" b="0"/>
<color r="0" g="1" b="1"/>
<color r="0" g="0" b="1"/>
<color r="1" g="0" b="1"/>
</colortable><fonttable>
<font id="3" charset="iso-8859-1" name="Arial"/>
<font id="20" charset="iso-8859-1" name="Times New Roman"/>
</fonttable><page
 id="2069"
 BoundingBox="0 0 523.20 769.92"
 HeaderPosition="36"
 FooterPosition="36"
 PrintTrimMarks="yes"
 HeightPages="1"
 WidthPages="1"
><fragment
 id="2053"
 BoundingBox="175.71 127.54 232.29 192.86"
 Z="4"
><n
 id="2050"
 p="178.03 145.20"
 Z="1"
 AS="N"
/><n
 id="2052"
 p="178.03 175.20"
 Z="3"
 AS="N"
/><n
 id="2054"
 p="204 190.19"
 Z="5"
 AS="N"
/><n
 id="2056"
 p="229.97 175.20"
 Z="7"
 AS="N"
/><n
 id="2058"
 p="229.97 145.20"
 Z="9"
 AS="N"
/><n
 id="2060"
 p="204 130.21"
 Z="11"
 AS="N"
/><b
 id="2062"
 Z="13"
 B="2050"
 E="2052"
 Order="2"
 BS="N"
 BondCircularOrdering="2067 0 0 2063"
/><b
 id="2063"
 Z="14"
 B="2052"
 E="2054"
 BS="N"
/><b
 id="2064"
 Z="15"
 B="2054"
 E="2056"
 Order="2"
 BS="N"
 BondCircularOrdering="2063 0 0 2065"
/><b
 id="2065"
 Z="16"
 B="2056"
 E="2058"
 BS="N"
/><b
 id="2066"
 Z="17"
 B="2058"
 E="2060"
 Order="2"
 BS="N"
 BondCircularOrdering="2065 0 0 2067"
/><b
 id="2067"
 Z="18"
 B="2060"
 E="2050"
 BS="N"
/></fragment></page></CDXML>
''';

//cdxml parser
StructurePage? parseCdxml(String xml) {
  var document = XmlDocument.parse(xml);
  var fragments = <Fragment>[];
  var xmlfragments = document.findAllElements('fragment');

  for (var fragment in xmlfragments) {
    var atoms = fragment.findElements('n');
    var bonds = fragment.findElements('b');
    var atomList = <Atom>[];
    var bondList = <Bond>[];
    for (var atom in atoms) {
      String? textId = atom.getAttribute('id');
      if (textId == null) return null;
      int id = int.tryParse(textId) ?? 0;
      double x =
          _try(double.tryParse, atom.getAttribute('p')?.split(' ')[0]) ?? 0.0;
      double y =
          _try(double.tryParse, atom.getAttribute('p')?.split(' ')[1]) ?? 0.0;
      String atomLabel = atom.getAttribute('AS') ?? "None";
      Atom a = Atom(atomLabel, id, x, y);

      atomList.add(a);
    }
    for (var bond in bonds) {
      var beginAtom = _try(int.tryParse, bond.getAttribute('B')) ?? 0;
      var endAtom = _try(int.tryParse, bond.getAttribute('E')) ?? 0;
      var bondStyle = switch (bond.getAttribute('Order')) {
        "1" => BondStyle.single,
        "2" => BondStyle.double,
        "3" => BondStyle.triple,
        _ => BondStyle.single
      };

      bondList.add(Bond(bondStyle, beginAtom, endAtom));
    }

    List a = _try(double.tryParse,
            fragment.getAttribute('BoundingBox')?.split(' ')) ??
        [0, 0, 0, 0];
    fragments.add(Fragment(
        name: fragment.getAttribute('id') ?? "None",
        atoms: atomList.toSet(),
        bonds: bondList.toSet(),
        boundingBox: Boun));
  }
  return StructurePage(
      name: "CDXML",
      fragments: fragments.toSet(),
      boundingBox: BoundingBox(0, 0, 0, 0));
}
