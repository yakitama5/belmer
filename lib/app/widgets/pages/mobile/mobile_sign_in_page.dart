import 'package:belmer/app/blocs/authentication/auth_importer.dart';
import 'package:belmer/app/utils/importer.dart';

class MobileSignInPage extends StatelessWidget {
  const MobileSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = context.read<AuthBloc>();
    return Container();
  }
}
