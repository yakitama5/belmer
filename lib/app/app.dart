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
    final ThemeData theme = ThemeData();
    Color primary;
    Color onPrimary;
    Color secondary;
    Color onSecondary;
    String fontFamily;

    if (state is AuthSuccess) {
      primary = MyColors.whiteColor;
      onPrimary = MyColors.primaryColor;
      secondary = MyColors.secondryColor;
      onSecondary = MyColors.onSecondryColor;
      fontFamily = MyFonts.Kiwi;
    } else {
      primary = MyColors.primaryColor;
      onPrimary = MyColors.whiteColor;
      secondary = MyColors.whiteColor;
      onSecondary = MyColors.primaryColor;
      fontFamily = MyFonts.Meiryo;
    }

    return ThemeData(
      // 基本色設定
      colorScheme: theme.colorScheme.copyWith(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        background: primary,
      ),
      scaffoldBackgroundColor: primary,
      dividerColor: onPrimary,
      indicatorColor: onPrimary,

      // AppBar (スマホでのみ使用)
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        elevation: 0.0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: MyFonts.Yikes,
          color: onPrimary,
          fontSize: 30,
        ),
      ),

      iconTheme: IconThemeData(
        color: onPrimary,
      ),

      // ボタンテーマ
      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: secondary,
          onPrimary: onSecondary,
          textStyle: TextStyle(
            fontSize: 16,
            fontFamily: fontFamily,
          ),
          padding: EdgeInsets.all(5.0),
        ),
      ),

      // PC版各種テキストテーマ
      textTheme: TextTheme(
        // 通常テキスト
        bodyText1: TextStyle(color: onPrimary),

        // Header Link
        headline1: TextStyle(
          color: onPrimary,
          fontSize: 20,
          fontFamily: MyFonts.Segoe,
        ),

        // 入力フォーム内ヘッダー
        headline2: TextStyle(
          color: onPrimary,
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
          color: onPrimary,
        ),

        // Logo Title
        headline6: TextStyle(
          fontFamily: MyFonts.Yikes,
          fontSize: 100,
          color: primary,
        ),

        // 入力フォーム(ドロップダウン)
        subtitle1: TextStyle(
          fontSize: 20,
          color: onPrimary,
        ),

        // Sub Title
        subtitle2: TextStyle(
          fontFamily: MyFonts.Yikes,
          fontSize: 20,
          color: onPrimary,
        ),

        // Caption
        caption: TextStyle(
          color: onSecondary,
          fontSize: 20,
        ),
      ),

      textSelectionTheme: theme.textSelectionTheme.copyWith(
        cursorColor: onPrimary,
        selectionColor: Colors.grey,
        selectionHandleColor: Colors.amberAccent,
      ),

      fontFamily: fontFamily,
    );
  }
}
