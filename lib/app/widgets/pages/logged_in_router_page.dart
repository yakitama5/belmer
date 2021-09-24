import 'package:belmer/app/blocs/page_view/page_view_importer.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/widgets/components/responsive_widget.dart';
import 'package:belmer/app/widgets/components/slime_indicator.dart';
import 'package:belmer/app/widgets/pages/mobile/mobile_home_page.dart';
import 'package:belmer/app/widgets/pages/pc/base_page.dart';
import 'package:belmer/app/widgets/pages/pc/home_page.dart';
import 'package:belmer/app/widgets/pages/mobile/mobile_base_page.dart';
import 'package:belmer/app/widgets/pages/pc/search_page.dart';
import 'package:belmer/app/widgets/pages/pc/test_page.dart';

class LogedInRouterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      largeScreen: const _PcScreen(),
      smallScreen: const _MobileScreen(),
    );
  }
}

class _PcScreen extends StatelessWidget {
  const _PcScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: BlocBuilder<PageViewBloc, PageViewState>(
        builder: (context, state) {
          if (state is PageViewStateHome) {
            return const HomePage();
          } else if (state is PageViewStateSearch) {
            return SearchPage();
          } else if (state is PageViewStateTest) {
            return TestPage();
          }

          return Container(
            padding: EdgeInsets.all(50),
            child: Center(
              child: SlimeIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class _MobileScreen extends StatelessWidget {
  const _MobileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: スマホ用レイアウトを作成する
    return BlocBuilder<PageViewBloc, PageViewState>(
      builder: (context, state) {
        Widget child = Container();
        String title = "";
        if (state is PageViewStateHome) {
          child = const MobileHomePage();
          title = "Home";
        } else if (state is PageViewStateSearch) {
          child = Container();
          title = "Home";
        } else if (state is PageViewStateTest) {
          child = Container();
          title = "Home";
        } else {
          return Container(
            padding: EdgeInsets.all(50),
            child: Center(
              child: SlimeIndicator(),
            ),
          );
        }

        return MobileBasePage(child: child, title: title);
      },
    );
  }
}
