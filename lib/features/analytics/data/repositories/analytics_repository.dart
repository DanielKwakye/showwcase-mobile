import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:showwcase_v3/core/network/api_config.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';

class AnalyticsRepository {

  final NetworkProvider _networkProvider;

  AnalyticsRepository(this._networkProvider);

  void sendAnalyticsToCollect(List<Map<String, dynamic>> request) async {

    /// Backend required data to be sent to collect endpoint as well
    try {


      final path = ApiConfig.collect;
      var response = await _networkProvider.call(path: path, method:  RequestMethod.post, body: request);

      if (response!.statusCode == 200) {
        debugPrint("customLog: sendAnalyticsToCollectSuccessful ->  ${response.data}");
      } else {
        debugPrint("customLog: sendAnalyticsToCollectError ->  ${response.data['error']}");
      }
    } catch (e) {
      debugPrint("customLog: sendAnalyticsToCollectError -> ${e.toString()}");

    }

  }

  void sendAnalyticsToFirebase({String? name, Map<String, dynamic>? parameters}){

    /// send to firebase
    FirebaseAnalytics.instance.logEvent(
      name: name ?? '',
      parameters: parameters,
    );
  }



}