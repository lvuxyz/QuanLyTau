// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/welcome/welcome_bloc.dart';
import 'blocs/home/home_bloc.dart';
import 'blocs/home/home_event.dart';
import 'blocs/search/search_bloc.dart';
import 'blocs/ticket/ticket_bloc.dart';
import 'blocs/ticket/ticket_event.dart';
import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/authentication/authentication_event.dart';
import 'blocs/ship/ship_bloc.dart';
import 'services/ship_service.dart';
import 'services/auth_service.dart';
import 'services/train_service.dart';
import 'services/station_service.dart';
import 'services/schedule_service.dart';
import 'services/ticket_service.dart';
import 'routes/app_routes.dart';
import 'blocs/schedule/schedule_bloc.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Create services
  final scheduleService = ScheduleService();
  final ticketService = TicketService();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ScheduleBloc(scheduleService),
        ),
        BlocProvider(
          create: (context) => TicketBloc(ticketService),
        ),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> _preloadResources() async {
  try {
    // Create a single instance of each BLoC to preload data
    final ticketService = TicketService();
    final ticketBloc = TicketBloc(ticketService);
    ticketBloc.add(LoadUserTickets());

    final homeBloc = HomeBloc();
    homeBloc.add(LoadHomeData());

    // Wait for initial data to be loaded (with timeout)
    await Future.wait([
      Future.delayed(Duration(seconds: 2)), // Minimum splash time
    ]);
  } catch (e) {
    // Fail silently - app will still work without preloaded resources
    print('Error preloading resources: $e');
  }
}

class MyApp extends StatelessWidget {
  // Create singleton blocs here for memory efficiency
  final authenticationBloc = AuthenticationBloc();
  final homeBloc = HomeBloc();
  final searchBloc = SearchBloc();
  final ticketBloc = TicketBloc(TicketService());

  // Create services
  final authService = AuthService();
  final shipService = ShipService();
  final trainService = TrainService();
  final stationService = StationService();
  final scheduleService = ScheduleService();
  final ticketService = TicketService();

  @override
  Widget build(BuildContext context) {
    // Initialize the ticket data
    ticketBloc.add(LoadUserTickets());
    // Initialize home data
    homeBloc.add(LoadHomeData());

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>.value(value: authenticationBloc),
        BlocProvider<WelcomeBloc>(create: (context) => WelcomeBloc()),
        BlocProvider<HomeBloc>.value(value: homeBloc),
        BlocProvider<SearchBloc>.value(value: searchBloc),
        BlocProvider<TicketBloc>.value(value: ticketBloc),
        BlocProvider<ShipBloc>(create: (context) => ShipBloc(shipService: shipService)),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthService>(create: (context) => authService),
          RepositoryProvider<ShipService>(create: (context) => shipService),
          RepositoryProvider<TrainService>(create: (context) => trainService),
          RepositoryProvider<StationService>(create: (context) => stationService),
          RepositoryProvider<ScheduleService>(create: (context) => scheduleService),
          RepositoryProvider<TicketService>(create: (context) => ticketService),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ship Manager',
          theme: ThemeData(
            primaryColor: Color(0xFF13B8A8),
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.black,
              elevation: 0,
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          onGenerateRoute: AppRoutes.generateRoute,
          home: SplashScreen(),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();

    // Initialize the authentication state before navigating
    context.read<AuthenticationBloc>().add(AppStarted());

    // Navigate after splash animation
    Future.delayed(Duration(milliseconds: 2000), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => AppRoutes.getInitialScreen(context),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_boat_rounded,
                      size: 100,
                      color: const Color(0xFF13B8A8),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Ship Manager',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Quản lý tàu hiệu quả',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}