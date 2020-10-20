
class Review {
  final String username;
  final String profilePicture;
  final double rating;
  final String title;
  final String description;

  Review (
      this.username,
      this.profilePicture,
      this.rating,
      this.title,
      this.description,
      );


  static Review getDummyData() {
    return new Review (
        "dawo",
        "https://haircutinspiration.com/wp-content/uploads/Voluminous-Comb-Over-1-1.jpg",
        4.7,
        "Great Personality",
        "The seller is very friendly and is on time"
    );
  }
}