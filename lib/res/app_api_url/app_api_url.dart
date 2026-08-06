import 'package:flutter/foundation.dart';


class AppApiUrl {
 
  static String serverLinkUrl() {
    if(kDebugMode){
      //return "http://192.168.10.204:5007/api/v1/";
      return "http://10.10.10.25:5001/api/v1/";
    }else{
      //return "http://192.168.10.204:5007/api/v1/";
      return "http://10.10.10.25:5001/api/v1/";
    }
  }
}