abstract class IssueState {}

class IssueInitial extends IssueState {}

class IssueLoading extends IssueState {}

class IssueLoaded extends IssueState {
  final List<dynamic> issues;

  IssueLoaded({required this.issues});
}

class IssueError extends IssueState {
  final String message;

  IssueError({required this.message});
} 