import 'package:belmer/app/utils/importer.dart';

class HeaderButton extends StatelessWidget {
  final IconData _iconData;
  final String _label;
  final void Function()? _onTap;
  final String? _tooltipMessage;

  const HeaderButton(
      {Key? key,
      required IconData iconData,
      required String label,
      String? tooltipMessage,
      void Function()? onTap})
      : _iconData = iconData,
        _label = label,
        _onTap = onTap,
        _tooltipMessage = tooltipMessage,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget iconWidget = Icon(
      this._iconData,
      size: 30,
    );
    final Widget textWidget = Text(
      _label,
      style: Theme.of(context).textTheme.headline1,
    );

    return Tooltip(
      message: _tooltipMessage ?? _label,
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            textWidget,
          ],
        ),
        onTap: _onTap,
      ),
    );
  }
}
