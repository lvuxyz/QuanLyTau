import 'package:flutter/material.dart';

// Renamed from SearchLoading to SearchLoadingWidget to avoid conflict
class SearchLoadingWidget extends StatelessWidget {
  const SearchLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Color(0xFF13B8A8),
      ),
    );
  }
}

// Renamed from SearchEmpty to SearchEmptyWidget to avoid conflict
class SearchEmptyWidget extends StatelessWidget {
  final String query;

  const SearchEmptyWidget({
    Key? key,
    required this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            color: Colors.white70,
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            'Không tìm thấy kết quả cho "$query"',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Renamed from SearchError to SearchErrorWidget to avoid conflict
class SearchErrorWidget extends StatelessWidget {
  final String errorMessage;

  const SearchErrorWidget({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
            errorMessage,
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}