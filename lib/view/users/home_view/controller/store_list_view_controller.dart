import 'dart:convert';
import 'package:discount_me_app/view/view.dart';
import '../../../../utils/utils.dart';

class StoreListViewController {
  static Future<void> getStoriesApiService({
    required Function onSuccess,
    required Function onFail,
    required Function onExceptionFail,
  }) async {
    final loginResponseModel = LoginResponseModel.fromJson(
      jsonDecode(
        LocalStorageUtils.getString(AppConstantUtils.loginResponse)!,
      ),
    );

    await BaseApiUtils.get(
      url: ApiUtils.getAllStoresResponse,
      authorization: loginResponseModel.data?.accessToken,
      onSuccess: (message, data) => onSuccess(data),
      onFail: (message, data) => onFail(message),
      onExceptionFail: (message, data) => onExceptionFail(message),
    );
  }

  static Future<void> getStoriesApiServiceSearchWithLatLongValue({
    required double lat,
    required double long,
    required Function onSuccess,
    required Function onFail,
    required Function onExceptionFail,
  }) async {
    final loginResponseModel = LoginResponseModel.fromJson(
      jsonDecode(
        LocalStorageUtils.getString(AppConstantUtils.loginResponse)!,
      ),
    );

    await BaseApiUtils.get(
      url: "${ApiUtils.baseUrl}/stores?coordinates=[$long,$lat]",
      authorization: loginResponseModel.data?.accessToken,
      onSuccess: (message, data) => onSuccess(data),
      onFail: (message, data) => onFail(message),
      onExceptionFail: (message, data) => onExceptionFail(message),
    );
  }
}
