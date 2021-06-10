import 'package:belmer/app/utils/importer.dart';

class SlimeIndicator extends StatefulWidget {
  final Color? color;
  const SlimeIndicator({
    Key? key,
    this.color,
  }) : super(
          key: key,
        );

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SlimeIndicator> {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: widget.color ?? Theme.of(context).indicatorColor,
    );
  }
}
