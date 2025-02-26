import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  // Danh sách đề xuất mặc định
  final List<Map<String, dynamic>> _suggestedItems = [
    {'id': '1', 'name': 'Tàu Cao Tốc A', 'route': 'Vũng Tàu - Côn Đảo', 'price': '500.000 VND', 'popular': true},
    {'id': '2', 'name': 'Tàu Khách B', 'route': 'Nha Trang - Phú Quốc', 'price': '750.000 VND', 'popular': true},
    {'id': '3', 'name': 'Tàu Du Lịch C', 'route': 'Hạ Long - Cát Bà', 'price': '300.000 VND', 'popular': true},
    {'id': '4', 'name': 'Tàu Phú Quý', 'route': 'Phan Thiết - Phú Quý', 'price': '350.000 VND', 'popular': true},
  ];

  SearchBloc() : super(SearchInitial()) {
    // Khi khởi tạo, bắt đầu với trạng thái mặc định
    on<SearchEvent>((event, emit) {
      if (event is PerformSearch) {
        _handlePerformSearch(event, emit);
      } else if (event is ClearSearch) {
        emit(SearchSuggestions(suggestions: _suggestedItems));
      }
    });
  }

  void _handlePerformSearch(PerformSearch event, Emitter<SearchState> emit) async {
    emit(SearchLoading());

    try {
      // Giả lập việc tìm kiếm
      await Future.delayed(Duration(milliseconds: 500));

      // Kiểm tra nếu query rỗng
      if (event.query.isEmpty) {
        emit(SearchSuggestions(suggestions: _suggestedItems));
        return;
      }

      // Giả lập kết quả tìm kiếm
      final results = [
        {'id': '1', 'name': 'Tàu Cao Tốc A', 'route': 'Vũng Tàu - Côn Đảo', 'price': '500.000 VND'},
        {'id': '2', 'name': 'Tàu Khách B', 'route': 'Nha Trang - Phú Quốc', 'price': '750.000 VND'},
        {'id': '3', 'name': 'Tàu Du Lịch C', 'route': 'Hạ Long - Cát Bà', 'price': '300.000 VND'},
        {'id': '4', 'name': 'Tàu Phú Quý', 'route': 'Phan Thiết - Phú Quý', 'price': '350.000 VND'},
        {'id': '5', 'name': 'Tàu Cần Giờ', 'route': 'TP.HCM - Cần Giờ', 'price': '200.000 VND'},
      ].where((ship) =>
      ship['name']!.toLowerCase().contains(event.query.toLowerCase()) ||
          ship['route']!.toLowerCase().contains(event.query.toLowerCase())
      ).toList();

      if (results.isEmpty) {
        emit(SearchEmpty(query: event.query));
      } else {
        emit(SearchLoaded(results: results.cast<Map<String, dynamic>>(), query: event.query));
      }
    } catch (e) {
      emit(SearchError(errorMessage: 'Có lỗi xảy ra khi tìm kiếm. Vui lòng thử lại.'));
    }
  }
}