import 'package:belmer/app/blocs/page_view/page_view_importer.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/widgets/components/slime_indicator.dart';
import 'package:belmer/app/widgets/pages/base_page.dart';
import 'package:belmer/app/widgets/pages/dashboard_page.dart';
import 'package:belmer/app/widgets/pages/search_page.dart';
import 'package:belmer/app/widgets/pages/test_page.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: BlocBuilder<PageViewBloc, PageViewState>(
        builder: (context, state) {
          if (state is PageViewStateHome) {
            return const DashboardPage();
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
