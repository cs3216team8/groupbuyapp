import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/review_model.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  final Color cardColor, shadowColor, splashColor;
  final int splashAlpha;
  final double elevation;

  ReviewCard(
    this.review, {
      Key key,
      this.cardColor = Colors.white,
      this.shadowColor = Colors.black12,
      this.splashColor = Colors.black12,
      this.splashAlpha = 30,
      this.elevation = 10,
  }) : super(key: key);


  String getTimeDifString(Duration timeDiff) {
    String time;
    if (timeDiff.inDays == 0) {
      time = timeDiff.inHours.toString() + "h";
    } else {
      time = timeDiff.inDays.toString() + "d";
    }
    return time;
  }

  // TODO: v2 - expandable reviews unless we restrict length of reviews like twitter?
  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      elevation: elevation,
      shadowColor: shadowColor,
      margin: EdgeInsets.all(0.5),
      child:Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: CircleAvatar(
                          radius: 18,
                          //backgroundImage: Image.network(review.profilePicture).image,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              review.revieweeUserId,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      review.review!=null? Container(
                        child: Text(
                          review.review,
                        ),
                      ): Container(),
                      SizedBox(height: 5,),
                      Container(
                        child: Text(
                          "${getTimeDifString(review.dateTime.difference(DateTime.now()))} ago",
                          style: TextStyle(color: Colors.black45,),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text('${review.rating}', style: TextStyle(color: Colors.black45, fontSize: 18),),
            ],
          ),
        ),
    );
  }
}
