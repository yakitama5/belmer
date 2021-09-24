import 'package:belmer/app/utils/importer.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget largeScreen;
  final Widget? smallScreen;

  static bool isPcScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 600;
  }

  static bool isMobileScreen(BuildContext context) {
    return MediaQuery.of(context).size.width <= 600;
  }

  const ResponsiveWidget({
    Key? key,
    required this.largeScreen,
    this.smallScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 600) {
        return largeScreen;
      } else {
        return smallScreen ?? largeScreen;
      }
    });
  }
}
