import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      // Performance optimizations
      addAutomaticKeepAlives: true,
      cacheExtent: 300,
      physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = results[index];
        return KeepAliveWrapper(
          child: SearchResultItem(item: item),
        );
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
    final imageUrl = item['imageUrl'] as String?;

    return Card(
      color: Color(0xFF333333),
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Handle ship selection
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              // Ship image (cached)
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[800],
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[800],
                      width: 60,
                      height: 60,
                      child: Icon(
                        Icons.directions_boat,
                        color: Colors.white,
                      ),
                    ),
                    memCacheHeight: 120,
                    memCacheWidth: 120,
                  ),
                ),

              // Ship details
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'] ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        item['route'] ?? '',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF13B8A8),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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