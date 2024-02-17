import 'package:chemical_structural_formula_viewer/parser.dart';
import 'package:flutter_test/flutter_test.dart';

String benzeneCml = '''
<?xml version="1.0"?>
<molecule xmlns="http://www.xml-cml.org/schema">
<atomArray>
<atom elementType="C" id="a2050" x2="9.04071" y2="-7.37389"/>
<atom elementType="C" id="a2052" x2="9.04071" y2="-8.89689"/>
<atom elementType="C" id="a2054" x2="10.3597" y2="-9.65839"/>
<atom elementType="C" id="a2056" x2="11.6786" y2="-8.89689"/>
<atom elementType="C" id="a2058" x2="11.6786" y2="-7.37389"/>
<atom elementType="C" id="a2060" x2="10.3597" y2="-6.61239"/>
</atomArray>
<bondArray>
<bond atomRefs2="a2050 a2052" id="b2062" order="2"/>
<bond atomRefs2="a2052 a2054" id="b2063" order="1"/>
<bond atomRefs2="a2054 a2056" id="b2064" order="2"/>
<bond atomRefs2="a2056 a2058" id="b2065" order="1"/>
<bond atomRefs2="a2058 a2060" id="b2066" order="2"/>
<bond atomRefs2="a2060 a2050" id="b2067" order="1"/>
</bondArray>
</molecule>
''';

void main() {
  test('parseCml', () {
    var page = parseCml(benzeneCml);
    expect(page, isNotNull);
    var fragment = page!.fragments.first;
    expect(fragment.atoms.length, 6);
    expect(fragment.bonds.length, 6);
  });
}
