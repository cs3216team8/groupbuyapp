import 'package:flutter/cupertino.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';

import 'package:groupbuyapp/CONFIDENTIAL/api_keys.dart';
import 'package:groupbuyapp/models/location_models.dart';

Future<Prediction> searchLocation(BuildContext context) async {
  return PlacesAutocomplete.show(
    context: context,
    apiKey: placesApiKey,
    mode: Mode.overlay, //Mode.fullscreen,
    language: "en",
    components: [Component(Component.country, "sg")]
  );
}

Future<GroupBuyLocation> getLatLong(Prediction prediction) async {
  GoogleMapsPlaces _places = new GoogleMapsPlaces(apiKey: placesApiKey);
  PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(prediction.placeId);

  double lat = detail.result.geometry.location.lat;
  double long = detail.result.geometry.location.lng;
  String address = prediction.description;
  return GroupBuyLocation(lat: lat, long: long, address: address);
}
