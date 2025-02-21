import 'package:flutter_bloc/flutter_bloc.dart';
import 'welcome_event.dart';
import 'welcome_state.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(InitialState()) {
    // Register event handlers using the on<EventType> method
    on<NavigateToLoginEvent>((event, emit) {
      emit(NavigateToLoginState());
    });

    on<NavigateToRegisterEvent>((event, emit) {
      emit(NavigateToRegisterState());
    });
  }
}