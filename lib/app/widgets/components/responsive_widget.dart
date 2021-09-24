import 'package:belmer/app/utils/importer.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget largeScreen;
  final Widget? midiumScreen;
  final Widget? smallScreen;

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 800 &&
        MediaQuery.of(context).size.width < 1200;
  }

  const ResponsiveWidget({
    Key? key,
    required this.largeScreen,
    this.midiumScreen,
    this.smallScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        return largeScreen;
      } else if (constraints.maxWidth > 800) {
        return midiumScreen ?? largeScreen;
      } else {
        return smallScreen ?? midiumScreen ?? largeScreen;
      }
    });
  }
}
