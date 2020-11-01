import 'package:cloud_firestore/cloud_firestore.dart';

import 'buy_model.dart';

class GroupBuy {
  final String id;
  final String storeName;
  final String storeWebsite;
  final String storeLogo;
  double currentAmount;
  double targetAmount;
  final Timestamp endTimestamp;
  final String organiserId;
  final double deposit;
  final String description;
  final String address;
  List<Buy> buys;

  GroupBuyStatus status;

  GroupBuy(this.id, this.storeName, this.storeWebsite, this.storeLogo,
      this.currentAmount, this.targetAmount, this.endTimestamp,
      this.organiserId, this.deposit, this.description, this.address, this.status,);

  GroupBuy.newOpenBuy(this.id, this.storeName, this.storeWebsite, this.storeLogo,
      this.currentAmount, this.targetAmount, this.endTimestamp,
      this.organiserId, this.deposit, this.description, this.address,) {
    status = GroupBuyStatus.open;
  }

  bool isPresent() {
    return endTimestamp.toDate().isAfter(DateTime.now());
  }

  static GroupBuyStatus groupBuyStatusFromString(String val) {
    switch (val) {
      case 'cancelled':
        return GroupBuyStatus.cancelled;
      case 'closed':
        return GroupBuyStatus.closed;
      case 'open':
        return GroupBuyStatus.open;
      default:
        throw("${val} is not a supported group buy status");
    }
  }

  static String stringFromGroupBuyStatus(GroupBuyStatus status) {
    switch (status) {
      case GroupBuyStatus.cancelled:
        return 'cancelled';
      case GroupBuyStatus.closed:
        return 'closed';
      case GroupBuyStatus.open:
        return 'open';
      default:
        throw("nani not supposed to be here");
    }
  }

  static GroupBuy getDummyData() {
    return new GroupBuy.newOpenBuy(
        "asdasdasdasd",
        "amazon.sg",
        "https://www.amazon.sg/",
        "https://thumbor.forbes.com/thumbor/fit-in/416x416/filters%3Aformat%28jpg%29/https%3A%2F%2Fspecials-images.forbesimg.com%2Fimageserve%2F5d825aa26de3150009a4616c%2F0x0.jpg%3Fbackground%3D000000%26cropX1%3D0%26cropX2%3D416%26cropY1%3D0%26cropY2%3D416",
        0,
        80,
        Timestamp.fromDate(DateTime.now()),
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

  String getId() {
    return this.id;
  }

  void addBuy(Buy buy) {
    this.buys.add(buy);
  }

  void setBuys(List<Buy> buy) {
    this.buys = buy;
  }

  List<Buy> getBuys() {
    return this.buys;
  }

  double getTargetAmount() {
    return this.targetAmount;
  }

  double getCurrentAmount() {
    return this.currentAmount;
  }

  DateTime getTimeEnd() {
    return this.endTimestamp.toDate();
  }

  void setTargetAmount(double amt) {
    this.targetAmount = amt;
  }

  void setCurrentAmount(double amt) {
    this.currentAmount = amt;
  }

  void addAmount(double amt) {
    this.currentAmount += amt;
  }

  void removeAmount(double amt) {
    assert(this.currentAmount - amt >= 0, "Error: attempting to remove more than current amount.");
    this.currentAmount -= amt;
  }

  double getPercentageComplete() {
    if (this.currentAmount >= this.targetAmount) {
      return 1;
    }
    return this.currentAmount/this.targetAmount;
  }

}

enum GroupBuyStatus {
  open, closed, cancelled
}
