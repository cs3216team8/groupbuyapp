import 'package:public_suffix/public_suffix_io.dart';

String getShortenedStoreName(String originalStoreName) {
  PublicSuffix parsedUrl =
  PublicSuffix.fromString(originalStoreName);
  return (parsedUrl.suffix); // github.io

}
