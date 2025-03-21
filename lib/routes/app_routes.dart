// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shipmanagerapp/services/ship_service.dart';
import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/authentication/authentication_event.dart';
import '../blocs/authentication/authentication_state.dart';
import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_event.dart';
import '../blocs/ship/ship_bloc.dart';
import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/ticket_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/ship_management_screen.dart';
import '../screens/schedule_management_screen.dart';
import '../screens/station_screen.dart';
import '../screens/train_screen.dart';
import '../screens/admin_dashboard_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/issue_screen.dart';
import '../screens/seat_config_screen.dart';
import '../screens/schedule_screen.dart';
import '../utils/custom_route.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String search = '/search';
  static const String tickets = '/tickets';
  static const String profile = '/profile';
  static const String shipManagement = '/ship-management';
  static const String scheduleManagement = '/schedule-management';
  static const String stationManagement = '/station-management';
  static const String trainManagement = '/train-management';
  static const String adminDashboard = '/admin-dashboard';
  static const String notification = '/notification';
  static const String issue = '/issue';
  static const String seatConfig = '/seat-config';
  static const String schedule = '/schedule';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(builder: (_) => WelcomeScreen());
      case login:
        return FadePageRoute(page: LoginScreen());
      case register:
        return FadePageRoute(page: RegisterScreen());
      case home:
        return FadePageRoute(page: HomeScreen());
      case search:
        return FadePageRoute(page: SearchScreen());
      case tickets:
        return FadePageRoute(page: TicketScreen());
      case profile:
        return FadePageRoute(page: ProfileScreen());
      case shipManagement:
        return FadePageRoute(
          page: BlocProvider(
            create: (context) => ShipBloc(shipService: context.read<ShipService>()),
            child: ShipManagementScreen(),
          ),
        );
      case scheduleManagement:
        return FadePageRoute(page: ScheduleManagementScreen());
      case stationManagement:
        return FadePageRoute(page: StationScreen());
      case trainManagement:
        return FadePageRoute(page: TrainScreen());
      case adminDashboard:
        return FadePageRoute(page: AdminDashboardScreen());
      case notification:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case issue:
        return MaterialPageRoute(builder: (_) => const IssueScreen());
      case seatConfig:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => SeatConfigScreen(trainId: args?['trainId']),
        );
      case schedule:
        return MaterialPageRoute(builder: (_) => const ScheduleScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Không tìm thấy trang: ${settings.name}'),
            ),
          ),
        );
    }
  }

  static Widget getInitialScreen(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationUninitialized) {
          context.read<AuthenticationBloc>().add(AppStarted());
          // Ensure home data is loaded
          context.read<HomeBloc>().add(LoadHomeData());
          return Scaffold(
            backgroundColor: Color(0xFF1A1A1A),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF13B8A8),
              ),
            ),
          );
        }

        if (state is AuthenticationAuthenticated) {
          // Check if user is admin
          final isAdmin = state.userData['role'] == 'admin';
          return isAdmin ? AdminDashboardScreen() : HomeScreen();
        }

        return WelcomeScreen();
      },
    );
  }
}