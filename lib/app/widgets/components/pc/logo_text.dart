import 'package:belmer/app/utils/constants.dart';
import 'package:belmer/app/utils/importer.dart';

class LogoText extends StatelessWidget {
  const LogoText({
    Key? key,
    this.textStyle,
  }) : super(key: key);

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      Constants.APP_NAME,
      style: textStyle,
    );
  }
}
