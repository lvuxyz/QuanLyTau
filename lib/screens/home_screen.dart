// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_event.dart';
import '../blocs/home/home_state.dart';
import '../widgets/home/custom_app_bar.dart';
import '../widgets/home/custom_bottom_nav_bar.dart';
import '../widgets/home/trains_section.dart';
import '../widgets/home/schedules_section.dart';
import '../widgets/home/stations_section.dart';
import '../utils/custom_route.dart';
import '../screens/schedule_screen.dart';
import '../screens/station_screen.dart';
import '../screens/train_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: const Color(0xFF13B8A8),
          backgroundColor: Color(0xFF333333),
          onRefresh: () async {
            context.read<HomeBloc>().add(RefreshHomeData());
            return await Future.delayed(Duration(milliseconds: 800));
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeInitial) {
                context.read<HomeBloc>().add(LoadHomeData());
                return _buildLoadingView();
              } else if (state is HomeLoading) {
                return _buildLoadingView();
              } else if (state is HomeError) {
                return _buildErrorView(state.message);
              } else if (state is HomeLoaded) {
                return _buildLoadedView(state);
              }

              return _buildLoadingView();
            },
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildLoadingView() {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        CustomAppBar(),
        SliverFillRemaining(
          child: Center(
            child: CircularProgressIndicator(
              color: const Color(0xFF13B8A8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(String message) {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        CustomAppBar(),
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                SizedBox(height: 16),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(LoadHomeData());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF13B8A8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadedView(HomeLoaded state) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        CustomAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trains Section
                TrainsSection(
                  trains: state.trains,
                  onViewAllPressed: () {
                    Navigator.push(
                      context,
                      FadePageRoute(page: TrainScreen()),
                    );
                  },
                ),

                SizedBox(height: 24),

                // Schedules Section
                SchedulesSection(
                  schedules: state.schedules,
                  onViewAllPressed: () {
                    Navigator.push(
                      context,
                      FadePageRoute(page: ScheduleScreen()),
                    );
                  },
                ),

                SizedBox(height: 24),

                // Stations Section (thay thế phần Promotions)
                StationsSection(
                  stations: state.stations,
                  onViewAllPressed: () {
                    Navigator.push(
                      context,
                      FadePageRoute(page: StationScreen()),
                    );
                  },
                ),

                // Thêm padding ở dưới cùng cho thoải mái khi cuộn
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}