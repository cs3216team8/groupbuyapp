class Review {
  final String revieweeUserId;
  final String reviewerUserId;
  final double rating;
  final String review;
  final DateTime dateTime;

  Review (
      this.revieweeUserId,
      this.reviewerUserId,
      this.rating,
      this.review,
      this.dateTime,
      );


  static Review getDummyData() {
    return new Review (
        "abcd1234",
      "abcd5678",
      4.7,
        "The seller is very friendly and is on time",
        DateTime.now(),
    );
  }

  double getRating() {
    return this.rating;
  }
}