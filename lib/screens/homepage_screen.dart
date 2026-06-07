import 'package:flutter/material.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  // This is where we keep track of what the user has added to their shopping cart
  final List<ProductCart> shoppingCart = [];

  @override
  Widget build(BuildContext context) {
     // Get the list of available products from our product model
    final availableProducts = ProductCart.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('our products'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          // Shopping cart button with item count badge
          IconButton(
            onPressed: () {
              // Navigate to cart screen when button is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartScreen(cartItems: shoppingCart),
                ),
              );
            },
             icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart, size: 28),
                
                // Show a badge with item count only if cart is not empty
                if (shoppingCart.isNotEmpty)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.white,
                      child: Text(
                        '${shoppingCart.length}', // Show total number of items
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
       body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: availableProducts.length,
        itemBuilder: (context, index) {
          final currentProduct = availableProducts[index];
          
          return ProductCard(
            product: currentProduct,
            onAdd: () {
              // When "Add to Cart" is pressed, update the cart
              setState(() {
                shoppingCart.add(currentProduct);
              });
              
              // Show a friendly confirmation message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('✨ ${currentProduct.name} added to your cart! ✨'),
                  duration: const Duration(seconds: 1),
                  backgroundColor: Colors.green,
                   ),
              );
            },
          );
        },
      ),
    );
  }
}
