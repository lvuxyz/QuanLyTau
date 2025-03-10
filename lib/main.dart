// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/welcome/welcome_bloc.dart';
import 'blocs/home/home_bloc.dart';
import 'blocs/search/search_bloc.dart';
import 'blocs/ticket/ticket_bloc.dart';
import 'blocs/ticket/ticket_event.dart';
import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/authentication/authentication_event.dart';
import 'blocs/ship/ship_bloc.dart';
import 'routes/app_routes.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Preload resources for better performance
  await _preloadResources();

  runApp(MyApp());
}

Future<void> _preloadResources() async {
  try {
    // Create a single instance of each BLoC to preload data
    final ticketBloc = TicketBloc();
    ticketBloc.add(LoadTickets());

    final homeBloc = HomeBloc();
    // Ensure the event is of the correct type
    // Either make LoadHomeData inherit from HomeEvent or create a new event
    // homeBloc.add(LoadHomeData());

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
  final ticketBloc = TicketBloc();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the ticket data
    ticketBloc.add(LoadTickets());

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>.value(value: authenticationBloc),
        BlocProvider<WelcomeBloc>(create: (context) => WelcomeBloc()),
        BlocProvider<HomeBloc>.value(value: homeBloc),
        BlocProvider<SearchBloc>.value(value: searchBloc),
        BlocProvider<TicketBloc>.value(value: ticketBloc),
        BlocProvider<ShipBloc>(create: (context) => ShipBloc()),
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
    );
  }
}

// Add the missing SplashScreen class
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