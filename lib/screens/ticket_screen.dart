// lib/screens/ticket_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/ticket/ticket_bloc.dart';
import '../blocs/ticket/ticket_event.dart';
import '../blocs/ticket/ticket_state.dart';
import '../widgets/home/custom_bottom_nav_bar.dart';
import '../widgets/ticket/ticket_item.dart';

class TicketScreen extends StatefulWidget {
  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TicketBloc()..add(LoadTickets()),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: _buildHeader(),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: BlocBuilder<TicketBloc, TicketState>(
                builder: (context, state) {
                  if (state is TicketLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: const Color(0xFF13B8A8),
                      ),
                    );
                  } else if (state is TicketLoaded) {
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        // Đã đặt tab
                        _buildTicketList(
                          context: context,
                          tickets: state.bookedTickets,
                          statusColor: const Color(0xFF13B8A8),
                          emptyMessage: 'Bạn chưa có vé nào đã đặt',
                        ),

                        // Hoàn thành tab
                        _buildTicketList(
                          context: context,
                          tickets: state.completedTickets,
                          statusColor: Colors.blue,
                          emptyMessage: 'Bạn chưa có vé nào đã hoàn thành',
                        ),

                        // Đã hủy tab
                        _buildTicketList(
                          context: context,
                          tickets: state.canceledTickets,
                          statusColor: Colors.red,
                          emptyMessage: 'Bạn chưa có vé nào đã hủy',
                        ),
                      ],
                    );
                  } else if (state is TicketError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.grey[800],
          child: ClipOval(
            child: Image.asset(
              'assets/images/user_avatar.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.person, color: Colors.white);
              },
            ),
          ),
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
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF333333),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Color(0xFF13B8A8),
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: EdgeInsets.zero,
        indicatorPadding: EdgeInsets.zero,
        tabAlignment: TabAlignment.fill,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.7),
        tabs: [
          Tab(text: 'Đã đặt'),
          Tab(text: 'Hoàn thành'),
          Tab(text: 'Đã hủy'),
        ],
      ),
    );
  }

  Widget _buildTicketList({
    required BuildContext context,
    required List<Map<String, dynamic>> tickets,
    required Color statusColor,
    required String emptyMessage,
  }) {
    if (tickets.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return TicketItem(
          ticket: ticket,
          statusColor: statusColor,
          onCancelPressed: ticket['status'] == 'đã đặt'
              ? () {
            // Show confirmation dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Color(0xFF333333),
                title: Text(
                  'Xác nhận hủy vé',
                  style: TextStyle(color: Colors.white),
                ),
                content: Text(
                  'Bạn có chắc chắn muốn hủy vé này không?',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Hủy',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<TicketBloc>().add(CancelTicket(ticket['id']));
                    },
                    child: Text(
                      'Xác nhận',
                      style: TextStyle(color: Color(0xFF13B8A8)),
                    ),
                  ),
                ],
              ),
            );
          }
              : null,
        );
      },
    );
  }
}