import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/chat/chat_list_screen.dart';
\import 'package:groupbuyapp/pages_and_widgets/home/home_banner.dart';
import 'package:groupbuyapp/pages_and_widgets/home/home_default.dart';
import 'package:groupbuyapp/pages_and_widgets/components/home_listings_section.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:groupbuyapp/utils/navigators.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color appbarColor = Colors.white;
  final Color appbarElementColor = Colors.black;
  final Color appbarTextColor = Colors.black;

  // SEARCH FUNCTIONALITY
  TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = "Search query";

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: "Search Piggybuy...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: appbarTextColor.withOpacity(0.7)),
      ),
      style: TextStyle(color: appbarTextColor, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.clear, color: appbarElementColor,),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              // Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
        IconButton(
            icon: Icon(Icons.chat_bubble_outline_rounded, color: appbarElementColor),
            onPressed: () => segueToPage(context, ChatList())
        ),
      ];
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0), // here the desired height
        child: AppBar(
          elevation: 0,
          backgroundColor: appbarColor,
          leading: Container(),
          title: _buildSearchField(),
          actions: _buildActions(),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              HomeCarouselBanner(),
              Container(
                child:
                Text("Groupbuys around you", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              ),
              ListingsSection(
                createGroupBuyStream: GroupBuyStorage.instance.getAllGroupBuys,
                createDefaultScreen: () => HomeDefaultScreen(),
              )
            ],
          )
      ),
    );
  }
}
