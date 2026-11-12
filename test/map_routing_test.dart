import 'package:flutter_test/flutter_test.dart';
import 'package:rayan_garden/core/utils/map_routing.dart';

void main() {
  test('uses the verified Rayan Garden coordinates in native Geo Intent', () {
    expect(MapRouting.geoUri.scheme, 'geo');
    expect(MapRouting.geoUri.toString(), contains('geo:36.3290299,52.3573811'));
    expect(MapRouting.geoUri.toString(), contains('Rayan+Garden'));
  });

  test('builds a Google Maps web fallback with the same coordinates', () {
    expect(MapRouting.webUri.scheme, 'https');
    expect(MapRouting.webUri.host, 'www.google.com');
    expect(MapRouting.webUri.path, '/maps/search/');
    expect(MapRouting.webUri.queryParameters['api'], '1');
    expect(MapRouting.webUri.queryParameters['query'], '36.3290299,52.3573811');
  });
}
