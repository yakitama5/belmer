import 'package:belmer/app/blocs/page_view/page_view_bloc.dart';
import 'package:belmer/app/blocs/page_view/page_view_event.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/widgets/pages/main_page.dart';

class MenuRouter extends StatelessWidget {
  const MenuRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: _Router.root,
      onGenerateRoute: _Router().onGenerateRoute,
    );
  }
}

class _Router {
  static final root = '/';

  final _routes = <String, Widget Function(BuildContext, RouteSettings)>{
    root: (context, settings) => BlocProvider<PageViewBloc>(
          create: (context) => PageViewBloc()..add(PageViewEventHome()),
          child: MainPage(),
        ),
  };

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final pageBuilder = _routes[settings.name!];
    if (pageBuilder != null) {
      return MaterialPageRoute<void>(
        builder: (context) => pageBuilder(context, settings),
        settings: settings,
      );
    }

    assert(false, 'unexpected settings: $settings');
    return null;
  }
}
