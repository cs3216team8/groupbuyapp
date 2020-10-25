import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/chat/chat_list_screen.dart';
import 'package:groupbuyapp/utils/navigators.dart';


PreferredSize BackAppBar({
  @required BuildContext context,
  @required String title,
  double elevation = 0,
  Color color=Colors.white,
  Color textColor=Colors.black,
  Color iconColor=Colors.black,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(50.0),
    child: AppBar(
      elevation: elevation,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: iconColor,),
        onPressed:() {
          Navigator.pop(context);
        },
      ),
      title: Container(
        child: Text(title, style: TextStyle(color: textColor,),),
      ),
      backgroundColor: color,
    ),
  );
}

PreferredSize RegularAppBar({
  @required BuildContext context,
  @required Widget titleElement,
  double elevation = 0,
  Color color = Colors.white,
  Color iconColor = Colors.black,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(50.0), // here the desired height
    child: AppBar(
      elevation: elevation,
      title: titleElement,
      backgroundColor: color,
      actions: [
        IconButton(
            icon: Icon(Icons.chat_bubble_outline_rounded, color: iconColor),
            onPressed: () => segueToPage(context, ChatList())
        ),
      ],
    ),
  );
}
