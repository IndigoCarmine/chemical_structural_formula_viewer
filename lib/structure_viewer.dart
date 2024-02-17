import 'package:vector_math/vector_math_64.dart' show Vector2, Matrix2;
import 'package:chemical_structural_formula_viewer/elements.dart';
import 'package:flutter/material.dart';

import 'extention.dart';

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
      size: Size.infinite,
      painter: StructurePainter(widget.page),
      // child: Expanded(
      //   child: Container(),
      // ),
    );
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

    var scale = xScale < yScale ? xScale : yScale;
    //fill background
    var paint = Paint()..color = Colors.white;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, page!.boundingBox.width * scale,
            page!.boundingBox.height * scale),
        paint);

    _drawLines(canvas, scale, 4);

    _drawAtomLabel(canvas, scale);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _drawAtomLabel(Canvas canvas, double scale) {
    var circleMargin = scale / 5;
    for (var fragment in page!.fragments) {
      for (var atom in fragment.atoms) {
        var fontSize = atom.fontSize * scale;
        if (atom.atomLabel == 'C') continue;
        var paint = Paint()..color = Colors.white;
        canvas.drawCircle(Offset(atom.x * scale, atom.y * scale),
            fontSize / 2 + circleMargin, paint);
        var textPainter = TextPainter(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: atom.atomLabel,
                style: TextStyle(color: Colors.black, fontSize: fontSize)),
            textDirection: TextDirection.ltr);
        textPainter.layout();
        textPainter.paint(
            canvas,
            Offset(atom.x * scale - textPainter.width / 2,
                atom.y * scale - textPainter.height / 2));
        if (atom.numHgens > 0) {
          var htextPainter = TextPainter(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "H${atom.numHgens}",
                  style: TextStyle(color: Colors.black, fontSize: fontSize)),
              textDirection: TextDirection.ltr);
          htextPainter.layout();
          htextPainter.paint(
              canvas,
              Offset(atom.x * scale + textPainter.width,
                  atom.y * scale - textPainter.height / 2));
        }
      }
    }
  }

  void _drawLines(Canvas canvas, double scale, double lineWidth) {
    for (var fragment in page!.fragments) {
      for (var bond in fragment.bonds) {
        var first = bond.bAtom(fragment.atoms);
        var second = bond.eAtom(fragment.atoms);

        var firstLine = Vector2(second.x - first.x, second.y - first.y);

        var paint = Paint()
          ..color = Colors.black
          ..strokeWidth = lineWidth * firstLine.length / 100 * scale;

        if (bond.isSingleBond) {
          canvas.drawLine(Offset(first.x * scale, first.y * scale),
              Offset(second.x * scale, second.y * scale), paint);
        } else if (bond.isDoubleBond) {
          _drawDoubleBond(canvas, first, second, scale,
              bond.bondStyle.bondPosition == BondPosition.right, paint);
        }
      }
    }
  }

  void _drawDoubleBond(Canvas canvas, Atom beginAtom, Atom endAtom,
      double scale, bool isClockwise, Paint paint) {
    // draw single line and draw shorter second line
    //tarminal of second line is inner side of first line
    canvas.drawLine(Offset(beginAtom.x * scale, beginAtom.y * scale),
        Offset(endAtom.x * scale, endAtom.y * scale), paint);

    var firstLine = Vector2(endAtom.x - beginAtom.x, endAtom.y - beginAtom.y);
    var rotMatrix = Matrix2.rotation(firstLine.angle());

    var space = firstLine.length / 10; //space between two lines
    var distline = isClockwise ? space : -space; //distance between two lines
    var distTarminal = space; //distance from end of line to tarminal

    var secondLineStart = Vector2(beginAtom.x, beginAtom.y) +
        rotMatrix * Vector2(distTarminal.toDouble(), -distline.toDouble());

    var secondLineEnd = Vector2(endAtom.x, endAtom.y) +
        rotMatrix * Vector2(-distTarminal.toDouble(), -distline.toDouble());

    canvas.drawLine(
        Offset(secondLineStart.x * scale, secondLineStart.y * scale),
        Offset(secondLineEnd.x * scale, secondLineEnd.y * scale),
        paint);
  }
}
