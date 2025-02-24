import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shipmanagerapp/widgets/home/custom_bottom_nav_bar.dart';
import '../blocs/search/search_bloc.dart';
import '../blocs/search/search_event.dart';
import '../blocs/search/search_state.dart';
import '../widgets/home/custom_bottom_nav_bar.dart';
import '../widgets/search/search_header.dart';
import '../widgets/search/custom_search_bar.dart'; // Renamed import
import '../widgets/search/search_results.dart';
import '../widgets/search/search_status_widgets.dart'; // Renamed import

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
              // Header widget
              SearchHeader(),

              // Search bar widget
              CustomSearchBar(controller: _searchController), // Renamed widget

              // Search results or status widgets
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoading) {
                      return SearchLoadingWidget(); // Renamed widget
                    } else if (state is SearchLoaded) {
                      return SearchResults(results: state.results);
                    } else if (state is SearchEmpty) {
                      return SearchEmptyWidget(query: state.query); // Renamed widget
                    } else if (state is SearchError) {
                      return SearchErrorWidget(errorMessage: state.errorMessage); // Renamed widget
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
        // Bottom navigation bar
        bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      ),
    );
  }
}