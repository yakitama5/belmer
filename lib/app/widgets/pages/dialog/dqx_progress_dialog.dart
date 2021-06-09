import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/widgets/components/slime_indicator.dart';

class DqxProgressDialog extends StatelessWidget {
  static void show(BuildContext context, {key}) => showDialog(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => DqxProgressDialog(),
      ).then((value) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const DqxProgressDialog({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Center(
        child: SlimeIndicator(),
      ),
      onWillPop: () async => false,
    );
  }
}
