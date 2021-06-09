import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/utils/my_icons.dart';
import 'package:belmer/app/widgets/components/space_box.dart';

class FailureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color accentGrey = Colors.grey[600];
    final Color primaryGrey = Colors.grey[100];

    return DefaultTextStyle(
      style: TextStyle(
        color: accentGrey,
        fontSize: 30,
      ),
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(50),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: accentGrey),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: primaryGrey,
        ),
        child: Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              MyIcons.face_kanasii,
              size: 50,
              color: accentGrey,
            ),
            SpaceBox(width: 20),
            Text(
              """エラーが発生しました
画面を再読み込みして下さい""",
              softWrap: true,
              overflow: TextOverflow.clip,
            ),
          ],
        ),
      ),
    );
  }
}
