// lib/ui/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/home/home_bloc.dart';
import '../../blocs/home/home_event.dart';
import '../../blocs/home/home_state.dart';
import '../../ui/widgets/home/custom_app_bar.dart';
import '../../ui/widgets/home/custom_bottom_nav_bar.dart';
import '../../ui/widgets/home/trains_section.dart';
import '../../ui/widgets/home/schedules_section.dart';
import '../../ui/widgets/home/stations_section.dart';
import '../../utils/custom_route.dart';
import 'schedule_screen.dart';
import 'station_screen.dart';
import 'train_screen.dart';

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
          backgroundColor: const Color(0xFF333333),
          onRefresh: () async {
            context.read<HomeBloc>().add(RefreshHomeData());
            return await Future.delayed(const Duration(milliseconds: 800));
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
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        const CustomAppBar(),
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
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        const CustomAppBar(),
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
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
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Try Again'),
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
        const CustomAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ships Section
                TrainsSection(
                  trains: state.ships,
                  onViewAllPressed: () {
                    Navigator.push(
                      context,
                      FadePageRoute(page: const TrainScreen()),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Schedules Section
                SchedulesSection(
                  schedules: state.schedules,
                  onViewAllPressed: () {
                    Navigator.push(
                      context,
                      FadePageRoute(page: const ScheduleScreen()),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Ports Section
                StationsSection(
                  stations: state.ports,
                  onViewAllPressed: () {
                    Navigator.push(
                      context,
                      FadePageRoute(page: const StationScreen()),
                    );
                  },
                ),

                // Add bottom padding for comfortable scrolling
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}