import 'package:belmer/app/blocs/authentication/auth_importer.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/widgets/components/pc/logo_text.dart';
import 'package:belmer/app/widgets/components/space_box.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = context.read<AuthBloc>();
    return Column(
      children: [
        SpaceBox(height: 100),
        const _Logo(),
        SpaceBox(height: 20),
        SelectableText(
          "- Dragon Quest X Belts Manager -",
          style: Theme.of(context).textTheme.subtitle2,
        ),
        SpaceBox(height: 50),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            _LoginButton(
              icon: EvaIcons.google,
              text: "Google",
              onPressed: () => authBloc.add(SignInWithGoogle()),
            ),
          ],
        ),
        SpaceBox(height: 50),
        Align(
          alignment: Alignment.bottomCenter,
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyText1!,
            child: Column(
              children: [
                SelectableText(
                  """
このページで利用している株式会社スクウェア・エニックスを代表とする共同著作者が権利を所有する画像の転載・配布は禁止いたします。
(C) ARMOR PROJECT/BIRD STUDIO/SQUARE ENIX All Rights Reserved.""",
                  textAlign: TextAlign.center,
                ),
                SpaceBox(height: 10),
                Text("ver1.0"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  final String? _text;
  final IconData? _icon;
  final VoidCallback? _onPressed;

  ///
  /// Event: ボタン押下
  ///
  void _handlePush() {
    if (_onPressed != null) {
      _onPressed!();
    }
  }

  const _LoginButton({Key? key, text, icon, onPressed})
      : _text = text,
        _icon = icon,
        _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: SizedBox(
        width: 200,
        height: 60,
        child: ElevatedButton(
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20, right: 10),
                child: Icon(
                  _icon,
                ),
              ),
              Text(
                _text!,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          onPressed: () => _handlePush(),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
      ),
      child: Center(
        child: LogoText(textStyle: Theme.of(context).textTheme.headline6),
      ),
    );
  }
}
