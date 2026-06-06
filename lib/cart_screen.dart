import 'package:flutter/material.dart';
import 'product.dart';
import 'confirm_screen.dart';

class CartScreen extends StatelessWidget {
  final List<ProductCart> cartItems;

  const CartScreen({
    super.key,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text("Cart is empty"),
            )
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];

                return ListTile(
                  leading: Image.network(
                    product.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.name),
                  subtitle: Text('\$${product.price}'),
                  trailing: ElevatedButton(
                    child: const Text("Buy"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ConfirmScreen(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}