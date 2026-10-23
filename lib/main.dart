
import 'package:flutter/material.dart';

void main() {
  runApp(const DevIraqApp());
}

const Color bg = Color(0xFF0D0B12);
const Color panel = Color(0xFF191421);
const Color purple = Color(0xFF9B5CFF);
const Color muted = Color(0xFFAAA2B8);

class DevIraqApp extends StatelessWidget {
  const DevIraqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DEV IRAQ',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: purple,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selected = 0;

  final List<Map<String, dynamic>> services = [
    {'icon': Icons.restaurant, 'name': 'مطاعم', 'color': Colors.orange},
    {'icon': Icons.shopping_basket, 'name': 'مواد غذائية', 'color': Colors.green},
    {'icon': Icons.local_grocery_store, 'name': 'متاجر', 'color': Colors.blue},
    {'icon': Icons.delivery_dining, 'name': 'توصيل خاص', 'color': purple},
    {'icon': Icons.medical_services, 'name': 'صيدليات', 'color': Colors.redAccent},
    {'icon': Icons.more_horiz, 'name': 'خدمات أخرى', 'color': Colors.teal},
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: selected,
            children: [
              buildHome(),
              buildOrders(),
              buildMessages(),
              buildProfile(),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: panel,
          indicatorColor: purple.withValues(alpha: 0.22),
          selectedIndex: selected,
          onDestinationSelected: (index) {
            setState(() => selected = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: purple),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long, color: purple),
              label: 'طلباتي',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat, color: purple),
              label: 'الرسائل',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: purple),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHome() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: purple.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.delivery_dining,
                  color: purple, size: 30),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DEV IRAQ',
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2)),
                  Text('كل احتياجاتك بمكان واحد',
                      style: TextStyle(color: muted, fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              onPressed: () => showMessage('الإشعارات'),
              icon: const Icon(Icons.notifications_none, size: 28),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4C2184), Color(0xFF21142F)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('أهلاً بيك في DEV IRAQ',
                  style: TextStyle(
                      fontSize: 21, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('اطلب احتياجاتك وخلي التوصيل علينا',
                  style: TextStyle(color: Colors.white70)),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.flash_on, color: Colors.amber),
                  SizedBox(width: 6),
                  Text('سهولة • سرعة • راحة',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          onSubmitted: (value) {
            showMessage(value.isEmpty
                ? 'اكتب اسم الشي اللي تبحث عنه'
                : 'بحث تجريبي عن: $value');
          },
          decoration: InputDecoration(
            hintText: 'ابحث عن مطعم أو متجر...',
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
        const Text('الأقسام',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final item = services[index];
            final color = item['color'] as Color;
            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => showMessage(
                  'قسم ${item['name']} جاهز لإضافة المتاجر والمنتجات'),
              child: Container(
                decoration: BoxDecoration(
                  color: panel,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'] as IconData,
                        size: 32, color: color),
                    const SizedBox(height: 10),
                    Text(item['name'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        const Text('خدماتنا',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: panel,
            borderRadius: BorderRadius.circular(17),
          ),
          child: const Row(
            children: [
              Icon(Icons.local_shipping, color: purple, size: 35),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('توصيل الطلبات',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text('اطلب من المتاجر المشاركة بالتطبيق',
                        style: TextStyle(color: muted, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.arrow_back_ios_new, size: 16),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Text('برمجة وتطوير: علاوي ال حمادي',
              style: TextStyle(color: muted, fontSize: 12)),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget buildOrders() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long, size: 70, color: purple),
            SizedBox(height: 16),
            Text('طلباتي', style: TextStyle(fontSize: 24)),
            SizedBox(height: 8),
            Text('طلباتك راح تظهر هنا بعد ربط قاعدة البيانات.',
                textAlign: TextAlign.center,
                style: TextStyle(color: muted)),
          ],
        ),
      ),
    );
  }

  Widget buildMessages() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.forum_outlined, size: 70, color: purple),
          const SizedBox(height: 16),
          const Text('المراسلة', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          const Text('قسم المحادثات',
              style: TextStyle(color: muted)),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => showMessage(
                'المراسلة حالياً واجهة أولية وتحتاج ربطاً بخدمة حقيقية.'),
            icon: const Icon(Icons.chat),
            label: const Text('بدء محادثة'),
          ),
        ],
      ),
    );
  }

  Widget buildProfile() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 42,
              backgroundColor: Color(0xFF302044),
              child: Icon(Icons.person, size: 48, color: purple),
            ),
            const SizedBox(height: 16),
            const Text('حسابي',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('سجّل دخولك لاحقاً حتى تدير طلباتك',
                textAlign: TextAlign.center,
                style: TextStyle(color: muted)),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () => showMessage(
                  'تسجيل الدخول غير مفعّل بعد؛ سنضيفه بالخطوة القادمة.'),
              icon: const Icon(Icons.login),
              label: const Text('تسجيل الدخول'),
            ),
            const SizedBox(height: 30),
            const Text('برمجة: علاوي ال حمادي',
                style: TextStyle(color: muted, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
