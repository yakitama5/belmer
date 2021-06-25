import 'package:belmer/app/blocs/authentication/auth_bloc.dart';
import 'package:belmer/app/blocs/authentication/auth_importer.dart';
import 'package:belmer/app/blocs/page_view/page_view_bloc.dart';
import 'package:belmer/app/blocs/page_view/page_view_event.dart';
import 'package:belmer/app/utils/importer.dart';

class MobileBasePage extends StatelessWidget {
  final Widget child;
  final String title;

  const MobileBasePage({
    Key? key,
    required this.child,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        bool isAuthSuccess = state is AuthSuccess;

        return Scaffold(
          appBar: _buildAppbar(context, isAuthSuccess),
          drawer: _buildDrawer(context, isAuthSuccess),
          body: child,
        );
      },
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context, bool isAuthSuccess) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      bottom: PreferredSize(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 5, right: 5),
          height: 1.0,
          color: Theme.of(context).dividerColor,
        ),
        preferredSize: Size.fromHeight(1.0),
      ),
      leading: Builder(
        builder: (context) => isAuthSuccess
            ? InkWell(
                child: Icon(
                  Icons.menu,
                  color: Theme.of(context).iconTheme.color,
                ),
                onTap: () => Scaffold.of(context).openDrawer(),
              )
            : Container(),
      ),
    );
  }

  Widget? _buildDrawer(BuildContext context, bool isAuthSuccess) {
    if (!isAuthSuccess) {
      return null;
    }

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
              child: Container()),
          _HomeMenu(),
          _SearchMenu(),
          _InfoMenu(),
        ],
      ),
    );
  }
}

class _HomeMenu extends StatelessWidget {
  const _HomeMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _DrawerItem(
      title: "Home",
      iconData: Icons.home,
      onTap: () => context.read<PageViewBloc>().add(PageViewEventHome()),
    );
  }
}

class _SearchMenu extends StatelessWidget {
  const _SearchMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _DrawerItem(
      title: "Search",
      iconData: Icons.search,
      onTap: () => context.read<PageViewBloc>().add(PageViewEventSearch()),
    );
  }
}

class _InfoMenu extends StatelessWidget {
  const _InfoMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _DrawerItem(
      title: "Info",
      iconData: Icons.info,
      onTap: () => context.read<PageViewBloc>().add(PageViewEventTest()),
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

  void handleOnTap() {
    if (onTap != null) {
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
                size: 25,
              ),
            Text(
              this.title,
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
        onTap: handleOnTap,
      ),
    );
  }
}
