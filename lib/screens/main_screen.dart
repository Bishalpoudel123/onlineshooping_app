import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
   // Track which tab is currently selected
  int _selectedTabIndex = 0;
  
  // Shopping cart items shared across the app
  final List<ProductCart> _shoppingCart = [];

  // Lazy initialization of screens
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomepageScreen(),
      CartScreen(cartItems: _shoppingCart),
      const FavoritesScreen(),
      const Profile(),
    ];
  }

  /// Get the current cart item count for badge display
  int get _cartItemCount => _shoppingCart.length;
   /// Build cart icon with badge showing item count
  Widget _buildCartIcon() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.shopping_cart),
        if (_cartItemCount > 0) _buildCartBadge(),
      ],
    );
  }
  /// Build the badge showing number of items in cart
  Widget _buildCartBadge() {
    return Positioned(
      right: -6,
      top: -4,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        constraints: const BoxConstraints(
          minWidth: 16,
          minHeight: 16,
        ),
        child: Text(
          '$_cartItemCount',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  /// Bottom navigation items configuration
  List<BottomNavigationBarItem> _buildNavBarItems() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: _buildCartIcon(),
        activeIcon: const Icon(Icons.shopping_cart),
        label: 'Cart',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.favorite_border),
        activeIcon: Icon(Icons.favorite),
        label: 'Favorites',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedTabIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
         type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey.shade600,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: _buildNavBarItems(),
      ),
    );
  }
}