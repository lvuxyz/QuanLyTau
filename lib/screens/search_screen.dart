import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/search/search_bloc.dart';
import '../blocs/search/search_event.dart';
import '../blocs/search/search_state.dart';
import '../widgets/home/custom_bottom_nav_bar.dart';
import '../widgets/search/search_header.dart';
import '../widgets/search/custom_search_bar.dart';
import '../widgets/search/search_results.dart';
import '../widgets/search/search_status_widgets.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Không tự động bật bàn phím khi vào màn hình
    // _searchFocusNode.requestFocus(); - đã loại bỏ dòng này
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header widget
            const SearchHeader(),

            // Search bar with selective rebuild
            BlocSelector<SearchBloc, SearchState, bool>(
              selector: (state) => state is SearchLoading,
              builder: (context, isLoading) {
                return CustomSearchBar(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  isLoading: isLoading,
                  onChanged: (query) {
                    context.read<SearchBloc>().add(PerformSearch(query: query));
                  },
                  onClear: () {
                    _searchController.clear();
                    context.read<SearchBloc>().add(ClearSearch());
                  },
                );
              },
            ),

            // Search results with optimized rebuilds
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                buildWhen: (previous, current) {
                  // Only rebuild if the type of state actually changes
                  if (previous is SearchLoaded && current is SearchLoaded) {
                    // Avoid rebuilding if just the same type with same result count
                    return previous.results.length != current.results.length;
                  }
                  return previous.runtimeType != current.runtimeType;
                },
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return SearchLoadingWidget();
                  } else if (state is SearchLoaded) {
                    return SearchResults(results: state.results);
                  } else if (state is SearchEmpty) {
                    return SearchEmptyWidget(query: state.query);
                  } else if (state is SearchError) {
                    return SearchErrorWidget(errorMessage: state.errorMessage);
                  } else if (state is SearchSuggestions) {
                    // Hiển thị các đề xuất
                    return SuggestionsWidget(suggestions: state.suggestions);
                  } else {
                    // Initial state - empty black background with prompt
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.white.withOpacity(0.3),
                              size: 48,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Tìm kiếm tên tàu hoặc tuyến đường",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}

// Widget hiển thị các đề xuất
class SuggestionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> suggestions;

  const SuggestionsWidget({Key? key, required this.suggestions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Đề xuất cho bạn',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: suggestions.length,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final item = suggestions[index];
              return Card(
                color: Color(0xFF222222),
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              item['name'] as String,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFF13B8A8).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Phổ biến',
                              style: TextStyle(
                                color: Color(0xFF13B8A8),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        item['route'] as String,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              item['price'] as String,
                              style: TextStyle(
                                color: Color(0xFF13B8A8),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white.withOpacity(0.5),
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}