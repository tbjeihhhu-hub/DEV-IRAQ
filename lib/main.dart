
import 'package:flutter/material.dart';

void main() => runApp(const DevIraqApp());

const bg = Color(0xFF0D0B12);
const panel = Color(0xFF191421);
const purple = Color(0xFF9B5CFF);
const muted = Color(0xFFAAA2B8);

class Product {
  final String name;
  final String category;
  final int price;
  final IconData icon;

  const Product(this.name, this.category, this.price, this.icon);
}

const categories = [
  {'name': 'مطاعم', 'icon': Icons.restaurant},
  {'name': 'مواد غذائية', 'icon': Icons.shopping_basket},
  {'name': 'متاجر', 'icon': Icons.store},
  {'name': 'توصيل خاص', 'icon': Icons.delivery_dining},
  {'name': 'صيدليات', 'icon': Icons.medical_services},
  {'name': 'خدمات أخرى', 'icon': Icons.more_horiz},
];

const products = [
  Product('وجبة برغر', 'مطاعم', 5000, Icons.lunch_dining),
  Product('بيتزا', 'مطاعم', 7000, Icons.local_pizza),
  Product('شاورما', 'مطاعم', 3000, Icons.fastfood),
  Product('دجاج مشوي', 'مطاعم', 8000, Icons.restaurant),
  Product('سلة خضار', 'مواد غذائية', 4000, Icons.eco),
  Product('فواكه مشكلة', 'مواد غذائية', 5000, Icons.apple),
  Product('ماء للشرب', 'مواد غذائية', 1000, Icons.water_drop),
  Product('مواد منزلية', 'متاجر', 6000, Icons.home),
  Product('سماعات', 'متاجر', 10000, Icons.headphones),
  Product('دفتر وأقلام', 'متاجر', 2500, Icons.edit),
  Product('طلب توصيل', 'توصيل خاص', 3000, Icons.delivery_dining),
  Product('مستلزمات صيدلية', 'صيدليات', 4000, Icons.medical_services),
  Product('طرد صغير', 'خدمات أخرى', 3500, Icons.inventory_2),
];

class DevIraqApp extends StatefulWidget {
  const DevIraqApp({super.key});

  @override
  State<DevIraqApp> createState() => _DevIraqAppState();
}

class _DevIraqAppState extends State<DevIraqApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  int tab = 0;
  final Map<String, int> cart = {};
  final List<Map<String, dynamic>> orders = [];

  int get cartCount => cart.values.fold(0, (a, b) => a + b);

  int get total => cart.entries.fold(0, (sum, entry) {
        final p = products.firstWhere((p) => p.name == entry.key);
        return sum + p.price * entry.value;
      });

  void add(Product p) {
    setState(() {
      cart[p.name] = (cart[p.name] ?? 0) + 1;
    });
  }

  void changeQty(Product p, int delta) {
    setState(() {
      final next = (cart[p.name] ?? 0) + delta;
      if (next <= 0) {
        cart.remove(p.name);
      } else {
        cart[p.name] = next;
      }
    });
  }

  void showMessage(String message) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void checkout() {
    if (cart.isEmpty) {
      showMessage('السلة فارغة، أضف منتجاً أولاً');
      return;
    }

    final orderTotal = total;
    final orderItems = Map<String, int>.from(cart);

    setState(() {
      orders.insert(0, {
        'number': orders.length + 1,
        'items': orderItems,
        'total': orderTotal,
        'status': 'تم استلام الطلب محلياً',
      });
      cart.clear();
      tab = 1;
    });

    navigatorKey.currentState?.pop();
    showMessage('تم إنشاء الطلب التجريبي بنجاح');
  }

  void openCategory(String category) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => CategoryScreen(
          category: category,
          onAdd: add,
          onCart: openCart,
        ),
      ),
    );
  }

  void openSearch(String query) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => SearchScreen(
          query: query,
          onAdd: add,
        ),
      ),
    );
  }

  void openCart() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => CartScreen(
          cart: cart,
          getTotal: () => total,
          onChange: changeQty,
          onCheckout: checkout,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'DEV IRAQ',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: purple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: bg,
          foregroundColor: Colors.white,
        ),
      ),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: tab,
            children: [
              HomeScreen(
                onCategory: openCategory,
                onSearch: openSearch,
                onCart: openCart,
                onAdd: add,
                cartCount: cartCount,
              ),
              OrdersScreen(orders: orders),
              const ChatScreen(),
              const ProfileScreen(),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: panel,
          indicatorColor: purple.withValues(alpha: 0.2),
          selectedIndex: tab,
          onDestinationSelected: (i) {
            setState(() => tab = i);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long),
              label: 'طلباتي',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_outlined),
              label: 'الرسائل',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final void Function(String) onCategory;
  final void Function(String) onSearch;
  final VoidCallback onCart;
  final void Function(Product) onAdd;
  final int cartCount;

  const HomeScreen({
    super.key,
    required this.onCategory,
    required this.onSearch,
    required this.onCart,
    required this.onAdd,
    required this.cartCount,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final search = TextEditingController();

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Row(
          children: [
            const Icon(
              Icons.delivery_dining,
              color: purple,
              size: 38,
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DEV IRAQ',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'كل احتياجاتك بمكان واحد',
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: widget.onCart,
              icon: Badge(
                label: Text('${widget.cartCount}'),
                isLabelVisible: widget.cartCount > 0,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF54268A), Color(0xFF21142F)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'أهلاً بيك في DEV IRAQ',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('اطلب احتياجاتك وخلي التوصيل علينا'),
              SizedBox(height: 12),
              Text('⚡ سهولة • سرعة • راحة'),
            ],
          ),
        ),
        const SizedBox(height: 18),
        TextField(
          controller: search,
          onSubmitted: (v) {
            if (v.trim().isNotEmpty) {
              widget.onSearch(v.trim());
            }
          },
          decoration: InputDecoration(
            hintText: 'ابحث عن منتج...',
            prefixIcon: const Icon(Icons.search, color: purple),
            filled: true,
            fillColor: panel,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'الأقسام',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.92,
          ),
          itemBuilder: (_, i) {
            final c = categories[i];
            return Material(
              color: panel,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => widget.onCategory(c['name'] as String),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        c['icon'] as IconData,
                        color: purple,
                        size: 32,
                      ),
                      const SizedBox(height: 9),
                      Text(
                        c['name'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'منتجات مقترحة',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...products.take(4).map(
              (p) => ProductTile(
                product: p,
                onAdd: () {
                  widget.onAdd(p);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('أُضيف ${p.name} إلى السلة')),
                  );
                },
              ),
            ),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'برمجة وتطوير: علاوي ال حمادي',
            style: TextStyle(color: muted, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class CategoryScreen extends StatelessWidget {
  final String category;
  final void Function(Product) onAdd;
  final VoidCallback onCart;

  const CategoryScreen({
    super.key,
    required this.category,
    required this.onAdd,
    required this.onCart,
  });

  @override
  Widget build(BuildContext context) {
    final items = products.where((p) => p.category == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        actions: [
          IconButton(
            onPressed: onCart,
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: items.isEmpty
          ? const Center(
              child: Text('ماكو منتجات معروضة بهذا القسم حالياً'),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'منتجات قسم $category',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...items.map(
                  (p) => ProductTile(
                    product: p,
                    onAdd: () {
                      onAdd(p);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('أُضيف ${p.name} إلى السلة'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'المنتجات والأسعار تجريبية وليست عروض متاجر مؤكدة.',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
              ],
            ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const ProductTile({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: panel,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: purple.withValues(alpha: 0.18),
          child: Icon(product.icon, color: purple),
        ),
        title: Text(product.name),
        subtitle: Text('${product.price} د.ع • ${product.category}'),
        trailing: IconButton(
          onPressed: onAdd,
          icon: const Icon(
            Icons.add_circle,
            color: purple,
            size: 30,
          ),
        ),
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  final String query;
  final void Function(Product) onAdd;

  const SearchScreen({
    super.key,
    required this.query,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final results = products
        .where(
          (p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.category.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('نتائج البحث: $query')),
      body: results.isEmpty
          ? const Center(
              child: Text('ما لكينا منتجات مطابقة للبحث'),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: results
                  .map(
                    (p) => ProductTile(
                      product: p,
                      onAdd: () {
                        onAdd(p);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('أُضيف ${p.name} إلى السلة'),
                          ),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class CartScreen extends StatefulWidget {
  final Map<String, int> cart;
  final int Function() getTotal;
  final void Function(Product, int) onChange;
  final VoidCallback onCheckout;

  const CartScreen({
    super.key,
    required this.cart,
    required this.getTotal,
    required this.onChange,
    required this.onCheckout,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final entries = widget.cart.entries.toList();
    final total = widget.getTotal();

    return Scaffold(
      appBar: AppBar(title: const Text('سلة المشتريات')),
      body: entries.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 65,
                    color: purple,
                  ),
                  SizedBox(height: 12),
                  Text('السلة فارغة'),
                  Text(
                    'أضف المنتجات من الأقسام',
                    style: TextStyle(color: muted),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: entries.map((entry) {
                      final p = products.firstWhere(
                        (p) => p.name == entry.key,
                      );

                      return Card(
                        color: panel,
                        child: ListTile(
                          title: Text(p.name),
                          subtitle: Text('${p.price} د.ع للقطعة'),
                          leading: Icon(p.icon, color: purple),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  widget.onChange(p, -1);
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                ),
                              ),
                              Text('${entry.value}'),
                              IconButton(
                                onPressed: () {
                                  widget.onChange(p, 1);
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  color: panel,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'المجموع',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            '$total د.ع',
                            style: const TextStyle(
                              fontSize: 20,
                              color: purple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: widget.onCheckout,
                          child: const Text('إنشاء طلب تجريبي'),
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

class OrdersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> orders;

  const OrdersScreen({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.receipt_long,
                color: purple,
                size: 70,
              ),
              SizedBox(height: 12),
              Text('طلباتي', style: TextStyle(fontSize: 24)),
              SizedBox(height: 8),
              Text(
                'طلباتك الجديدة راح تظهر هنا بعد إنشائها.',
                textAlign: TextAlign.center,
                style: TextStyle(color: muted),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'طلباتي',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...orders.map((o) {
          final items = o['items'] as Map<String, int>;

          return Card(
            color: panel,
            child: ExpansionTile(
              title: Text('طلب رقم ${o['number']}'),
              subtitle: Text('${o['total']} د.ع'),
              children: [
                ...items.entries.map(
                  (e) => ListTile(
                    title: Text(e.key),
                    trailing: Text('الكمية: ${e.value}'),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                    color: purple,
                  ),
                  title: Text(o['status'] as String),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 12),
        const Text(
          'الطلبات محفوظة في ذاكرة التطبيق الحالية فقط، '
          'وليست مرسلة إلى متجر أو مندوب.',
          style: TextStyle(color: muted, fontSize: 12),
        ),
      ],
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final List<String> messages = [];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(Icons.forum, color: purple, size: 30),
              SizedBox(width: 10),
              Text(
                'المراسلة',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: messages.isEmpty
              ? const Center(
                  child: Text(
                    'اكتب رسالة تجريبية لتظهر هنا',
                    style: TextStyle(color: muted),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: messages
                      .map(
                        (m) => Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: panel,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(m),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'اكتب رسالتك...',
                    filled: true,
                    fillColor: panel,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  final message = controller.text.trim();
                  if (message.isEmpty) return;

                  setState(() {
                    messages.add(message);
                    controller.clear();
                  });
                },
                icon: const Icon(Icons.send, color: purple),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'محادثة محلية تجريبية وليست متصلة بمستخدم آخر',
            style: TextStyle(color: muted, fontSize: 11),
          ),
        ),
      ],
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final name = TextEditingController();
  final phone = TextEditingController();
  bool saved = false;

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        const CircleAvatar(
          radius: 42,
          backgroundColor: Color(0xFF302044),
          child: Icon(
            Icons.person,
            size: 48,
            color: purple,
          ),
        ),
        const SizedBox(height: 14),
        const Center(
          child: Text(
            'حسابي',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 22),
        TextField(
          controller: name,
          decoration: const InputDecoration(
            labelText: 'الاسم',
            prefixIcon: Icon(Icons.person_outline),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: phone,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'رقم الهاتف',
            prefixIcon: Icon(Icons.phone_outlined),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () {
            setState(() => saved = true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تحديث البيانات في هذه الجلسة'),
              ),
            );
          },
          icon: const Icon(Icons.save_outlined),
          label: const Text('حفظ البيانات مؤقتاً'),
        ),
        if (saved)
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Text(
              'أهلاً ${name.text}',
              style: const TextStyle(color: purple),
            ),
          ),
        const SizedBox(height: 30),
        const Center(
          child: Text(
            'برمجة وتطوير: علاوي ال حمادي',
            style: TextStyle(color: muted, fontSize: 12),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'الحساب الحالي غير مربوط بتسجيل دخول حقيقي.',
          textAlign: TextAlign.center,
          style: TextStyle(color: muted, fontSize: 12),
        ),
      ],
    );
  }
}
