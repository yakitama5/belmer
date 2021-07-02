import 'package:belmer/app/blocs/mobile_belt_card/mobile_belt_card_importer.dart';
import 'package:belmer/app/models/login_model.dart';
import 'package:belmer/app/repositories/firebase/belts_firebase_repository.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/widgets/components/slime_indicator.dart';
import 'package:expandable/expandable.dart';

class MobileHomePage extends StatelessWidget {
  const MobileHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _BeltCard(title: "輝石のベルト"),
          _BeltCard(title: "戦神のベルト"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        tooltip: "追加",
        child: Icon(Icons.add),
      ),
    );
  }
}

class _BeltCard extends StatelessWidget {
  final String title;
  final ExpandableController _exController = ExpandableController();

  _BeltCard({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginModel loginModel = context.read<LoginModel>();

    return BlocProvider(
      create: (context) =>
          MobileBeltCardBloc(repository: BeltsFirebaseRepository())
            ..add(MobileBeltCardEventLoad(userId: loginModel.uid)),
      child: Builder(
          builder: (context) =>
              BlocBuilder<MobileBeltCardBloc, MobileBeltCardState>(
                  builder: (context, state) {
                // TODO: エラー表示等を作成する
                if (state is MobileBeltCardStateSuccess) {
                  _buildSuccess(context, state);
                }

                return SlimeIndicator();
              })),
    );
  }

  Widget _buildSuccess(BuildContext context, MobileBeltCardStateSuccess state) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Theme.of(context).accentColor,
      child: ExpandablePanel(
        controller: _exController,
        header: Container(
          padding:
              EdgeInsets.only(top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).backgroundColor,
            ),
          ),
        ),
        collapsed: Container(),
        expanded: Container(
          padding: EdgeInsets.only(bottom: 5.0),
          child: Column(
            // TODO: 取得出来た結果で作成するようにする
            children: [1, 2, 3, 4, 5]
                .map((e) => _EffectPanel(title: "さいだいHP"))
                .toList(),
          ),
        ),
        theme: ExpandableThemeData(
          iconColor: Theme.of(context).backgroundColor,
          inkWellBorderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

class _EffectPanel extends StatelessWidget {
  final String title;
  final ExpandableController _exController = ExpandableController();

  _EffectPanel({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        // borderRadius: BorderRadius.zero,
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(
          color: Theme.of(context).accentColor,
          width: 1,
        ),
      ),
      color: Theme.of(context).secondaryHeaderColor,
      child: ExpandablePanel(
        controller: _exController,
        header: Text(
          this.title,
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).accentColor,
          ),
        ),
        collapsed: Container(),
        expanded: Container(),
        theme: ExpandableThemeData(
          iconColor: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
