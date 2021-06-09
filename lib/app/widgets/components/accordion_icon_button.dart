import 'package:belmer/app/utils/importer.dart';

class AccordionIconButton extends StatefulWidget {
  final IconData _iconData;
  final double _iconSize;
  final String _label;
  final double _maxWidth;
  final void Function() _onTap;

  const AccordionIconButton(
      {Key key,
      @required IconData iconData,
      @required double iconSize,
      @required String label,
      @required double maxWidth,
      void Function() onTap})
      : _iconData = iconData,
        _iconSize = iconSize,
        _label = label,
        _maxWidth = maxWidth,
        _onTap = onTap,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _State(width: this._iconSize);
}

class _State extends State<AccordionIconButton> {
  static const double INITIAL_OPACITY = 0.0;

  double opacity;
  double width;

  _State({
    @required this.width,
  })  : opacity = INITIAL_OPACITY,
        super();

  @override
  Widget build(BuildContext context) {
    final Duration duration = Duration(milliseconds: 250);
    final Widget iconWidget = Icon(
      widget._iconData,
      size: widget._iconSize,
    );
    final Widget textWidget = Text(
      widget._label,
      softWrap: false,
      overflow: TextOverflow.fade,
      style: Theme.of(context).textTheme.headline1,
    );

    return AnimatedContainer(
      constraints: BoxConstraints(maxWidth: widget._maxWidth),
      width: this.width,
      curve: Curves.easeIn,
      duration: duration,
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        onHover: (isHover) {
          setState(() {
            if (isHover) {
              opacity = 1.0;
              width = double.infinity;
            } else {
              opacity = INITIAL_OPACITY;
              width = widget._iconSize;
            }
          });
        },
        onTap: widget._onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            Flexible(
                child: AnimatedOpacity(
              curve: Curves.easeIn,
              duration: duration,
              opacity: this.opacity,
              child: textWidget,
            ))
          ],
        ),
      ),
    );
  }
}
