import 'package:e_commerance/models/product.dart';
import 'package:e_commerance/product.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  final List<ProductCart> cartItems;

  const CartScreen({super.key,required this.cartItems});
  // Calculate total price of all items in cart
  double get _total => cartItems.fold(0, (sum, p) => sum + p.price);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My shoping cart'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        // Add a friendly subtitle when cart has items
        bottom: cartItems.isNotEmpty
         ? const PreferredSize(
          preferredSize: Size.fromHeight(30),
          child:Padding(padding: EdgeInsets.only(bottom:8),
          child: Text(
             '✨ Time to checkout your favorites!',
             style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          ),
      )
      :null,
    ),
    body: cartItems.isEmpty
    ? _buildEmptyCartMessage(context)
    :_buildCartWithItems(context),
    );
  }
   // Friendly empty cart message with encouragement
  Widget _buildEmptyCartMessage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated empty cart illustration
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'Your cart is feeling lonely 😢',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some products to make it happy!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 30),
          // Button to encourage shopping
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.store),
            label: const Text('Continue Shopping'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
             ),
        ],
      ),
    );
  }

  // Build cart with items
  Widget _buildCartWithItems(BuildContext context) {
    return Column(
      children: [
        // Subtle item count indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '🛍️ ${cartItems.length} item${cartItems.length > 1 ? 's' : ''} in cart',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
                ),
            ),
          ),
        ),
        
        // List of cart items
        Expanded(
          child: ListView.builder(
            itemCount: cartItems.length,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              final product = cartItems[index];
              return _buildCartItemCard(context, product);
            },
          ),
        ),
        
        // Total price section
        _buildTotalSection(),
      ],
    );
  }
   // Individual cart item card with improved UI
  Widget _buildCartItemCard(BuildContext context, ProductCart product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product image with placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.image,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 70,
                  height: 70,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, size: 35),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                     ),
                  const SizedBox(height: 4),
                  Text(
                    '⭐ 4.5 • In Stock',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rs. ${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
             // Buy button with better UX
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () {
                    // Show confirmation dialog before proceeding
                    _showBuyConfirmation(context, product);
                  },
                  child: const Text(
                    'Buy Now',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),


 ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () {
                    // Option to remove from cart
                    _showRemoveFromCartDialog(context, product);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                  ),
                  child: const Text(
                    'Remove',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
   // Total price section with additional info
  Widget _buildTotalSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Price breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'Rs. ${_total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Fee:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                   ),
              ),
              Text(
                _total > 1000 ? 'Free' : 'Rs. 50.00',
                style: TextStyle(
                  fontSize: 14,
                  color: _total > 1000 ? Colors.green : Colors.grey[600],
                  fontWeight: _total > 1000 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                 ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Rs. ${(_total + (_total > 1000 ? 0 : 50)).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  if (_total > 1000)
                    Text(
                      '✨ Free delivery applied',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ],
          ),
           const SizedBox(height: 16),
          
          // Checkout button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to checkout with all items
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiItemCheckoutScreen(items: cartItems),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
               child: const Text(
                'Proceed to Checkout →',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
   // Helper method to show buy confirmation
  void _showBuyConfirmation(BuildContext context, ProductCart product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Ready to Buy?'),
          content: Text('Would you like to purchase ${product.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConfirmScreen(product: product),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Yes, Buy Now'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to show remove confirmation
  void _showRemoveFromCartDialog(BuildContext context, ProductCart product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Item'),
          content: Text('Remove ${product.name} from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Keep'),
            ),
            TextButton(
              onPressed: () {
                // Note: You'll need to implement remove functionality
                // through your state management solution
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} removed from cart'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
      );
  }
}
// Placeholder for multi-item checkout screen
class MultiItemCheckoutScreen extends StatelessWidget {
  final List<ProductCart> items;

  const MultiItemCheckoutScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('Checking out ${items.length} items...'),
      ),
    );
  }
}
                