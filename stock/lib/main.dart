
import 'package:flutter/material.dart';

void main() {
  runApp(const StockApp());
}

class StockApp extends StatelessWidget {
  const StockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Manager',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF087F8C),
        ),
      ),
      home: const StockHomePage(),
    );
  }
}

class Product {
  String name;
  int quantity;
  int price;
  String image;

  Product({
    required this.name,
    required this.quantity,
    required this.price,
    required this.image,
  });
}

class StockHomePage extends StatefulWidget {
  const StockHomePage({super.key});

  @override
  State<StockHomePage> createState() => _StockHomePageState();
}

class _StockHomePageState extends State<StockHomePage> {
  final searchController = TextEditingController();

  final List<Product> products = [
    Product(
      name: 'Laptop',
      quantity: 12,
      price: 450000,
      image:
          'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=600',
    ),
    Product(
      name: 'Keyboard',
      quantity: 4,
      price: 25000,
      image:
          'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600',
    ),
    Product(
      name: 'Headphones',
      quantity: 18,
      price: 35000,
      image:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600',
    ),
    Product(
      name: 'Smartphone',
      quantity: 2,
      price: 280000,
      image:
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=600',
    ),
    Product(
      name: 'Camera',
      quantity: 7,
      price: 320000,
      image:
          'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=600',
    ),
    Product(
      name: 'Mouse',
      quantity: 20,
      price: 12000,
      image:
          'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=600',
    ),
  ];

  int get totalQuantity =>
      products.fold(0, (sum, p) => sum + p.quantity);

  int get totalValue =>
      products.fold(0, (sum, p) => sum + p.quantity * p.price);

  int get lowStock =>
      products.where((p) => p.quantity <= 5).length;

  List<Product> get filteredProducts {
    final query = searchController.text.toLowerCase();
    return products
        .where((p) => p.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void addProduct() {
    final name = TextEditingController();
    final quantity = TextEditingController();
    final price = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add New Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Product name',
                  prefixIcon: Icon(Icons.inventory_2_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantity,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  prefixIcon: Icon(Icons.numbers),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: price,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price in FRW',
                  prefixIcon: Icon(Icons.payments_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final productName = name.text.trim();
              final q = int.tryParse(quantity.text);
              final p = int.tryParse(price.text);

              if (productName.isEmpty ||
                  q == null ||
                  q < 0 ||
                  p == null ||
                  p < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Enter valid product details.'),
                  ),
                );
                return;
              }

              setState(() {
                products.add(
                  Product(
                    name: productName,
                    quantity: q,
                    price: p,
                    image: '',
                  ),
                );
              });

              Navigator.pop(dialogContext);
            },
            child: const Text('Add Product'),
          ),
        ],
      ),
    ).then((_) {
      name.dispose();
      quantity.dispose();
      price.dispose();
    });
  }

  void deleteProduct(Product product) {
    setState(() => products.remove(product));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} removed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 750)
            Container(
              width: 220,
              color: const Color(0xFF102A43),
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.inventory_2,
                    color: Colors.white,
                    size: 38,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'StockFlow',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 45),
                  const SideItem(
                    icon: Icons.dashboard_rounded,
                    title: 'Dashboard',
                    selected: true,
                  ),
                  const SideItem(
                    icon: Icons.inventory_2_outlined,
                    title: 'Products',
                  ),
                  const SideItem(
                    icon: Icons.bar_chart_rounded,
                    title: 'Stock Reports',
                  ),
                  const Spacer(),
                  const Divider(color: Colors.white24),
                  const SideItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Inventory made simple.',
                    style: TextStyle(color: Colors.white60),
                  ),
                ],
              ),
            ),
          Expanded(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Stock Management',
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF102A43),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Welcome back! Here is your inventory.',
                                style: TextStyle(
                                  color: Colors.blueGrey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: Color(0xFF087F8C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF087F8C),
                                  Color(0xFF13B8A6),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'YOUR INVENTORY AT A GLANCE',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Everything in\none place.',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 29,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      FilledButton.icon(
                                        style: FilledButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor:
                                              const Color(0xFF087F8C),
                                        ),
                                        onPressed: addProduct,
                                        icon: const Icon(Icons.add),
                                        label: const Text('Add Product'),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.inventory_rounded,
                                  size: 90,
                                  color: Colors.white30,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final count =
                                  constraints.maxWidth > 850 ? 3 : 1;
                              final cards = [
                                SummaryCard(
                                  title: 'Products',
                                  value: '${products.length}',
                                  icon: Icons.category_rounded,
                                  color: const Color(0xFF3977E3),
                                ),
                                SummaryCard(
                                  title: 'Total Units',
                                  value: '$totalQuantity',
                                  icon: Icons.shopping_bag_rounded,
                                  color: const Color(0xFFF59E0B),
                                ),
                                SummaryCard(
                                  title: 'Low Stock',
                                  value: '$lowStock',
                                  icon: Icons.warning_amber_rounded,
                                  color: const Color(0xFFE45858),
                                ),
                              ];

                              return GridView.count(
                                crossAxisCount: count,
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio:
                                    count == 3 ? 1.8 : 3.2,
                                children: cards,
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.account_balance_wallet_rounded,
                                  color: Color(0xFF087F8C),
                                  size: 32,
                                ),
                                const SizedBox(width: 14),
                                const Expanded(
                                  child: Text(
                                    'Total Stock Value',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    '$totalValue FRW',
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color(0xFF087F8C),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'Your Products',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF102A43),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: searchController,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Search products...',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final columns =
                                  constraints.maxWidth > 950
                                      ? 3
                                      : constraints.maxWidth > 550
                                          ? 2
                                          : 1;
                              final items = filteredProducts;

                              if (items.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.all(30),
                                  child: Center(
                                    child: Text('No products found.'),
                                  ),
                                );
                              }

                              return GridView.builder(
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(),
                                itemCount: items.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columns,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  mainAxisExtent: 290,
                                ),
                                itemBuilder: (context, index) {
                                  final product = items[index];
                                  return ProductCard(
                                    product: product,
                                    onDelete: () =>
                                        deleteProduct(product),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SideItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;

  const SideItem({
    super.key,
    required this.icon,
    required this.title,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF087F8C) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 21),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 25),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.blueGrey),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isLow = product.quantity <= 5;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 145,
                width: double.infinity,
                child: product.image.isEmpty
                    ? Container(
                        color: const Color(0xFFE7F3F3),
                        child: const Icon(
                          Icons.inventory_2_rounded,
                          size: 60,
                          color: Color(0xFF087F8C),
                        ),
                      )
                    : Image.network(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFE7F3F3),
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            size: 50,
                            color: Color(0xFF087F8C),
                          ),
                        ),
                      ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isLow
                        ? const Color(0xFFFFE5E5)
                        : const Color(0xFFD9F8EA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isLow ? 'Low stock' : 'In stock',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isLow
                          ? Colors.red.shade700
                          : Colors.green.shade800,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black45,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${product.quantity} units available',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${product.price} FRW',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF087F8C),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Color(0xFF087F8C),
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
