import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/home/home_banner.dart';
import 'package:groupbuyapp/pages_and_widgets/home/home_default.dart';
import 'package:groupbuyapp/pages_and_widgets/components/listings_section.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:groupbuyapp/utils/navigators.dart';

import '../chat_list.dart';

class HomeScreen extends StatefulWidget {
  final GroupBuyStorage groupBuyStorage;

  HomeScreen({
    Key key,
    @required this.groupBuyStorage,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color appbarColor = Colors.white;
  final Color appbarElementColor = Colors.black;
  final Color appbarTextColor = Colors.black;

  // SEARCH FUNCTIONALITY
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
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
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.clear, color: appbarElementColor,),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
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

    return <Widget>[
      IconButton(
        icon: Icon(Icons.search, color: appbarElementColor,),
        onPressed: _startSearch,
      ),
      IconButton(
          icon: Icon(Icons.chat_bubble_outline_rounded, color: appbarElementColor),
          onPressed: () => segueToPage(context, ChatList())
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
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
          backgroundColor: appbarColor,
          leading: _isSearching ? const BackButton() : Container(),
          title: _isSearching ? _buildSearchField() : Text("testing"),//_buildTitle(context),
          actions: _buildActions(),
          // actions: [
          //   IconButton(
          //       icon: Icon(Icons.chat_bubble_outline_rounded, color: iconColor),
          //       onPressed: () => segueToPage(context, ChatList())
          //   ),
          // ],
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
                createGroupBuyStream: widget.groupBuyStorage.getAllGroupBuys,
                createDefaultScreen: () => HomeDefaultScreen(),
              )
            ],
          )
      ),
    );
  }
}
