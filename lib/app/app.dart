import 'package:belmer/app/blocs/authentication/auth_importer.dart';
import 'package:belmer/app/models/login_model.dart';
import 'package:belmer/app/repositories/firebase/auth_firebase_repository.dart';
import 'package:belmer/app/routes/menu_router.dart';
import 'package:belmer/app/utils/constants.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/utils/my_colors.dart';
import 'package:belmer/app/utils/my_fonts.dart';
import 'package:belmer/app/widgets/components/slime_indicator.dart';
import 'package:belmer/app/widgets/pages/index_page.dart';
import 'package:belmer/app/widgets/pages/pc/sign_in_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 認証状態を取り扱うBlocを定義 + アプリ開始イベント(AppStarted)を発火
    return BlocProvider<AuthBloc>(
      create: (context) =>
          AuthBloc(repository: AuthFirestoreRepository())..add(AppStarted()),
      child: _App(),
    );
  }
}

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: Constants.APP_NAME,
          // テーマの変更を出来るだけ滑らかにする
          home: AnimatedTheme(
            data: _createThemeData(context, state),
            duration: Duration(milliseconds: 300),
            child: Builder(
              builder: (context) {
                // 認証状態に応じて画面を返却
                if (state is AuthSuccess) {
                  return _buildAuthSuccess(context, state);
                } else if (state is AuthStatePure) {
                  return Scaffold(
                    body: Center(
                      child: SlimeIndicator(),
                    ),
                  );
                }

                // 上記以外はサインインページへ
                return _buildNotAuth(context, state);
              },
            ),
          ),
        );
      },
    );
  }

  ///
  /// Build: 認証成功時
  ///
  Widget _buildAuthSuccess(BuildContext context, AuthSuccess state) {
    // 認証成功時のみ、Providerで認証情報にアクセス可能にする
    return Provider<LoginModel>(
      create: (_) => state.loginModel,
      child: const MenuRouter(),
    );
  }

  ///
  /// Build: 未認証時
  ///
  Widget _buildNotAuth(BuildContext context, AuthState state) {
    return const IndexPage();
  }

  ///
  /// Build: テーマの生成
  ///
  ThemeData _createThemeData(BuildContext context, AuthState state) {
    Color _primaryColor;
    Color _accentColor;
    Color _secondryColor;
    Color _onSecondryColor;
    String _fontFamily;

    if (state is AuthSuccess) {
      _primaryColor = MyColors.whiteColor;
      _accentColor = MyColors.primaryColor;
      _secondryColor = MyColors.secondryColor;
      _onSecondryColor = MyColors.onSecondryColor;
      _fontFamily = MyFonts.Kiwi;
    } else {
      _primaryColor = MyColors.primaryColor;
      _accentColor = MyColors.whiteColor;
      _secondryColor = MyColors.whiteColor;
      _onSecondryColor = MyColors.primaryColor;
      _fontFamily = MyFonts.Meiryo;
    }

    return ThemeData(
      // 基本色設定
      primaryColor: _primaryColor,
      accentColor: _accentColor,
      buttonColor: _secondryColor,
      backgroundColor: _primaryColor,
      scaffoldBackgroundColor: _primaryColor,
      secondaryHeaderColor: _secondryColor,
      dividerColor: _accentColor,
      indicatorColor: _accentColor,

      // AppBar (スマホでのみ使用)
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor,
        elevation: 0.0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: MyFonts.Yikes,
          color: _accentColor,
          fontSize: 30,
        ),
      ),

      // アイコンテーマ
      iconTheme: IconThemeData(
        color: _accentColor,
      ),

      // ボタンテーマ
      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: _secondryColor,
          onPrimary: _onSecondryColor,
          textStyle: TextStyle(
            fontSize: 16,
            fontFamily: _fontFamily,
          ),
          padding: EdgeInsets.all(5.0),
        ),
      ),

      // PC版各種テキストテーマ
      textTheme: TextTheme(
        // 通常テキスト
        bodyText1: TextStyle(color: _accentColor),

        // Header Link
        headline1: TextStyle(
          color: _accentColor,
          fontSize: 20,
          fontFamily: MyFonts.Segoe,
        ),

        // 入力フォーム内ヘッダー
        headline2: TextStyle(
          color: _accentColor,
          fontSize: 20,
        ),

        // 入力フォーム内ラベル
        headline3: TextStyle(
          color: Colors.grey,
          fontSize: 20,
        ),

        // Logo SubTitles
        headline5: TextStyle(
          fontFamily: MyFonts.Yikes,
          fontSize: 30,
          color: _accentColor,
        ),

        // Logo Title
        headline6: TextStyle(
          fontFamily: MyFonts.Yikes,
          fontSize: 100,
          color: _primaryColor,
        ),

        // 入力フォーム(ドロップダウン)
        subtitle1: TextStyle(
          fontSize: 20,
          color: _accentColor,
        ),

        // Sub Title
        subtitle2: TextStyle(
          fontFamily: MyFonts.Yikes,
          fontSize: 20,
          color: _accentColor,
        ),

        // Caption
        caption: TextStyle(
          color: _onSecondryColor,
          fontSize: 20,
        ),
      ),

      // スマホ版テキストテーマ

      fontFamily: _fontFamily,
    );
  }
}
