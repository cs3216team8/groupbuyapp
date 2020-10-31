import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/pages_and_widgets/components/grid_card_widget.dart';

class ListingsSection extends StatefulWidget {
  Stream<List<GroupBuy>> Function() createGroupBuyStream;
  Widget Function() createDefaultScreen;

  ListingsSection({
    Key key,
    @required this.createGroupBuyStream,
    @required this.createDefaultScreen,
  }) : super(key: key);

  @override
  _ListingsSectionState createState() => _ListingsSectionState();
}

class _ListingsSectionState extends State<ListingsSection>
    with AutomaticKeepAliveClientMixin<ListingsSection> {

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<List<GroupBuy>>(
          stream: widget.createGroupBuyStream(),
          builder: (BuildContext context, AsyncSnapshot<List<GroupBuy>> snapshot) {
            List<Widget> children;
            if (snapshot.hasError) {
              return FailedToLoadGroupBuys();
            }

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return GroupBuysNotLoaded();
              case ConnectionState.waiting:
                return GroupbuysLoading();
              default:
                children = snapshot.data.map((GroupBuy groupBuy) {
                  return new GroupBuyCard(groupBuy);
                }).toList();
                break;
            }

            if (children.isEmpty) {
              return widget.createDefaultScreen();
            }

            return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                childAspectRatio: 5.5/7.0,
                children: children
            );
          },
        )
    );
  }
}

class GroupbuysLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: const CircularProgressIndicator(),
      width: 60,
      height: 60,
    );
  }
}

class FailedToLoadGroupBuys extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text("Oh no! Seems like there is something wrong with the connnection! Please pull to refresh or try again later."),
      ),
    );
  }
}

//TODO note this should not appear.
class GroupBuysNotLoaded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text("No groupbuys are loaded. Git blame developers."),
      ),
    );
  }
}
