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
      child: InkWell(
        //TODO think if want splash or not aka want to appear tappable or not
        //onTap: _openDetailedReview,
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: CircleAvatar(
                            radius: 13,
                            backgroundImage: Image.network(review.profilePicture).image,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text(review.username),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(review.dateTime.toString()),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(review.title, style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('${review.rating} stars'),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(review.description),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
