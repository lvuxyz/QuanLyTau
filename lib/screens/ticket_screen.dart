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

class _TicketScreenState extends State<TicketScreen> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  bool get wantKeepAlive => true;

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
    super.build(context);

    return Scaffold(
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
      body: BlocBuilder<TicketBloc, TicketState>(
        builder: (context, state) {
          if (state is TicketInitial) {
            context.read<TicketBloc>().add(LoadTickets());
            return _buildLoadingView();
          } else if (state is TicketLoading) {
            return _buildLoadingView();
          } else if (state is TicketLoaded) {
            return _buildLoadedView(state);
          } else if (state is TicketError) {
            return _buildErrorView(state.message);
          }

          return _buildLoadingView();
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
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

  Widget _buildLoadingView() {
    return Column(
      children: [
        _buildTabBar(),
        Expanded(
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
    return Column(
      children: [
        _buildTabBar(),
        Expanded(
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
                    context.read<TicketBloc>().add(LoadTickets());
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

  Widget _buildLoadedView(TicketLoaded state) {
    return Column(
      children: [
        _buildTabBar(),
        Expanded(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            color: const Color(0xFF13B8A8),
            backgroundColor: Color(0xFF333333),
            onRefresh: () async {
              context.read<TicketBloc>().add(RefreshTickets());
              return await Future.delayed(Duration(milliseconds: 800));
            },
            child: TabBarView(
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
            ),
          ),
        ),
      ],
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
      // Optimize list rendering
      addAutomaticKeepAlives: true,
      cacheExtent: 300,
      physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: KeepAliveWrapper(
            child: TicketItem(
              ticket: ticket,
              statusColor: statusColor,
              onCancelPressed: ticket['status'] == 'đã đặt'
                  ? () => _showCancelConfirmation(context, ticket['id'])
                  : null,
              onTap: () {
                // Show ticket details
              },
            ),
          ),
        );
      },
    );
  }

  void _showCancelConfirmation(BuildContext context, String ticketId) {
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
              context.read<TicketBloc>().add(CancelTicket(ticketId));
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
}

// Helper widget to keep list items alive
class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _KeepAliveWrapperState createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}