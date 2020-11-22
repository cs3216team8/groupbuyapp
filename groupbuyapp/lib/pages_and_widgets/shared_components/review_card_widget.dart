import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:groupbuyapp/models/profile_model.dart';
import 'package:groupbuyapp/models/review_model.dart';
import 'package:groupbuyapp/storage/profile_storage.dart';
import 'package:groupbuyapp/utils/styles.dart';

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
      this.elevation = 0,
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
      child: FutureBuilder(
        future: ProfileStorage.instance.getUserProfile(review.reviewerUserId),
        builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
          if (snapshot.hasError) {
            return Text("Failed to load request.");
          }

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text("Git blame developers.");
            case ConnectionState.waiting:
              return Center(child: SizedBox(height: 50, width: 50, child: CircularProgressIndicator(),),); //TODO for refactoring
            default:
              break;
          }

          return Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: CircleAvatar(
                                radius: 22,
                                backgroundImage: Image.network(snapshot.data.profilePicture).image,
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
                                    snapshot.data.username,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                            RatingBarIndicator(
                              rating: review.rating,
                              itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 18,
                              direction: Axis.horizontal,
                              ),
                            Container(
                              child: Text(
                                review.dateTime.toString(),
                                style: Styles.reviewDateStyle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Divider(
                      color: Color(0xFFD9D9D9),
                      height: 1.5,
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: review.review!=null? Text(review.review, style: Styles.textStyle,): Container()
                    )
                  ],
                ),
          );
        }
      )
    );
  }
}
