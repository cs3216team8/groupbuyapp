class Review {
  final String revieweeUserId;
  final String reviewerUserId;
  final double rating;
  final String review;
  final DateTime dateTime;

  Review (
      this.revieweeUserId,
      this.rating,
      this.review,
      this.dateTime,
      {this.reviewerUserId}

      );


  static Review getDummyData() {
    return new Review (
        "abcd1234",
      4.7,
        "The seller is very friendly and is on time",
        DateTime.now(),
      reviewerUserId: "abcd5678",
    );
  }

  double getRating() {
    return this.rating;
  }
}