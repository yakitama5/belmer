import 'package:belmer/app/utils/constants.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/widgets/components/pc/belt_card.dart';
import 'package:belmer/app/widgets/components/space_box.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SpaceBox(height: 50),
        BeltsCard(
          beltType: Constants.BELT_TYPE_KISEKI,
          headerName: "輝石のベルト",
          showScrollableHint: true,
        ),
        SpaceBox(height: 30),
        BeltsCard(
          beltType: Constants.BELT_TYPE_SENSIN,
          headerName: "戦神のベルト",
        ),
        SpaceBox(height: 30),
      ],
    );
  }
}
