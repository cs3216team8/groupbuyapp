import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/chat/chat_list_screen.dart';
import 'package:groupbuyapp/pages_and_widgets/home/home_default.dart';
import 'package:groupbuyapp/pages_and_widgets/home/components/home_listings_section.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:groupbuyapp/utils/navigators.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color appbarColor = Color(0xFFF98B83);
  final Color appbarElementColor = Colors.white;
  final Color appbarTextColor = Colors.white;

  // // SEARCH FUNCTIONALITY
  // TextEditingController _searchQueryController = TextEditingController();
  // String searchQuery = "Search query";

  // Widget _buildSearchField() {
  //   return TextField(
  //     controller: _searchQueryController,
  //     autofocus: false,
  //     decoration: InputDecoration(
  //       hintText: "Search Piggybuy...",
  //       border: InputBorder.none,
  //       hintStyle: TextStyle(color: appbarTextColor.withOpacity(0.7)),
  //     ),
  //     style: TextStyle(color: appbarTextColor, fontSize: 16.0),
  //     onChanged: (query) => updateSearchQuery(query),
  //   );
  // }
  //
  // List<Widget> _buildActions() {
  //     return <Widget>[
  //       IconButton(
  //         icon: Icon(Icons.clear, color: appbarElementColor,),
  //         onPressed: () {
  //           if (_searchQueryController == null ||
  //               _searchQueryController.text.isEmpty) {
  //             // Navigator.pop(context);
  //             return;
  //           }
  //           _clearSearchQuery();
  //         },
  //       ),
  //       IconButton(
  //           icon: Icon(Icons.chat_bubble_outline_rounded, color: appbarElementColor),
  //           onPressed: () => segueWithLoginCheck(context, ChatList())
  //       ),
  //     ];
  // }

  // void updateSearchQuery(String newQuery) {
  //   setState(() {
  //     searchQuery = newQuery;
  //   });
  // }
  //
  // void _clearSearchQuery() {
  //   setState(() {
  //     _searchQueryController.clear();
  //     updateSearchQuery("");
  //   });
  // }

  Future<void> _getData() async {
    setState(() {
    });
  }

  // Future<void> getLocationPermission() async {
  //   var status = await Permission.location.status;
  //
  //   if (status.isUndetermined || status.isDenied) {
  //     Map<Permission, PermissionStatus> statuses = await [
  //       Permission.location,
  //     ].request();
  //
  //     if (statuses[Permission.location] == null) {
  //     return;
  //     }
  //   } else if (status.isPermanentlyDenied) {
  //     openAppSettings();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // getLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0), // here the desired height
        child: AppBar(
          elevation: 0,
          backgroundColor: appbarColor,
          // leading: Container(),
          title: Text("PiggyBuy", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w500, fontSize: 24, color: Colors.white)), //fontSize: 15, fontWeight: FontWeight.normal);),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.chat_bubble_outline_rounded, color: appbarElementColor),
                onPressed: () => segueWithLoginCheck(context, ChatList())
            ),
          ],
          // title: _buildSearchField(),
          // actions: _buildActions(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _getData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 6, left: 6, bottom: 8, right: 6),
                ),
                ListingsSection(
                  createGroupBuyStream: GroupBuyStorage.instance.getAllGroupBuys,
                  createDefaultScreen: () => HomeDefaultScreen(),
                )
              ],
            )
        ),
      ),
    );
  }
}
