import 'package:nopcart_flutter/model/RewardPointResponse.dart';
import 'package:nopcart_flutter/networking/ApiBaseHelper.dart';
import 'package:nopcart_flutter/networking/Endpoints.dart';

class RewardPointRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<RewardPointResponse> fetchRawardPointDetails(num pageNumber) async {
    final response = await _helper.get('${Endpoints.rewardPoints}/$pageNumber');
    return RewardPointResponse.fromJson(response);
  }
}