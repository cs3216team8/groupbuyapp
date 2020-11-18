class Review {
  final String revieweeUserId;
  final double rating;
  final String review;
  final DateTime dateTime;

  Review (
      this.revieweeUserId,
      this.rating,
      this.review,
      this.dateTime,
      );


  static Review getDummyData() {
    return new Review (
        "abcd1234",
        4.7,
        "The seller is very friendly and is on time",
        DateTime.now(),
    );
  }

  double getRating() {
    return this.rating;
  }
}