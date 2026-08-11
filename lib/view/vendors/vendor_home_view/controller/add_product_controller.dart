import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../../../res/res.dart';
import '../../../../utils/utils.dart';
import '../../../view.dart';

class AddProductController extends GetxController {

  Future<void> getProductAddResponse({
    required List<dio.MultipartFile> images,
    required String name,
    required String details,
    required String category,
    required double price,
    required double quantity,
    required double discount,
    required Function onSuccess,
    required Function onFail,
    required Function onExceptionFail
  }) async {
    try {

      LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(jsonDecode(LocalStorageUtils.getString(AppConstantUtils.loginResponse)!),);


      Map<String,dynamic> data = {
        "name": name,
        "category": category,
        "price": price,
        "description": details,
        "quantity": quantity,
        "discount": discount,
      };

      print(jsonEncode(data));

      print(images.length);

      dio.FormData formData = dio.FormData.fromMap({
        "images": images,
        "data": jsonEncode(data),
      });




      var response = await dio.Dio().post(
        "${AppApiUrl.serverLinkUrl()}products",
        data: formData,
        options: dio.Options(headers: <String, String>{
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer ${loginResponseModel.data?.accessToken}'
        }),
      );
      print(jsonEncode(response.data));
      if (response.statusCode == 200 || response.statusCode == 201) {
        onSuccess(response.data["message"]);
      } else {
        onFail(response.data["message"]);
      }
    } on dio.DioException catch (e) {
      print(e.response?.data);
      onExceptionFail(e.response?.data["message"]);
    }
  }



}
