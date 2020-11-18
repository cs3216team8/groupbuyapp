import 'package:flutter/material.dart';

class ReviewInputSectionLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
          child: const CircularProgressIndicator(),
          width: 60,
          height: 60,
        )
    );
  }
}

class FailedToLoadReviewInputSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text("Oh no! Seems like there is something wrong with the connnection! Please pull to refresh or try again later."),
      ),
    );
  }
}

//TODO note this condition.
class ReviewInputSectionNotLoaded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text("Review section are loaded. Git blame developers."),
      ),
    );
  }
}