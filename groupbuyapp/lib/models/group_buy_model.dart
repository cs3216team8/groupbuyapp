import 'Buy.dart';

class GroupBuy {
  final String storeName;
  final String storeWebsite;
  final String storeLogo;
  final double currentAmount;
  final double targetAmount;
  final double endTimestamp;
  final String username;
  final double deposit;
  final String description;
  final String address;

  GroupBuy(
      this.storeName,
      this.storeWebsite,
      this.storeLogo,
      this.currentAmount,
      this.targetAmount,
      this.endTimestamp,
      this.username,
      this.deposit,
      this.description,
      this.address
      );


  static GroupBuy getDummyData() {
    return new GroupBuy(
        "amazon.sg",
        "https://www.amazon.sg/",
        "https://thumbor.forbes.com/thumbor/fit-in/416x416/filters%3Aformat%28jpg%29/https%3A%2F%2Fspecials-images.forbesimg.com%2Fimageserve%2F5d825aa26de3150009a4616c%2F0x0.jpg%3Fbackground%3D000000%26cropX1%3D0%26cropX2%3D416%26cropY1%3D0%26cropY2%3D416",
        0,
        80,
        1602865379,
        "dawo",
        0.8,
        "Trusted and fast purchase",
        "17 Dover Cres 130017"
    );
  }

  static List<GroupBuy> getDummyDataAllGroupBuys() {
    return [getDummyData(), getDummyData(), getDummyData()];
  }

  static List<Buy> getDummyDataBuysOfGroupBuy() {
    return [Buy.getDummyData(), Buy.getDummyData(), Buy.getDummyData()];
  }
}