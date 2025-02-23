// lib/blocs/home/home_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>((event, emit) async {
      emit(HomeLoading());
      try {
        // Simulate API call
        await Future.delayed(Duration(seconds: 1));

        final recentShips = [
          {'id': '1', 'name': 'Tàu A', 'status': 'Đang hoạt động'},
          {'id': '2', 'name': 'Tàu B', 'status': 'Bảo trì'},
        ];

        final promotions = [
          {'id': '1', 'title': 'Khuyến mãi tháng 6', 'discount': '20%'},
          {'id': '2', 'title': 'Ưu đãi đặc biệt', 'discount': '15%'},
        ];

        emit(HomeLoaded(
          recentShips: recentShips,
          promotions: promotions,
        ));
      } catch (e) {
        emit(HomeError('Không thể tải dữ liệu. Vui lòng thử lại sau.'));
      }
    });

    on<RefreshHomeData>((event, emit) async {
      final currentState = state;
      if (currentState is HomeLoaded) {
        emit(HomeLoading());
        try {
          // Simulate API refresh
          await Future.delayed(Duration(seconds: 1));
          emit(currentState);
        } catch (e) {
          emit(HomeError('Không thể làm mới dữ liệu. Vui lòng thử lại sau.'));
        }
      }
    });

    on<SearchShips>((event, emit) async {
      // Handle search functionality
    });
  }
}