class Groupbuy {
  final String groupbuyId;
  final String buyerId;
  final String storeName, website;
  final String logo;
  double _targetAmount, _currentAmount = 0;
  DateTime _timeEnd;
  final String address;

  Groupbuy(
      this.groupbuyId,
      this.buyerId, this.address,
      this.storeName, this.website, this.logo,
      this._timeEnd, this._targetAmount);

  Groupbuy.withNonZeroCurrentAmount(
      this.groupbuyId,
      this.buyerId, this.address,
      this.storeName, this.website, this.logo,
      this._timeEnd, this._targetAmount, this._currentAmount);

  double getTargetAmount() {
    return this._targetAmount;
  }

  double getCurrentAmount() {
    return this._currentAmount;
  }

  DateTime getTimeEnd() {
    return this._timeEnd;
  }

  void setTargetAmount(double amt) {
    this._targetAmount = amt;
  }

  void addAmount(double amt) {
    this._currentAmount += amt;
  }

  void removeAmount(double amt) {
    assert(this._currentAmount - amt >= 0, "Error: attempting to remove more than current amount.");
    this._currentAmount -= amt;
  }
}
