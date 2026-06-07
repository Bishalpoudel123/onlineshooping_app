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
      name: 'Sunglasses',
      price: 1500.99,
      description: 'Stylish UV-protected sunglasses for everyday use.',
      image: 'https://images.pexels.com/photos/29274468/pexels-photo-29274468.jpeg',
    ),
    ProductCart(
      name: 'Iron',
      price: 1100.34,
      description: 'Powerful steam iron for wrinkle-free clothes.',
      image: 'https://images.pexels.com/photos/7703649/pexels-photo-7703649.jpeg',
    ),
    ProductCart(
      name: 'Water Kettle',
      price: 1260,
      description: 'Fast boiling electric kettle with auto shut-off.',
      image: 'https://images.pexels.com/photos/30319667/pexels-photo-30319667.jpeg',
    ),
    ProductCart(
      name: 'Water Bottle',
      price: 80,
      description: 'Eco-friendly reusable water bottle.',
      image: 'https://images.pexels.com/photos/13055851/pexels-photo-13055851.jpeg',
    ),
    ProductCart(
      name: 'Coffee Cup',
      price: 99,
      description: 'Ceramic coffee cup, perfect for your morning brew.',
      image: 'https://images.pexels.com/photos/30748857/pexels-photo-30748857.jpeg',
    ),
    ProductCart(
      name: 'Dairy Milk',
      price: 250,
      description: 'Fresh full-cream dairy milk, 1 litre pack.',
      image: 'https://images.pexels.com/photos/4113348/pexels-photo-4113348.jpeg',
    ),
  ];
}