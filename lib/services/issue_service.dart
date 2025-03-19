import 'api_service.dart';

class IssueService extends ApiService {
  Future<Map<String, dynamic>> getAllIssues() async {
    return await get('issues');
  }

  Future<Map<String, dynamic>> getIssueById(String id) async {
    return await get('issues/$id');
  }

  Future<Map<String, dynamic>> createIssue(Map<String, dynamic> issueData) async {
    return await post('issues', issueData);
  }

  Future<Map<String, dynamic>> updateIssue(String id, Map<String, dynamic> issueData) async {
    return await put('issues/$id', issueData);
  }

  Future<Map<String, dynamic>> deleteIssue(String id) async {
    return await delete('issues/$id');
  }

  Future<Map<String, dynamic>> resolveIssue(String id, Map<String, dynamic> resolutionData) async {
    return await put('issues/$id/resolve', resolutionData);
  }
} 