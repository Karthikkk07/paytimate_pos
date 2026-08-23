import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

void showCartSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const CartSheet(),
  );
}

class CartSheet extends StatelessWidget {
  const CartSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Consumer<CartProvider>(
          builder: (context, cart, _) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text('Your Cart', style: theme.textTheme.titleLarge),
                      const Spacer(),
                      if (!cart.isEmpty)
                        TextButton(
                          onPressed: cart.clear,
                          child: const Text('Clear all'),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: cart.isEmpty
                      ? Center(
                          child: Text('Your cart is empty',
                              style: theme.textTheme.bodyLarge),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: cart.items.length,
                          itemBuilder: (context, index) {
                            final item = cart.items[index];
                            return ListTile(
                              leading: Text(item.product.emoji,
                                  style: const TextStyle(fontSize: 24)),
                              title: Text(item.product.name),
                              subtitle: Text(
                                  '₹${item.product.price.toStringAsFixed(0)} × ${item.quantity}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '₹${item.subtotal.toStringAsFixed(0)}',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => cart.remove(item.product),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                if (!cart.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Row(
                      children: [
                        Text('Total', style: theme.textTheme.titleMedium),
                        const Spacer(),
                        Text(
                          '₹${cart.total.toStringAsFixed(0)}',
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
