import 'package:get/get.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class OrderController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxList<String> categories = <String>[].obs;
  
  final RxString searchTerm = ''.obs;
  final RxString selectedCategory = ''.obs;
  
  // Mapping productId to quantity to add
  final RxMap<String, int> quantities = <String, int>{}.obs;

  // Cart logic
  final RxList<CartItem> cart = <CartItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockProducts();
  }

  void _loadMockProducts() {
    final mockData = [
      Product(
        id: '1',
        name: 'Fresh Tomatoes',
        price: 40.00,
        description: 'Ripe and juicy tomatoes, perfect for curries and salads',
        image: 'https://images.unsplash.com/photo-1546470427-1d1d3d1d7?w=300&h=200&fit=crop',
        category: 'Vegetables'
      ),
      Product(
        id: '2',
        name: 'Onions',
        price: 35.00,
        description: 'Fresh red onions, essential for Indian cooking',
        image: 'https://images.unsplash.com/photo-1528747247525-3d40b2445e?w=300&h=200&fit=crop',
        category: 'Vegetables'
      ),
      Product(
        id: '3',
        name: 'Potatoes',
        price: 30.00,
        description: 'Fresh potatoes, versatile for all Indian dishes',
        image: 'https://images.unsplash.com/photo-1518979132600-261b355a3b?w=300&h=200&fit=crop',
        category: 'Vegetables'
      ),
      Product(
        id: '7',
        name: 'Mangoes',
        price: 120.00,
        description: 'Sweet and juicy Alphonso mangoes, king of fruits',
        image: 'https://images.unsplash.com/photo-15532797639-cf84fade48b6?w=300&h=200&fit=crop',
        category: 'Fruits'
      ),
      Product(
        id: '8',
        name: 'Bananas',
        price: 40.00,
        description: 'Fresh ripe bananas, rich in potassium',
        image: 'https://images.unsplash.com/photo-1566398346732-9c4724e3f4?w=300&h=200&fit=crop',
        category: 'Fruits'
      ),
      Product(
        id: '13',
        name: 'Toor Dal',
        price: 80.00,
        description: 'Split pigeon peas, perfect for dal makhani',
        image: 'https://images.unsplash.com/photo-1596531493673-8c4e6d7c5?w=300&h=200&fit=crop',
        category: 'Pulses'
      ),
      Product(
        id: '17',
        name: 'Turmeric Powder',
        price: 35.00,
        description: 'Pure turmeric powder, essential for Indian cooking',
        image: 'https://images.unsplash.com/photo-157717478439-7589d2c12f0?w=300&h=200&fit=crop',
        category: 'Spices'
      ),
      Product(
        id: '22',
        name: 'Fresh Milk',
        price: 55.00,
        description: 'Pure and fresh cow milk, 1 liter pack',
        image: 'https://images.unsplash.com/photo-1586201375761-832e0c99f3?w=300&h=200&fit=crop',
        category: 'Dairy'
      ),
    ];

    products.value = mockData;
    categories.value = [
      'Vegetables',
      'Fruits',
      'Dairy',
      'Grains',
      'Spices',
      'Snacks',
      'Beverages',
      'Household',
      'Pulses'
    ];

    for (var prod in mockData) {
      quantities[prod.id] = 1;
    }
  }

  List<Product> get filteredProducts {
    return products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(searchTerm.value.toLowerCase()) || 
                            product.description.toLowerCase().contains(searchTerm.value.toLowerCase());
      final matchesCategory = selectedCategory.value.isEmpty || product.category == selectedCategory.value;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity >= 1) {
      quantities[productId] = newQuantity;
    }
  }

  void addToCart(Product product) {
    int qty = quantities[product.id] ?? 1;
    
    // Check if item exists in cart
    int index = cart.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      cart[index].quantity += qty;
      cart.refresh(); // Tells GetX to update UI
    } else {
      cart.add(CartItem(product: product, quantity: qty));
    }
    
    // Reset quantity back to 1
    quantities[product.id] = 1;
    Get.snackbar(
      'Cart', 
      '${product.name} added to cart',
      snackPosition: SnackPosition.BOTTOM
    );
  }
}
