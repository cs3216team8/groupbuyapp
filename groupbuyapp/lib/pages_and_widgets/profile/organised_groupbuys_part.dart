import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/models/profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets/components/grid_card_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/create_groupbuy_widget.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/utils/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'my_groupbuys_widget.dart';

class OrganisedGroupBuysOnly extends StatelessWidget {
  final String userId;
  Future<Profile> fprofile;

  OrganisedGroupBuysOnly({
    Key key,
    @required this.userId,
    @required this.fprofile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(50),
        //
        //   child: AppBar(
        //
        //     elevation: 0,
        //     backgroundColor: Colors.transparent,
        //     bottom: PreferredSizeW(
        //
        //     // bottom: TabBar(
        //     // labelStyle: Styles.textStyleSelected,  //For Selected tab
        //     //
        //     // tabs: [
        //     // Tab(text: "As Organiser",),
        //     // ],
        //   ),
        //   )
        // ),
        body:
        SingleChildScrollView(

          child: Column(
            children: [
              Container(
                alignment: Alignment.center,

                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border(bottom:BorderSide(color: Color(0xFFe87d74)))),
                height: 50,
                child: Text('As Organiser', style: Styles.textStyleSelected,)
              ),
              StreamBuilder<List<GroupBuy>>(
                stream: GroupBuyStorage.instance.getGroupBuysOrganisedBy(userId),
                builder: (BuildContext context, AsyncSnapshot<List<GroupBuy>> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return FailedToLoadMyGroupBuys();
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
                    return OrganisedGroupBuyDefaultScreen();
                  }

                  return GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      childAspectRatio: 5.5/7.0,
                      children: children
                  );
                },
              ),
            ],
          ),
      ),
    );
  }
}

class OrganisedGroupBuyDefaultScreen extends StatelessWidget {
  final String uname;

  OrganisedGroupBuyDefaultScreen({
    Key key,
    this.uname,
  }) : super(key: key);

  bool isMe() {
    return uname == null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20.0,),
        isMe()
        ? Column(
          children: <Widget>[
            Container(
              child: SvgPicture.asset(
                'assets/undraw_empty_xct9.svg',
                height: 200,

              ),
              padding: EdgeInsets.all(10),
            ),
            Text(
              "You haven't organised any group buys!",
              style: Styles.emptyStyle,
              textAlign: TextAlign.center,
            ),
            RaisedButton(
                onPressed: () => segueToPage(context, CreateGroupBuyScreen(needsBackButton: true,)),
                textColor: Colors.white,
                child: Text(
                    'Organise one!',
                    style: TextStyle(fontSize: 20)
                )
            ),
          ],
        )
        :
        Column(
          children: <Widget>[
            SizedBox(height: 20.0,),
            Container(
              child: SvgPicture.asset(
                'assets/undraw_empty_xct9.svg',
                height: 200,

              ),
              padding: EdgeInsets.all(10),
            ),

            Text(
              "${uname} has yet to organise any group buys.",
              style: Styles.emptyStyle,
              textAlign: TextAlign.center,
            ),
          ],
        )

      ],
    )
    )
    );
  }
}