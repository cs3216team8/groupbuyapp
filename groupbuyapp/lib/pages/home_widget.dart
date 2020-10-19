import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages/components/grid_card_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const TextStyle optionStyle = TextStyle(fontSize:  30, fontWeight: FontWeight.bold);

  bool _shouldShowDefaultScreen = true;

  void _showOrHideDefault(bool shouldShow) {
    setState(() {
      _shouldShowDefaultScreen = shouldShow;
    });
  }

  void _makeGroupbuyRequest() {
    print("request button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10),
            child: CarouselSlider(
                items: [
                  Image.network("https://pbs.twimg.com/media/D-jnKUPU4AE3hVR?format=jpg&name=large"),
                  Image.network("https://pbs.twimg.com/media/D-jnNTvUEAAGLvE?format=jpg&name=large"),
                  Image.network("https://pbs.twimg.com/media/D-jnUF5UIAEA6Cl?format=jpg&name=large"),
                  Image.network("https://pbs.twimg.com/media/D-jnXCiU0AASd7-?format=jpg&name=large"),
                ],
                options: CarouselOptions(
                  height: 120,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  enlargeCenterPage: false,
                )
            ),
          ),
          Stack(
            children: <Widget>[
              // Column( // for no entries, if have entry, make invisible
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Text('Your neighbours have yet to request!', style: optionStyle, textAlign: TextAlign.center,),
              //     RaisedButton(
              //       onPressed: _makeGroupbuyRequest,
              //       textColor: Colors.white,
              //       child: Text(
              //             'Be the first',
              //             style: TextStyle(fontSize: 20)
              //         )
              //       ),
              //   ],
              // ),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                childAspectRatio: 6.0/7.0,
                children: List.generate(5, (index) { // placeholder for GridCards[]
                    return GroupbuyCard(placeholder);
                  }),
              )
            ],
          )
        ],
      ),
    );
  }
}
