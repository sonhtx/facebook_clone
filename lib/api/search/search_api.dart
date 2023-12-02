
import 'dart:convert';

import '../../constants.dart';
import '../../models/request/ReqSearch.dart';
import '../../storage.dart';
import 'package:http/http.dart' as http;

class SearchApi{
  late String token;
  late Map<String, String> headers = {};

  SearchApi() {
    // Initialize headers by fetching the token from secure storage
  }


  Future<void> _initializeHeaders() async {
    // Fetch the token from secure storage
    token = (await getJwt())!; // Replace with your actual code to get the token

    // Update the headers with the fetched token
    headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future search(ReqSearch req) async{
    await _initializeHeaders();

    final String jsonData = jsonEncode(req.toJson());
    final response = await http.post(
      Uri.parse('$apiUrl/search'),
      headers: headers,
      body: jsonData,
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      return jsonResponse; // get list success
    } else {
      return null; // get list false
    }
  }

  Future getSavedSearch(String index, String count) async{
    await _initializeHeaders();
    final Map<String, dynamic> requestBody = {
      "index" : index,
      "count" : count
    };
    final response = await http.post(
      Uri.parse('$apiUrl/get_saved_search'),
      headers: headers,
      body: json.encode(requestBody),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      return jsonResponse; // get list success
    } else {
      return null; // get list false
    }
  }

  Future delSavedSearch(String searchId, String all) async{
    await _initializeHeaders();
    final Map<String, dynamic> requestBody = {
      "search_id" : searchId,
      "all" : all
    };
    final response = await http.post(
      Uri.parse('$apiUrl/del_saved_search'),
      headers: headers,
      body: json.encode(requestBody),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      return jsonResponse; // get list success
    } else {
      return null; // get list false
    }
  }

}