/* import 'package:flutter_example_1/country_data/model/country_model.dart';
import 'package:flutter_example_1/country_data/provider/country_api.dart'; */
 
  

import '../model/country_model.dart';
import '../provider/country_api.dart';

class CountryService {
  final _api = CountryApi();
  Future<List<Country>?> getAllCountries() async => _api.getAllCountries();
}