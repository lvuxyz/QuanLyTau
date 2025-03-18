abstract class IssueEvent {}

class LoadIssues extends IssueEvent {}

class CreateIssue extends IssueEvent {
  final Map<String, dynamic> issueData;

  CreateIssue({required this.issueData});
}

class UpdateIssue extends IssueEvent {
  final String issueId;
  final Map<String, dynamic> issueData;

  UpdateIssue({required this.issueId, required this.issueData});
}

class DeleteIssue extends IssueEvent {
  final String issueId;

  DeleteIssue({required this.issueId});
}

class ResolveIssue extends IssueEvent {
  final String issueId;
  final Map<String, dynamic> resolutionData;

  ResolveIssue({required this.issueId, required this.resolutionData});
} 