import 'package:groupbuyapp/models/location_models.dart';

class Profile {
  final String userId;
  final String name;
  final String username;
  final String profilePicture;
  final String phoneNumber;
  final String email;
  final String authType;
  final List<GroupBuyLocation> addresses;

  double rating; //TODO @agnes
  int reviewCount;

  Profile (
      this.userId,
      this.name,
      this.username,
      this.profilePicture,
      this.phoneNumber,
      this.email,
      this.authType,
      this.addresses,
      this.rating,
      this.reviewCount
      );

  String getActiveStatus() {
    // TODO?
    return "Verified, very active";
  }

  static Profile getDummyData() {
    return new Profile (
        "3434sgdfga",
        "Daniel Wong",
        "dawo",
        'https://d1cbe14be5894c8dcc3d-8a742a0d46bf003746b2a98abb2fa3cf.ssl.cf2.rackcdn.com/wp-content/uploads/2018/01/personal-questions-to-ask-a-guy-2.jpg',
        "+65 1234 5678",
        "me@dawo.me",
        "native",
        [],
        4.9,
        500
    );
  }
}