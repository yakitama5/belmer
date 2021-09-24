import 'package:belmer/app/blocs/authentication/auth_bloc.dart';
import 'package:belmer/app/blocs/authentication/auth_importer.dart';
import 'package:belmer/app/blocs/page_view/page_view_bloc.dart';
import 'package:belmer/app/blocs/page_view/page_view_event.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/widgets/components/pc/header_button.dart';
import 'package:belmer/app/widgets/components/pc/header_icon_button.dart';
import 'package:belmer/app/widgets/components/pc/logo_text.dart';
import 'package:belmer/app/widgets/components/responsive_widget.dart';
import 'package:belmer/app/widgets/components/space_box.dart';
import 'package:belmer/app/widgets/pages/dialog/info_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

const double PAGE_WIDTH = 1280;

class BasePage extends StatelessWidget {
  final Widget child;

  const BasePage({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const _Header(),
              const Divider(height: 1),
              _Body(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 75,
          maxWidth: PAGE_WIDTH,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildHeaderLeftItem(context),
            _buildHeaderRightItem(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderLeftItem(BuildContext context) {
    return Row(
      children: [
        LogoText(textStyle: Theme.of(context).textTheme.headline5),
        SpaceBox(width: 10),
        const _GithubIconButton(),
        const _TwitterIconButton(),
      ],
    );
  }

  Widget _buildHeaderRightItem(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        List<_HeaderItem> headerItems;

        // 認証状態によってボタンを変更する
        if (state is AuthSuccess) {
          headerItems = [
            _HeaderItem(
              "Home",
              Icons.home,
              () => context.read<PageViewBloc>().add(PageViewEventHome()),
            ),
            _HeaderItem(
              "Search",
              Icons.search,
              () => context.read<PageViewBloc>().add(PageViewEventSearch()),
            ),
            _HeaderItem(
              "Info",
              Icons.info,
              () => InfoDialog.show(context),
            ),
            _HeaderItem(
              "Logout",
              Icons.logout,
              () => context.read<AuthBloc>().add(SignOut()),
            ),
          ];
        } else {
          headerItems = [
            _HeaderItem(
              "Info",
              Icons.info,
              () => InfoDialog.show(context),
            )
          ];
        }

        return LayoutBuilder(builder: (context, constraiants) {
          if (ResponsiveWidget.isSmallScreen(context)) {
            return _buildRightHeaderMenu(context, headerItems);
          } else {
            return _buildRightHeaderAllItems(context, headerItems);
          }
        });
      },
    );
  }

  Widget _buildRightHeaderAllItems(
      BuildContext context, List<_HeaderItem> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: items
          .map((item) => [
                HeaderButton(
                    iconData: item.iconData,
                    label: item.label,
                    onTap: item.onTap),
                SpaceBox(width: 20)
              ])
          .expand((e) => e)
          .toList(),
    );
  }

  Widget _buildRightHeaderMenu(BuildContext context, List<_HeaderItem> items) {
    return PopupMenuButton(
        icon: Icon(Icons.menu),
        iconSize: 30,
        itemBuilder: (BuildContext context) => items
            .map(
              (item) => PopupMenuItem(
                child: Row(
                  children: [Icon(item.iconData), Text(item.label)],
                ),
                onTap: item.onTap,
                textStyle: Theme.of(context).textTheme.headline1,
              ),
            )
            .toList());
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: PAGE_WIDTH,
        ),
        child: child,
      ),
    );
  }
}

class _GithubIconButton extends StatelessWidget {
  const _GithubIconButton({
    Key? key,
  }) : super(key: key);

  static const String GITHUB_PAGE_URL =
      "https://github.com/yakitama5/belmer/issues";

  @override
  Widget build(BuildContext context) {
    return TooltipIconButton(
      icon: Icon(
        EvaIcons.github,
        size: 30,
      ),
      tooltipMessage: "Github",
      onTap: () async {
        if (await canLaunch(GITHUB_PAGE_URL)) {
          await launch(GITHUB_PAGE_URL);
        }
      },
    );
  }
}

class _TwitterIconButton extends StatelessWidget {
  const _TwitterIconButton({
    Key? key,
  }) : super(key: key);

  static const String TWITTER_PAGE_URL = "https://twitter.com/dq10_yakitamago";

  @override
  Widget build(BuildContext context) {
    return TooltipIconButton(
      icon: Icon(
        EvaIcons.twitter,
        size: 30,
      ),
      tooltipMessage: "Twitter",
      onTap: () async {
        if (await canLaunch(TWITTER_PAGE_URL)) {
          await launch(TWITTER_PAGE_URL);
        }
      },
    );
  }
}

class _HeaderItem {
  final String label;
  final IconData iconData;
  final void Function() onTap;

  _HeaderItem(this.label, this.iconData, this.onTap);
}
