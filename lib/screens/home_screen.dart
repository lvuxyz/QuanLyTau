import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_event.dart';
import '../blocs/home/home_state.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHomeData()),
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: const Color(0xFF13B8A8),
                  ),
                );
              } else if (state is HomeError) {
                return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return CustomScrollView(
                slivers: [
                  // Custom App Bar
                  SliverAppBar(
                    floating: true,
                    backgroundColor: const Color(0xFF1A1A1A),
                    title: Row(
                      children: [
                        // User avatar
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: AssetImage('assets/images/user_avatar.png'),
                          // If you don't have the asset, you can use a placeholder icon
                          // backgroundColor: Colors.blue,
                          // child: Icon(Icons.person, color: Colors.white),
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Chào, Admin",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Hôm nay bạn khỏe không?",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.notifications_none, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Promotion Section
                          Text(
                            "Vé khuyến mại",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),

                          // Promotion Cards
                          Container(
                            height: 160,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 280,
                                  margin: EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF333333),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  // You can add content for the promotion cards here
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 24),

                          // Recent Ships Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Các chuyến tàu mới",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Xem tất cả",
                                  style: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),

                          // Ship Cards
                          Container(
                            height: 180,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 160,
                                  margin: EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF333333),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Container(),  // Placeholder for ship image or details
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(16),
                                            bottomRight: Radius.circular(16),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Mua vé",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 24),

                          // Promotions Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Khuyến mãi",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Xem tất cả",
                                  style: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),

                          // Promotion Items
                          Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Color(0xFF333333),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF333333),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(),
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_filled, "Trang chủ", true),
          _buildNavItem(Icons.search, "Tìm kiếm", false),
          _buildNavItem(Icons.directions_boat_outlined, "Vé", false),
          _buildNavItem(Icons.person_outline, "Profile", false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    Color color = isActive ? Color(0xFF13B8A8) : Colors.grey;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}