import 'dart:ui';

import 'package:vector_math/vector_math_64.dart' show Vector2, Matrix2;
import 'package:chemical_structural_formula_viewer/elements.dart';
import 'package:flutter/material.dart';

class StructureViewer extends StatefulWidget {
  const StructureViewer({super.key, this.page});

  final StructurePage? page;

  @override
  State<StructureViewer> createState() => _StructureViewerState();
}

class _StructureViewerState extends State<StructureViewer> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: StructurePainter(widget.page),
        child: SizedBox(
          width: 300,
          height: 300,
        ));
  }
}

class StructurePainter extends CustomPainter {
  StructurePainter(this.page);

  final StructurePage? page;
  @override
  void paint(Canvas canvas, Size size) {
    //test paint

    if (page == null) {
      print('page is null');
      return;
    }
    var xScale = size.width / page!.boundingBox.width;
    var yScale = size.height / page!.boundingBox.height;
    print('xScale: $xScale yScale: $yScale');

    _drawLines(canvas, xScale, yScale, 4);

    const fontSize = 20.0;
    for (var fragment in page!.fragments) {
      for (var atom in fragment.atoms) {
        if (atom.atomLabel == 'C') continue;
        var paint = Paint()..color = Colors.white;
        canvas.drawCircle(
            Offset(atom.x * xScale, atom.y * yScale), fontSize / 2 + 4, paint);
        var textPainter = TextPainter(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: atom.atomLabel,
                style:
                    const TextStyle(color: Colors.black, fontSize: fontSize)),
            textDirection: TextDirection.ltr);
        textPainter.layout();
        textPainter.paint(
            canvas,
            Offset(atom.x * xScale - textPainter.width / 2,
                atom.y * yScale - textPainter.height / 2));
        if (atom.numHgens > 0) {
          var HtextPainter = TextPainter(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "H${atom.numHgens}",
                  style:
                      const TextStyle(color: Colors.black, fontSize: fontSize)),
              textDirection: TextDirection.ltr);
          HtextPainter.layout();
          HtextPainter.paint(
              canvas,
              Offset(atom.x * xScale + textPainter.width,
                  atom.y * yScale - textPainter.height / 2));
        }
      }
    }
  }

  void _drawLines(
      Canvas canvas, double xScale, double yScale, double lineWidth) {
    for (var fragment in page!.fragments) {
      for (var bond in fragment.bonds) {
        var first = fragment.atoms
            .firstWhere((element) => element.id == bond.biginAtom);
        var second =
            fragment.atoms.firstWhere((element) => element.id == bond.endAtom);
        var paint = Paint()
          ..color = Colors.black
          ..strokeWidth = lineWidth;
        // print('first: ${first.x} ${first.y}');
        if (bond.bondStyle == BondStyle.single) {
          canvas.drawLine(Offset(first.x * xScale, first.y * yScale),
              Offset(second.x * xScale, second.y * yScale), paint);
        } else if (bond.bondStyle == BondStyle.double) {
          _drawDoubleBond(canvas, first, second, xScale, yScale, false, paint);
        }
      }
    }
  }

  void _drawDoubleBond(Canvas canvas, Atom beginAtom, Atom endAtom,
      double xScale, double yScale, bool isClockwise, Paint paint) {
    var distline = isClockwise ? 0.3 : -0.3; //distance between two lines
    var distTarminal = 0.3; //distance from end of line to tarminal

    double angleFrom(Vector2 v1, Vector2 v2) {
      var angle = v1.angleTo(v2);
      if (v1.cross(v2) > 0) {
        return angle;
      } else {
        return -angle;
      }
    }

    // draw single line and draw shorter second line
    //tarminal of second line is inner side of first line
    canvas.drawLine(Offset(beginAtom.x * xScale, beginAtom.y * yScale),
        Offset(endAtom.x * xScale, endAtom.y * yScale), paint);

    var firstLine = Vector2(endAtom.x - beginAtom.x, endAtom.y - beginAtom.y);
    var tmp = angleFrom(Vector2(1, 0), firstLine);

    var rotMatrix = Matrix2.rotation(angleFrom(Vector2(1, 0), firstLine));
    var secondLineStart = Vector2(beginAtom.x, beginAtom.y) +
        rotMatrix * Vector2(distTarminal.toDouble(), -distline.toDouble());

    var secondLineEnd = Vector2(endAtom.x, endAtom.y) +
        rotMatrix * Vector2(-distTarminal.toDouble(), -distline.toDouble());

    canvas.drawLine(
        Offset(secondLineStart.x * xScale, secondLineStart.y * yScale),
        Offset(secondLineEnd.x * xScale, secondLineEnd.y * yScale),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
