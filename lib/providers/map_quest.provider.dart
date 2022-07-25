import 'package:fruit_basket/models/requests/geolocation.model.dart';

import 'base.provider.dart';

class MapQuestProvider extends BaseProvider {
  final String _geoKey = 'bWsUWAS8RQNeebOlryGyzfXTpiGghOpv';
  final String _geoUrl = 'http://www.mapquestapi.com/geocoding/v1/reverse/';

  Future<GeolocationModel> getAddress({required String latLng}) async {
    return await super.get(
      url: _geoUrl,
      params: {'key': _geoKey, 'location': latLng},
      formatter: (response) => GeolocationModel.fromJson(response),
    );
  }
}
