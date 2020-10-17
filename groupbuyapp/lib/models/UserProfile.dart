
class UserProfile {
  final String name;
  final String username;
  final String phoneNumber;
  final String email;
  final List<String> addresses;
  final List<String> groupBuyIds;

  UserProfile (
      this.name,
      this.username,
      this.phoneNumber,
      this.email,
      this.addresses,
      this.groupBuyIds,
      );


  static UserProfile getDummyData() {
    return new UserProfile (
        "Daniel Wong",
        "dawo",
        "+65 1234 5678",
        "me@dawo.me",
        ["17 Dover Cres 130017", "18 Dover Cres 130017"],
        ["asdfasdfasdfaf", "asdfasdfasdfaf"]
    );
  }

  static List<GroupBuy> getDummyDataAllGroupBuys() {
    return [getDummyDataOneGroupBuy(), getDummyDataOneGroupBuy(), getDummyDataOneGroupBuy()];
  }

  static List<Buy> getDummyDataBuysOfGroupBuy() {
    return [Buy.getDummyData(), Buy.getDummyData(), Buy.getDummyData()];
  }
}