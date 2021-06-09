import 'package:belmer/app/utils/settings.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/app.dart';
import 'app/utils/importer.dart';

void main() async {
  // Firebase initilize
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FIREBASE_OPTIONS);

  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

  // FormBloc Localize
  // Notes: https://github.com/GiancarloCode/form_bloc/issues/6
  FieldBlocBuilder.defaultErrorBuilder = _formBlocErrorBuilder;

  runApp(App());
}

String _formBlocErrorBuilder(
    BuildContext context, String error, FieldBloc fieldBloc) {
  switch (error) {
    case FieldBlocValidatorsErrors.required:
      if (fieldBloc is MultiSelectFieldBloc || fieldBloc is SelectFieldBloc) {
        return "選択して下さい";
      }
      return '入力して下さい';
    case FieldBlocValidatorsErrors.email:
      return '正しいメールアドレスの形式で入力して下さい';
    case FieldBlocValidatorsErrors.passwordMin6Chars:
      return 'パスワードは6文字以上で入力して下さい';
    case FieldBlocValidatorsErrors.confirmPassword:
      return 'パスワードが一致していません';
    default:
      return error;
  }
}
