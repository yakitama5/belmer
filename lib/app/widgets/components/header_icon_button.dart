import 'package:belmer/app/utils/importer.dart';

class TooltipIconButton extends StatelessWidget {
  final Icon _icon;
  final String? _tooltipMessage;
  final void Function()? _onTap;

  const TooltipIconButton({
    Key? key,
    required Icon icon,
    String? tooltipMessage,
    void Function()? onTap,
  })  : _icon = icon,
        _tooltipMessage = tooltipMessage,
        _onTap = onTap,
        super();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _tooltipMessage!,
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(5),
          child: _icon,
        ),
        onTap: _onTap,
      ),
    );
  }
}
