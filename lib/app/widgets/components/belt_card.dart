import 'package:belmer/app/blocs/belt_card/belt_card_importer.dart';
import 'package:belmer/app/models/belt_table_model.dart';
import 'package:belmer/app/models/login_model.dart';
import 'package:belmer/app/repositories/firebase/belts_firebase_repository.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/widgets/components/failure_widget.dart';
import 'package:belmer/app/widgets/components/header_icon_button.dart';
import 'package:belmer/app/widgets/components/slime_indicator.dart';
import 'package:belmer/app/widgets/components/space_box.dart';
import 'package:belmer/app/widgets/components/summary_table.dart';
import 'package:belmer/app/widgets/pages/dialog/belt_regist_dialog.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class BeltsCard extends StatelessWidget {
  final String? beltType;
  final String? headerName;
  final ScrollController _horizontalBodyController = ScrollController();
  final ScrollController _horizontalTitleController = ScrollController();
  final ScrollController _verticalBodyController = ScrollController();
  final ScrollController _verticalTitleController = ScrollController();
  final bool showScrollableHint;

  BeltsCard({
    Key? key,
    this.beltType,
    this.headerName,
    this.showScrollableHint = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginModel loginModel = context.read<LoginModel>();
    return BlocProvider<BeltCardBloc>(
      create: (context) => BeltCardBloc(repository: BeltsFirebaseRepository())
        ..add(BeltCardEventLoad(userId: loginModel.uid, beltType: beltType)),
      child: Builder(
        builder: (context) => ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 1200,
            minHeight: 600,
          ),
          child: Ink(
            padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Column(
              children: [
                SpaceBox(height: 20),
                _buildCardHeader(context),
                SpaceBox(height: 10),
                _buildTable(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 40,
          width: 200,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )),
          child: Text(
            headerName!,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 30),
          child: _buildAddButton(context),
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return TooltipIconButton(
      icon: Icon(
        Icons.add_circle,
        color: Theme.of(context).primaryColor,
        size: 40,
      ),
      tooltipMessage: "Add",
      onTap: () => BeltRegistDialog.show(context),
    );
  }

  Widget _buildTable(BuildContext context) {
    return BlocBuilder<BeltCardBloc, BeltCardState>(builder: (context, state) {
      if (state is BeltCardStateSuccess) {
        return _buildCardBlocSuccess(context, state);
      } else if (state is BeltCardStateFailure) {
        return FailureWidget();
      }

      return SlimeIndicator(color: Theme.of(context).backgroundColor);
    });
  }

  Widget _buildCardBlocSuccess(
      BuildContext context, BeltCardStateSuccess state) {
    return StreamBuilder(
      stream: state.rowModelsStream,
      builder: (_, AsyncSnapshot<List<BeltRowModel>> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return FailureWidget();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return SlimeIndicator(color: Theme.of(context).backgroundColor);
        }

        return SummaryTable(
          horizontalBodyController: _horizontalBodyController,
          horizontalTitleController: _horizontalTitleController,
          verticalBodyController: _verticalBodyController,
          verticalTitleController: _verticalTitleController,
          onSelectRow: (beltModel) =>
              BeltRegistDialog.show(context, beltId: beltModel.id),
          columnTitleModels: state.columnTitleModels,
          rowModels: snapshot.data,
          showScrollableHint: showScrollableHint,
        );
      },
    );
  }
}
