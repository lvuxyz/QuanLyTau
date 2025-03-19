import 'api_service.dart';

class SeatConfigService extends ApiService {
  Future<Map<String, dynamic>> getAllSeatConfigs() async {
    return await get('seat-configs');
  }

  Future<Map<String, dynamic>> getSeatConfigById(String id) async {
    return await get('seat-configs/$id');
  }

  Future<Map<String, dynamic>> createSeatConfig(Map<String, dynamic> configData) async {
    return await post('seat-configs', configData);
  }

  Future<Map<String, dynamic>> updateSeatConfig(String id, Map<String, dynamic> configData) async {
    return await put('seat-configs/$id', configData);
  }

  Future<Map<String, dynamic>> deleteSeatConfig(String id) async {
    return await delete('seat-configs/$id');
  }

  Future<Map<String, dynamic>> getSeatConfigByTrain(String trainId) async {
    return await get('seat-configs/train/$trainId');
  }
} 