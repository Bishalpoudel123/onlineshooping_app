//import 'package:flutter/material.dart';
//import 'product_cart.dart';

class ProductCart {
  final String name;
  final double price;
  final String description;
  final String image;

  const ProductCart({
    required this.name,
    required this.price,
    required this.description,
    required this.image,
  });

  static List<ProductCart> products = [
    ProductCart(
      name: 'sunGlass',
      price: 1500.99,
      description: 'description',
      image: 'https://images.pexels.com/photos/29274468/pexels-photo-29274468.jpeg',
    ),
    ProductCart(
      name: 'iron',
      price: 1100.34,
      description: 'description',
      image: 'https://images.pexels.com/photos/7703649/pexels-photo-7703649.jpeg',
    ),
    ProductCart(
      name: 'water kattle',
      price: 1260,
      description: 'description',
      image: 'https://images.pexels.com/photos/30319667/pexels-photo-30319667.jpeg',
    ),
    ProductCart(
      name: 'water bottle',
      price: 80,
      description: 'description',
      image: 'https://images.pexels.com/photos/13055851/pexels-photo-13055851.jpeg',
    ),
    ProductCart(
      name: 'coffe cup',
      price: 99, //in 99 shop
      description: 'description',
      image: 'https://images.pexels.com/photos/30748857/pexels-photo-30748857.jpeg',
    ),
    ProductCart(
      name: 'dairy milk',
      price: 250,
      description: 'description',
      image: 'https://images.pexels.com/photos/4113348/pexels-photo-4113348.jpeg',
    ),
  ];
}
