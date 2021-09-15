import 'package:belmer/app/utils/importer.dart';

class FormElevatedButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final ButtonStyle? style;

  const FormElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: style,
      ),
    );
  }
}
