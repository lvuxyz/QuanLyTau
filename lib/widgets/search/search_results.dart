import 'package:flutter/material.dart';

class SearchResults extends StatelessWidget {
  final List<Map<String, dynamic>> results;

  const SearchResults({
    Key? key,
    required this.results,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return SearchResultItem(item: item);
      },
    );
  }
}

class SearchResultItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const SearchResultItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  }
}