import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/issue_service.dart';
import 'issue_event.dart';
import 'issue_state.dart';

class IssueBloc extends Bloc<IssueEvent, IssueState> {
  final IssueService _issueService;

  IssueBloc({
    required IssueService issueService,
  })  : _issueService = issueService,
        super(IssueInitial()) {
    on<LoadIssues>(_onLoadIssues);
    on<CreateIssue>(_onCreateIssue);
    on<UpdateIssue>(_onUpdateIssue);
    on<DeleteIssue>(_onDeleteIssue);
    on<ResolveIssue>(_onResolveIssue);
  }

  Future<void> _onLoadIssues(
    LoadIssues event,
    Emitter<IssueState> emit,
  ) async {
    emit(IssueLoading());
    try {
      final result = await _issueService.getAllIssues();
      if (result['success'] == true) {
        emit(IssueLoaded(issues: result['data']));
      } else {
        emit(IssueError(message: result['message']));
      }
    } catch (e) {
      emit(IssueError(message: e.toString()));
    }
  }

  Future<void> _onCreateIssue(
    CreateIssue event,
    Emitter<IssueState> emit,
  ) async {
    try {
      final result = await _issueService.createIssue(event.issueData);
      if (result['success'] == true) {
        add(LoadIssues());
      } else {
        emit(IssueError(message: result['message']));
      }
    } catch (e) {
      emit(IssueError(message: e.toString()));
    }
  }

  Future<void> _onUpdateIssue(
    UpdateIssue event,
    Emitter<IssueState> emit,
  ) async {
    try {
      final result = await _issueService.updateIssue(event.issueId, event.issueData);
      if (result['success'] == true) {
        add(LoadIssues());
      } else {
        emit(IssueError(message: result['message']));
      }
    } catch (e) {
      emit(IssueError(message: e.toString()));
    }
  }

  Future<void> _onDeleteIssue(
    DeleteIssue event,
    Emitter<IssueState> emit,
  ) async {
    try {
      final result = await _issueService.deleteIssue(event.issueId);
      if (result['success'] == true) {
        add(LoadIssues());
      } else {
        emit(IssueError(message: result['message']));
      }
    } catch (e) {
      emit(IssueError(message: e.toString()));
    }
  }

  Future<void> _onResolveIssue(
    ResolveIssue event,
    Emitter<IssueState> emit,
  ) async {
    try {
      final result = await _issueService.resolveIssue(event.issueId, event.resolutionData);
      if (result['success'] == true) {
        add(LoadIssues());
      } else {
        emit(IssueError(message: result['message']));
      }
    } catch (e) {
      emit(IssueError(message: e.toString()));
    }
  }
} 