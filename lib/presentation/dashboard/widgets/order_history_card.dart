import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OrderHistoryCard extends StatelessWidget {
  final String orderId;
  final DateTime createdAt;
  final String status;
  final List<dynamic> items;
  final Map<String, dynamic> deliveryMethod;
  final double total;
  final VoidCallback? onRetryPayment;
  final double? rating;
  final Function(BuildContext, String, List<dynamic>)? onRate;
  final Function(String)? onDelete; // Add this line

  const OrderHistoryCard({
    super.key,
    required this.orderId,
    required this.createdAt,
    required this.status,
    required this.items,
    required this.deliveryMethod,
    required this.total,
    this.onRetryPayment,
    this.rating,
    this.onRate,
    this.onDelete, // Add this line
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'success':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case 'success':
        return 'Order Completed';
      case 'pending':
        return 'Waiting for Payment';
      case 'expired':
        return 'Payment Expired';
      default:
        return 'Order Failed';
    }
  }

  Widget _buildDeliverySection() {
    final method = deliveryMethod['method']?.toString() ?? 'Standard Delivery';
    final duration = deliveryMethod['duration']?.toString() ?? '30-60 mins';
    final price = deliveryMethod['price']?.toString() ?? 'Rp 0';

    return Row(
      children: [
        Icon(Icons.local_shipping_outlined, color: Color(0xFFCA6D5B), size: 20),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                method,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                'Estimated arrival: $duration',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Text(
          price,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Add this state controller for expansion
    final isExpanded = ValueNotifier<bool>(false);

    return Slidable(
      key: ValueKey(orderId),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Order History'),
                  content: Text(
                      'Are you sure you want to delete this order history?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        onDelete?.call(orderId);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Header with Order ID and Status
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${orderId.substring(6, 12)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            DateFormat('dd MMM yyyy, HH:mm').format(createdAt),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              status == 'success'
                                  ? Icons.check_circle
                                  : status == 'pending'
                                      ? Icons.access_time
                                      : Icons.error,
                              size: 16,
                              color: _getStatusColor(status),
                            ),
                            SizedBox(width: 4),
                            Text(
                              _getStatusMessage(status),
                              style: TextStyle(
                                color: _getStatusColor(status),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (status == 'pending')
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.timer, color: Colors.orange, size: 16),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Complete payment before ${DateFormat('HH:mm').format(createdAt.add(Duration(minutes: 5)))}',
                              style: TextStyle(
                                color: Colors.orange[900],
                                fontSize: 12,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: onRetryPayment,
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              minimumSize: Size(60, 25),
                            ),
                            child: Text(
                              'Pay Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Order Items
            ValueListenableBuilder<bool>(
              valueListenable: isExpanded,
              builder: (context, expanded, child) {
                return Column(
                  children: [
                    // Always show first item
                    if (items.isNotEmpty) _buildItemTile(items[0]),

                    // Show remaining items when expanded
                    if (expanded && items.length > 1)
                      ...items.skip(1).map((item) => _buildItemTile(item)),

                    // Show "See more" button if there are additional items
                    if (items.length > 1)
                      TextButton(
                        onPressed: () => isExpanded.value = !expanded,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              expanded
                                  ? 'Show less'
                                  : 'See ${items.length - 1} more items',
                              style: TextStyle(
                                color: Color(0xFFCA6D5B),
                                fontSize: 14,
                              ),
                            ),
                            Icon(
                              expanded ? Icons.expand_less : Icons.expand_more,
                              color: Color(0xFFCA6D5B),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),

            // Delivery Info
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDeliverySection(),
                  Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Payment',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Rp ${total.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFFCA6D5B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Rating Section
            if (status == 'success')
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: rating != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Your Rating: '),
                          ...List.generate(
                            5,
                            (index) => Icon(
                              index < rating! ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 20,
                            ),
                          ),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () => onRate?.call(context, orderId, items),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFCA6D5B),
                          minimumSize: Size(double.infinity, 36),
                        ),
                        child: Text(
                          'Rate Order',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemTile(dynamic item) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          item['image'],
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        item['name'],
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        '${item['quantity']}x @ Rp ${item['price']}',
        style: TextStyle(fontSize: 12),
      ),
      trailing: Text(
        'Rp ${(item['price'] * item['quantity']).toString()}',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xFFCA6D5B),
        ),
      ),
    );
  }
}
