import 'package:flutter/material.dart';
import 'product.dart';

class ProductCard extends StatelessWidget {
  final ProductCart product;
  final VoidCallback onAdd;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),

      child: Padding(
        padding: const EdgeInsets.all(10),

        child: Row(
          children: [

            Image.network(
              product.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(product.description),

                  const SizedBox(height: 10),

                  Text(
                    '\$${product.price}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            ElevatedButton(
              onPressed: onAdd,
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}