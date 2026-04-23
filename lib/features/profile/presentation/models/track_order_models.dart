import 'package:e_commerce/features/profile/presentation/widgets/order_status_chip.dart';
import 'package:flutter/material.dart';

class TrackOrderArgs {
  final String orderId;
  final String amount;
  final String imageAsset;
  final OrderStatus status;
  final String estimatedDeliveryValue;
  final String deliveryAddressLine1;
  final String deliveryAddressLine2;
  final String deliveryPhone;
  final List<TrackOrderTimelineStep> steps;
  final List<TrackOrderItem> items;

  const TrackOrderArgs({
    required this.orderId,
    required this.amount,
    required this.imageAsset,
    required this.status,
    required this.estimatedDeliveryValue,
    required this.deliveryAddressLine1,
    required this.deliveryAddressLine2,
    required this.deliveryPhone,
    required this.steps,
    required this.items,
  });

  factory TrackOrderArgs.sample({
    required String orderId,
    required String amount,
    required String imageAsset,
    required OrderStatus status,
  }) {
    return TrackOrderArgs(
      orderId: orderId,
      amount: amount,
      imageAsset: imageAsset,
      status: status,
      estimatedDeliveryValue: 'Today, 5:00 PM',
      deliveryAddressLine1: '123 Main St',
      deliveryAddressLine2: 'New York, NY 10001',
      deliveryPhone: '+1 234-567-8900',
      steps: const [
        TrackOrderTimelineStep(
          title: 'orderPlaced',
          subtitle: 'Your order has been confirmed',
          timeText: 'Apr 10, 2:30 PM',
          icon: Icons.check_circle_outline_rounded,
          active: true,
        ),
        TrackOrderTimelineStep(
          title: 'processing',
          subtitle: 'Preparing your items for shipment',
          timeText: 'Apr 10, 4:15 PM',
          icon: Icons.inventory_2_outlined,
          active: true,
        ),
        TrackOrderTimelineStep(
          title: 'shipped',
          subtitle: 'Your package is on the way',
          timeText: 'Apr 11, 9:00 AM',
          icon: Icons.local_shipping_outlined,
          active: true,
        ),
        TrackOrderTimelineStep(
          title: 'outForDelivery',
          subtitle: 'Package will arrive today',
          timeText: 'Expected: Apr 12, 5:00 PM',
          icon: Icons.location_on_outlined,
          active: false,
        ),
      ],
      items: const [
        TrackOrderItem(
          title: 'Premium Wireless Headphones',
          price: r'$299',
          quantity: 'Qty: 1',
          imageAsset: 'assets/images/guest.png',
        ),
        TrackOrderItem(
          title: 'Designer Sneakers',
          price: r'$189',
          quantity: 'Qty: 2',
          imageAsset: 'assets/images/buy_sell.jpg',
        ),
      ],
    );
  }
}

class TrackOrderTimelineStep {
  final String title;
  final String subtitle;
  final String timeText;
  final IconData icon;
  final bool active;

  const TrackOrderTimelineStep({
    required this.title,
    required this.subtitle,
    required this.timeText,
    required this.icon,
    required this.active,
  });
}

class TrackOrderItem {
  final String title;
  final String price;
  final String quantity;
  final String imageAsset;

  const TrackOrderItem({
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageAsset,
  });
}
