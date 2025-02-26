import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShipCard extends StatelessWidget {
  final double width;
  final EdgeInsetsGeometry margin;
  final Map<String, dynamic>? shipData;

  const ShipCard({
    Key? key,
    required this.width,
    this.margin = EdgeInsets.zero,
    this.shipData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = shipData?['name'] ?? 'Tàu X';
    final status = shipData?['status'] ?? 'Đang hoạt động';
    final imageUrl = shipData?['imageUrl'] ?? 'https://example.com/placeholder.jpg';

    return Container(
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: Color(0xFF333333),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ship image with caching
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
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
                          child: Center(
                            child: Icon(
                              Icons.directions_boat,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        memCacheHeight: 300, // Optimize memory cache
                        memCacheWidth: 300,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  // Ship name
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  // Ship status
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: status == 'Đang hoạt động' ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: status == 'Đang hoạt động' ? Colors.green : Colors.orange,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const BuyTicketButton(),
        ],
      ),
    );
  }
}

class BuyTicketButton extends StatelessWidget {
  const BuyTicketButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // Handle buy ticket action
        },
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        child: Container(
          width: double.infinity,
          height: 40,
          alignment: Alignment.center,
          child: Text(
            "Mua vé",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}