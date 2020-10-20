
class UserProfile {
  final String name;
  final String username;
  final String profilePicture;
  final String phoneNumber;
  final String email;
  final List<String> addresses;
  final List<String> groupBuyIds;

  UserProfile (
      this.name,
      this.username,
      this.profilePicture,
      this.phoneNumber,
      this.email,
      this.addresses,
      this.groupBuyIds,
      );


  static UserProfile getDummyData() {
    return new UserProfile (
        "Daniel Wong",
        "dawo",
        'https://d1cbe14be5894c8dcc3d-8a742a0d46bf003746b2a98abb2fa3cf.ssl.cf2.rackcdn.com/wp-content/uploads/2018/01/personal-questions-to-ask-a-guy-2.jpg',
        "+65 1234 5678",
        "me@dawo.me",
        ["17 Dover Cres 130017", "18 Dover Cres 130017"],
        ["asdfasdfasdfaf", "asdfasdfasdfaf"]
    );
  }
}