class Review {
  final String username;
  final String profilePicture;
  final double rating;
  final String review;
  final DateTime dateTime;

  Review (
      this.username,
      this.profilePicture,
      this.rating,
      this.review,
      this.dateTime,
      );


  static Review getDummyData() {
    return new Review (
        "dawo",
        "https://haircutinspiration.com/wp-content/uploads/Voluminous-Comb-Over-1-1.jpg",
        4.7,
        "The seller is very friendly and is on time",
        DateTime.now(),
    );
  }

  double getRating() {
    return this.rating;
  }
}