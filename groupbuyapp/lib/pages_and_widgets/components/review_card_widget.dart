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

  // TODO: v2 - expandable reviews unless we restrict length of reviews like twitter?
  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      elevation: elevation,
      shadowColor: shadowColor,
      margin: EdgeInsets.all(0.5),
      child: InkWell(
        //TODO think if want splash or not aka want to appear tappable or not
        //onTap: _openDetailedReview,
        child: Container(
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
                          backgroundImage: Image.network(review.profilePicture).image,
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
                              review.username,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          Container(
                            child: Text(
                              review.title,
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Container(
                        child: Text(
                          review.description,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        child: Text(
                          "${review.dateTime.difference(DateTime.now()).inDays} days ago",
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
      ),
    );
  }
}
