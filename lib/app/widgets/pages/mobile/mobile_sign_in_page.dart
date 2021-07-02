import 'package:belmer/app/blocs/authentication/auth_importer.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/widgets/components/space_box.dart';

class MobileSignInPage extends StatelessWidget {
  const MobileSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = context.read<AuthBloc>();
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(left: 30.0, right: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpaceBox(height: 15),
          _H1Text(text: "アカウント連携"),
          Text(
            """アカウント連携を行うと、
Webとアプリで共有したデータをご利用頂けます。""",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SpaceBox(height: 5),
          Center(
            child: Column(
              children: [
                _LoginButton(
                  icon: EvaIcons.google,
                  text: "Google",
                  onPressed: () => authBloc.add(SignInWithGoogle()),
                ),
                SpaceBox(height: 200),
                _LoginButton(
                  text: "アカウント連携しない",
                  onPressed: () => authBloc.add(SignInAnonymously()),
                ),
              ],
            ),
          ),
          SpaceBox(height: 10),
          Text(
            "※ アカウント連携はいつでも行えます。",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}

class _H1Text extends StatelessWidget {
  final String text;

  const _H1Text({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline2,
    );
  }
}

class _LoginButton extends StatelessWidget {
  final String? _text;
  final IconData? _icon;
  final VoidCallback? _onPressed;
  final double _fontSize;

  ///
  /// Event: ボタン押下
  ///
  void _handlePush() {
    if (_onPressed != null) {
      _onPressed!();
    }
  }

  const _LoginButton(
      {Key? key,
      String? text,
      IconData? icon,
      VoidCallback? onPressed,
      double? fontSize})
      : _text = text,
        _icon = icon,
        _onPressed = onPressed,
        _fontSize = fontSize ?? 20.0,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: Row(
            children: <Widget>[
              SpaceBox(width: 15),
              Icon(
                _icon,
              ),
              SpaceBox(width: 20),
              Text(
                _text!,
                style: TextStyle(fontSize: _fontSize),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          onPressed: () => _handlePush(),
        ),
      ),
    );
  }
}
