import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/search/search_bloc.dart';
import '../blocs/search/search_event.dart';
import '../blocs/search/search_state.dart';
import '../widgets/home/custom_bottom_nav_bar.dart';
import '../widgets/search/search_header.dart';
import '../widgets/search/search_bar.dart';
import '../widgets/search/search_results.dart';
import '../widgets/search/search_status.dart';

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
              SearchBar(controller: _searchController),

              // Search results or status widgets
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoading) {
                      return SearchLoading();
                    } else if (state is SearchLoaded) {
                      return SearchResults(results: state.results);
                    } else if (state is SearchEmpty) {
                      return SearchEmpty(query: state.query);
                    } else if (state is SearchError) {
                      return SearchError(errorMessage: state.errorMessage);
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
}