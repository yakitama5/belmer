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
      // TODO Drawerとボタン共通化してえ・・・・
      endDrawer: Drawer(
        child: ListView(
          children: [
            _DrawerItem(
              title: "Home",
              iconData: Icons.home,
              onTap: () =>
                  context.read<PageViewBloc>().add(PageViewEventHome()),
            ),
            _DrawerItem(
              title: "Search",
              iconData: Icons.search,
              onTap: () =>
                  context.read<PageViewBloc>().add(PageViewEventSearch()),
            ),
            _DrawerItem(
              title: "Info",
              iconData: Icons.info,
              onTap: () => InfoDialog.show(context),
            ),
            _DrawerItem(
              title: "Logout",
              iconData: Icons.logout,
              onTap: () => context.read<AuthBloc>().add(SignOut()),
            ),
          ],
        ),
      ),
      drawerEdgeDragWidth: 0,
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
        List<Widget> items = [];

        // 認証状態によってボタンを変更する
        if (state is AuthSuccess) {
          items.addAll([
            _buildHomeButton(context),
            _buildSearchButton(context),
            _buildInfoButton(context),
            _buildLogoutButton(context),
          ]);
        } else {
          items.add(
            _buildInfoButton(context),
          );
        }

        // 画面幅に合わせて省略する
        return LayoutBuilder(builder: (context, constraiants) {
          if (ResponsiveWidget.isSmallScreen(context)) {
            return _buildRightHeaderMenu(context, items);
          } else {
            return _buildRightHeaderAllItems(context, items);
          }
        });
      },
    );
  }

  Widget _buildRightHeaderAllItems(BuildContext context, List<Widget> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children:
          items.map((e) => [e, SpaceBox(width: 20)]).expand((e) => e).toList(),
    );
  }

  Widget _buildRightHeaderMenu(BuildContext context, List<Widget> items) {
    return TooltipIconButton(
      icon: Icon(Icons.menu),
      tooltipMessage: "Menu",
      onTap: () => Scaffold.of(context).openEndDrawer(),
    );
  }

  Widget _buildHomeButton(BuildContext context) {
    return HeaderButton(
      iconData: Icons.home,
      label: "Home",
      onTap: () => context.read<PageViewBloc>().add(PageViewEventHome()),
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return HeaderButton(
      iconData: Icons.search,
      label: "Search",
      onTap: () => context.read<PageViewBloc>().add(PageViewEventSearch()),
    );
  }

  Widget _buildInfoButton(BuildContext context) {
    return HeaderButton(
      iconData: Icons.info,
      label: "Info",
      onTap: () => InfoDialog.show(context),
      // onTap: () => context.read<PageViewBloc>().add(PageViewEventTest()),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return HeaderButton(
      iconData: Icons.logout,
      label: "Logout",
      onTap: () => context.read<AuthBloc>().add(SignOut()),
    );
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

class _DrawerItem extends StatelessWidget {
  final IconData? iconData;
  final String title;
  final void Function()? onTap;

  const _DrawerItem({
    Key? key,
    this.iconData,
    required this.title,
    this.onTap,
  }) : super(key: key);

  void handleOnTap(BuildContext context) {
    if (onTap != null) {
      Navigator.pop(context);
      onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        title: Row(
          children: [
            if (iconData != null)
              Icon(
                this.iconData,
                size: 30,
              ),
            SpaceBox(width: 10),
            Text(
              this.title,
              style: Theme.of(context).textTheme.headline1,
            ),
          ],
        ),
        onTap: () => handleOnTap(context),
      ),
    );
  }
}
