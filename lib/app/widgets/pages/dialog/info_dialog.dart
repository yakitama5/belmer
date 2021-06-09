import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/widgets/components/itemized_text.dart';
import 'package:belmer/app/widgets/components/space_box.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({Key key}) : super(key: key);

  static void show(BuildContext context) {
    AwesomeDialog(
      context: context,
      padding: EdgeInsets.only(
        top: 20,
        left: 30,
        right: 30,
        bottom: 50,
      ),
      useRootNavigator: true,
      borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 2),
      dismissOnTouchOutside: false,
      dialogBackgroundColor: Theme.of(context).backgroundColor,
      headerAnimationLoop: false,
      width: 800,
      animType: AnimType.SCALE,
      body: InfoDialog(),
      showCloseIcon: true,
      dialogType: DialogType.INFO,
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .merge(TextStyle(fontFamily: "Meiryo")),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("""
このサイトはドラクエ10用ベルト装備を管理するためのファンサイトです。
推奨ブラウザや使用方法については以下の説明をご参照下さい。
        """),
            _H1Text("■ブラウザ環境について"),
            Text("当サイトは、以下の環境でご使用いただくことを推奨いたします。"),
            SpaceBox(height: 10),
            _H2Text("Windows"),
            ItemizedText([
              Text("GoogleChrome"),
              Text("Edge"),
              Text("Firefox"),
            ]),
            SpaceBox(height: 10),
            _H2Text("Mac OS"),
            ItemizedText([
              Text("GoogleChrome"),
              Text("Safari"),
            ]),
            SpaceBox(height: 15),
            _H1Text("■ご意見・ご要望について"),
            Text("当サイトに対するご意見・ご要望につきましては、以下にお願いします。"),
            ItemizedText([
              Text("Githubの当リポジトリに対するissue発行"),
              Text("TwitterのDM機能"),
            ]),
          ],
        ));
  }
}

class _H1Text extends StatelessWidget {
  const _H1Text(this.text, {Key key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
    );
  }
}

class _H2Text extends StatelessWidget {
  const _H2Text(this.text, {Key key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
