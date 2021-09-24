import 'package:belmer/app/blocs/authentication/auth_importer.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/widgets/pages/dialog/dqx_progress_dialog.dart';
import 'package:belmer/app/widgets/pages/pc/base_page.dart';
import 'package:belmer/app/widgets/pages/pc/sign_in_page.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (prev, current) {
          // プログレス制御
          if (current is AuthProgress) {
            DqxProgressDialog.show(context);
          } else {
            DqxProgressDialog.hide(context);
          }
        },
        child: BasePage(
          child: const SignInPage(),
        ),
        // TODO スマホ版はレイアウト決まってから
        // child: ResponsiveWidget(
        //   largeScreen: BasePage(
        //     child: const SignInPage(),
        //   ),
        //   smallScreen: MobileBasePage(
        //     title: "Login",
        //     child: const MobileSignInPage(),
        //   ),
        // ),
      ),
    );
  }
}
