import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<PerformSearch>((event, emit) async {
      emit(SearchLoading());
      try {
        // Simulate API call with a delay
        await Future.delayed(Duration(seconds: 1));

        if (event.query.isEmpty) {
          emit(SearchInitial());
          return;
        }

        // For demonstration purposes, return mock results
        // In a real app, this would fetch data from an API or local database
        final results = [
          {'id': '1', 'name': 'Tàu Cao Tốc A', 'route': 'Vũng Tàu - Côn Đảo'},
          {'id': '2', 'name': 'Tàu Cao Tốc B', 'route': 'Sóc Trăng - Côn Đảo'},
          {'id': '3', 'name': 'Tàu Khách C', 'route': 'Hà Tiên - Phú Quốc'},
        ].where((ship) =>
        ship['name']!.toLowerCase().contains(event.query.toLowerCase()) ||
            ship['route']!.toLowerCase().contains(event.query.toLowerCase())
        ).toList();

        if (results.isEmpty) {
          emit(SearchEmpty(query: event.query));
        } else {
          emit(SearchLoaded(results: results, query: event.query));
        }
      } catch (e) {
        emit(SearchError(errorMessage: 'Đã có lỗi xảy ra: ${e.toString()}'));
      }
    });

    on<ClearSearch>((event, emit) {
      emit(SearchInitial());
    });
  }
}