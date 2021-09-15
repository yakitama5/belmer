import 'package:belmer/app/blocs/belt_search/belt_search_bloc.dart';
import 'package:belmer/app/blocs/belt_search/belt_search_event.dart';
import 'package:belmer/app/blocs/belt_search/belt_search_state.dart';
import 'package:belmer/app/blocs/form_blocs/search_form_bloc.dart';
import 'package:belmer/app/blocs/search_page/search_page_bloc.dart';
import 'package:belmer/app/blocs/search_page/search_page_event.dart';
import 'package:belmer/app/blocs/search_page/search_page_state.dart';
import 'package:belmer/app/models/login_model.dart';
import 'package:belmer/app/repositories/firebase/belts_firebase_repository.dart';
import 'package:belmer/app/utils/importer.dart';
import 'package:belmer/app/widgets/components/pc/failure_widget.dart';
import 'package:belmer/app/widgets/components/pc/search_result_table.dart';
import 'package:belmer/app/widgets/components/slime_indicator.dart';
import 'package:belmer/app/widgets/components/space_box.dart';
import 'package:belmer/app/widgets/pages/dialog/belt_regist_dialog.dart';
import 'package:expandable/expandable.dart';

class SearchPage extends StatelessWidget {
  final ScrollController _horizontalBodyController = ScrollController();
  final ScrollController _horizontalTitleController = ScrollController();
  final ScrollController _verticalBodyController = ScrollController();
  final ScrollController _verticalTitleController = ScrollController();

  SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchPageBloc>(
        create: (_) => SearchPageBloc()..add(SearchPageEventInit()),
        child: Builder(
            builder: (context) => BlocBuilder<SearchPageBloc, SearchPageState>(
                    builder: (context, state) {
                  if (state is SearchPageStateSuccess) {
                    return _buildPageStateSuccess(context, state);
                  } else if (state is SearchPageStateFailure) {
                    return FailureWidget();
                  }

                  // 一瞬のため、あえて空表示
                  return Container();
                })));
  }

  Widget _buildPageStateSuccess(
      BuildContext context, SearchPageStateSuccess state) {
    LoginModel loginModel = context.read<LoginModel>();

    return BlocProvider<BeltSearchBloc>(
      create: (_) => BeltSearchBloc(
        repository: BeltsFirebaseRepository(),
        beltM: state.beltM,
      )..add(BeltSearchEventSearch(userId: loginModel.uid)),
      child: Builder(
        builder: (context) => BlocProvider(
          create: (_) => SearchFormBloc(
            userId: loginModel.uid,
            beltsM: state.beltM,
            searchBloc: context.read<BeltSearchBloc>(),
          ),
          child: Builder(
            builder: (context) => Column(children: [
              SpaceBox(height: 30),
              _buildAlwaysSearchCond(context),
              SpaceBox(height: 20),
              _buildExpandableSearchCond(context),
              SpaceBox(height: 10),
              _buildButtonArea(context),
              SpaceBox(height: 10),
              _buildBeltTable(context),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildAlwaysSearchCond(BuildContext context) {
    final formBloc = context.read<SearchFormBloc>();

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 800),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 5,
            child: _SearchCondDropDownField(
              labelText: "装備",
              selectFieldBloc: formBloc.beltType,
              itemBuilder: (context, e) => e.name,
            ),
          ),
          Spacer(flex: 1),
          Flexible(
            flex: 7,
            child: _SearchCondDropDownField(
              labelText: "効果種類",
              selectFieldBloc: formBloc.effectType,
              itemBuilder: (context, e) => e.kindName,
            ),
          ),
          Spacer(flex: 1),
          Flexible(
            flex: 3,
            child: _SearchCondDropDownField(
              labelText: "効果",
              selectFieldBloc: formBloc.effectValue,
              itemBuilder: (context, e) => e.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSearchCond(BuildContext context) {
    final formBloc = context.read<SearchFormBloc>();

    return Center(
      child: ExpandableNotifier(
        child: Expandable(
          theme: ExpandableThemeData(),
          collapsed: _buildExpandableButton(
              context, "高度な検索条件を表示する", Icons.arrow_drop_down),
          expanded: Column(
            children: [
              SpaceBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 17,
                    child: _SearchCondTextField(
                      textFieldBloc: formBloc.memoField,
                      labelText: "メモ",
                    ),
                  ),
                  Spacer(flex: 1),
                  Flexible(
                    flex: 17,
                    child: _SearchCondTextField(
                      textFieldBloc: formBloc.locationField,
                      labelText: "倉庫",
                    ),
                  ),
                ],
              ),
              SpaceBox(height: 10),
              _buildExpandableButton(
                  context, "高度な検索条件を表示する", Icons.arrow_drop_up),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonArea(BuildContext context) {
    final formBloc = context.read<SearchFormBloc>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 180,
          height: 40,
          child: ElevatedButton(
            onPressed: () => formBloc.clear(),
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                onPrimary: Theme.of(context).accentColor,
                side: BorderSide(
                  color: Theme.of(context).accentColor,
                  width: 1,
                )).merge(Theme.of(context).elevatedButtonTheme.style),
            child: Text("検索条件をクリアする"),
          ),
        ),
        SizedBox(
          width: 180,
          height: 40,
          child: ElevatedButton(
            onPressed: () => formBloc.submit(),
            child: Text("この条件で検索する"),
          ),
        ),
      ],
    );
  }

  Widget _buildBeltTable(BuildContext context) {
    return BlocBuilder<BeltSearchBloc, BeltSearchState>(
        builder: (context, state) {
      if (state is BeltSearchStateSuccess) {
        return SearchResultTable(
          beltRowModels: state.beltRowModels,
          columnTitles: state.columnTitles,
          horizontalBodyController: _horizontalBodyController,
          horizontalTitleController: _horizontalTitleController,
          verticalBodyController: _verticalBodyController,
          verticalTitleController: _verticalTitleController,
          onSelectRow: (beltModel) => BeltRegistDialog.show(
            context,
            beltId: beltModel.id,
            onUpdated: () => context.read<SearchFormBloc>().submit(),
          ),
        );
      } else if (state is BeltSearchStateFailure) {
        return Container();
      }
      return SlimeIndicator();
    });
  }

  Widget _buildExpandableButton(
      BuildContext context, String text, IconData iconData) {
    return ExpandableButton(
      theme: ExpandableThemeData(
        useInkWell: false,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      ),
    );
  }
}

class _SearchCondDropDownField extends StatelessWidget {
  final SelectFieldBloc selectFieldBloc;
  final bool showEmptyItem;
  final String labelText;
  final String Function(BuildContext context, dynamic obj) itemBuilder;

  const _SearchCondDropDownField({
    Key? key,
    required this.selectFieldBloc,
    this.showEmptyItem = true,
    required this.labelText,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownFieldBlocBuilder(
      selectFieldBloc: selectFieldBloc,
      itemBuilder: itemBuilder,
      showEmptyItem: showEmptyItem,
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.headline3,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Theme.of(context).accentColor,
            ),
          )),
    );
  }
}

class _SearchCondTextField extends StatelessWidget {
  final TextFieldBloc textFieldBloc;
  final String labelText;

  const _SearchCondTextField({
    Key? key,
    required this.textFieldBloc,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldBlocBuilder(
      textFieldBloc: textFieldBloc,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.headline3,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          width: 1,
          color: Theme.of(context).accentColor,
        )),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
          width: 1,
          color: Theme.of(context).accentColor,
        )),
      ),
      cursorColor: Theme.of(context).accentColor,
    );
  }
}
