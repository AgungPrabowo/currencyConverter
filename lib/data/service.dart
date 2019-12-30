import 'package:currency_converter/error/api_error.dart';
import 'package:currency_converter/model/convertion.dart';
import 'package:currency_converter/model/rates.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
class Service {
  
  String url = "https://api.exchangerate-api.com/v4/latest/";

  String get rates {
    return url;
  }

  dynamic getRates() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final currencyParam = preferences.getString("currencyParam") ?? '';
    
    var url = rates + currencyParam;
    final response = await http.get(url);
    final map = json.decode(response.body);

    if (response.statusCode == 200) {
      final ratesJSON = map["rates"];
      final ratesObject = Rates.fromJson(ratesJSON);

      ratesObject.initValues();
      
      return ratesObject.rates;
    }
    else {
      final error = new ApiError.fromJson(map);
      return error;
    }
  }

  dynamic getConvertion() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final currencyParam = preferences.getString("currencyParam") ?? '';

    var url = rates + currencyParam;
    final response = await http.get(url);
    final map = json.decode(response.body);

    if (response.statusCode == 200) {
      final convert = {
        "from": preferences.getString("currencyParam"),
        "to": preferences.getString("toParam"),
        "rate": map["rates"][preferences.getString("toParam")]
      };
      final convertionObject = new Convertion.fromJson(convert);
      
      convertionObject.initValues();

      return convertionObject;
    }
    else {
      final error = new ApiError.fromJson(map);
      return error;
    }
  }

}