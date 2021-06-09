import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/utils/my_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50.0),
      width: 500,
      height: 500,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.red[50],
          ),
          _Hoge(),
        ],
      ),
    );
  }
}

class _Hoge extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    final tweenAnimation = Tween<Alignment>(
            begin: Alignment.centerRight, end: Alignment.centerLeft)
        .animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOutQuart,
    ));

    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.grey.withOpacity(0.5),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(bottom: 40.0),
                child: CustomPaint(
                  foregroundPainter: _MarkPainter(color: Colors.grey[700]),
                ),
              ),
            ),
            AlignTransition(
              alignment: tweenAnimation,
              child: Icon(
                MyIcons.hand_point_up,
                size: 30,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  final Color _color;

  _MarkPainter({@required Color color})
      : assert(color != null),
        _color = color,
        super();

  @override
  void paint(Canvas canvas, Size size) {
    // 横線の描画
    _paintLine(canvas, size);

    // 三角形の描画
    _paintTriangle(canvas, size);
  }

  void _paintLine(Canvas canvas, Size size) {
    final double widthCenter = size.width / 2;
    final double heightCenter = size.height / 2;

    // 横線
    final Offset lineFrom = Offset(widthCenter - 35, heightCenter);
    final Offset lineTo = Offset(widthCenter + 35, heightCenter);
    final linePaint = Paint()
      ..color = _color
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawLine(lineFrom, lineTo, linePaint);
  }

  void _paintTriangle(Canvas canvas, Size size) {
    final double widthCenter = size.width / 2;
    final double heightCenter = size.height / 2;

    final paint = Paint()
      ..color = _color
      ..strokeCap = StrokeCap.square;

    // 横線
    final Path leftPath = Path();
    leftPath.moveTo(widthCenter - 45, heightCenter);
    leftPath.lineTo(widthCenter - 35, heightCenter - 10);
    leftPath.lineTo(widthCenter - 35, heightCenter + 10);
    leftPath.close();
    canvas.drawPath(leftPath, paint);

    final Path rightPath = Path();
    rightPath.moveTo(widthCenter + 45, heightCenter);
    rightPath.lineTo(widthCenter + 35, heightCenter - 10);
    rightPath.lineTo(widthCenter + 35, heightCenter + 10);
    rightPath.close();
    canvas.drawPath(rightPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
