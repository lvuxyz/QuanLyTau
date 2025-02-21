import 'package:flutter_bloc/flutter_bloc.dart';
import 'welcome_event.dart';
import 'welcome_state.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(InitialState());

  @override
  Stream<WelcomeState> mapEventToState(WelcomeEvent event) async* {
    if (event is NavigateToLoginEvent) {
      // Handle navigation to login screen
    } else if (event is NavigateToRegisterEvent) {
      // Handle navigation to register screen
    }
  }
}
