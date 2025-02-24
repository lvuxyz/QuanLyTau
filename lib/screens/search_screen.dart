import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/search/search_bloc.dart';
import '../blocs/search/search_event.dart';
import '../blocs/search/search_state.dart';
import '../widgets/home/custom_bottom_nav_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF13B8A8),
                        ),
                      );
                    } else if (state is SearchLoaded) {
                      return _buildSearchResults(state.results);
                    } else if (state is SearchEmpty) {
                      return Center(
                        child: Text(
                          'Không tìm thấy kết quả cho "${state.query}"',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    } else if (state is SearchError) {
                      return Center(
                        child: Text(
                          state.errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      // Initial state - empty black background
                      return Container(color: Colors.black);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        // Pass currentIndex 1 to indicate Search is active
        bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: Colors.black,
      child: Row(
        children: [
          // User avatar
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/user_avatar.png'),
            onBackgroundImageError: (_, __) {},
            backgroundColor: Colors.grey[800],
            child: Icon(Icons.person, color: Colors.white, size: 24),
          ),
          SizedBox(width: 12),
          // Greeting text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Chào, Admin",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Hôm nay bạn khỏe không?",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Spacer(),
          // Notification icon
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          color: Colors.black,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFF333333),
              hintText: 'Tìm kiếm...',
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  context.read<SearchBloc>().add(ClearSearch());
                },
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            style: TextStyle(color: Colors.white),
            onChanged: (query) {
              context.read<SearchBloc>().add(PerformSearch(query: query));
            },
          ),
        );
      },
    );
  }

  Widget _buildSearchResults(List<Map<String, dynamic>> results) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return Card(
          color: Color(0xFF333333),
          margin: EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            title: Text(
              item['name'] ?? '',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              item['route'] ?? '',
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF13B8A8),
              size: 16,
            ),
            onTap: () {
              // Handle ship selection
            },
          ),
        );
      },
    );
  }
}