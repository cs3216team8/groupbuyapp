import 'package:geolocator/geolocator.dart';
import 'package:great_circle_distance_calculator/great_circle_distance_calculator.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/models/location_models.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy_request/components/groupbuy_card.dart';

Future<GroupBuyLocation> getCurrentLocation() async {
  try {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return GroupBuyLocation(
        lat: position.latitude, long: position.longitude, address: null);
  } catch (err) {
    return null;
  }
}

double distanceBetween(GroupBuyLocation addr1, GroupBuyLocation addr2) {
  var gcd = GreatCircleDistance.fromDegrees(latitude1: addr1.lat, longitude1: addr1.long, latitude2: addr2.lat, longitude2: addr2.long);
  return gcd.sphericalLawOfCosinesDistance();
}

List<GroupBuyCard> getGroupBuyCardList(List<GroupBuy> groupBuyList) {
  return groupBuyList.map((groupBuy) => GroupBuyCard(groupBuy)).toList();
}

Future<List<GroupBuyCard>> getSortedCardList(List<GroupBuy> groupBuys) async {
  GroupBuyLocation currentLocation = await getCurrentLocation();
  // sort by location first
  if (currentLocation != null) {
    groupBuys.sort((gb1, gb2) =>
        distanceBetween(gb1.address, currentLocation).compareTo(
            distanceBetween(gb2.address, currentLocation)));
  }

  // put open ones on top
  List<GroupBuy> pastGroupBuys =
  groupBuys.where((gb) => !gb.isPresent()).toList();
  List<GroupBuy> closedPresentGroupBuys =
  groupBuys.where((gb) => gb.isPresent() && !gb.isOpen()).toList();
  List<GroupBuy> openPresentGroupBuys =
  groupBuys.where((gb) => gb.isPresent() && gb.isOpen()).toList();
  return getGroupBuyCardList(openPresentGroupBuys) +
      getGroupBuyCardList(closedPresentGroupBuys) +
      getGroupBuyCardList(pastGroupBuys);
}
