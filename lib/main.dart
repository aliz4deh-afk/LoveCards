import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LoveCardsApp());
}

class LoveCardsApp extends StatelessWidget {
  const LoveCardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Love & Intimacy Guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFFE91E63),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE91E63),
          secondary: Color(0xFFFF4081),
          surface: Color(0xFF1E1E1E),
        ),
        fontFamily: 'Roboto',
      ),
      home: const CategoriesPage(),
    );
  }
}

// مدل داده پوزیشن‌ها
class PositionItem {
  final String id;
  final String title;
  final String imagePath;
  final String description;
  final String difficulty; // آسان، متوسط، پیشرفته

  PositionItem({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.description,
    this.difficulty = 'متوسط',
  });
}

// مدل داده دسته‌بندی‌ها
class Category {
  final String id;
  final String title;
  final String icon;
  final String description;
  final List<PositionItem> items;

  Category({
    required this.id,
    required this.title,
    required this.icon,
    required this.description,
    required this.items,
  });
}

// صفحه اصلی: لیست دسته‌بندی‌ها
class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  List<Category> _getSampleCategories() {
    return [
      Category(
        id: 'foreplay',
        title: 'پیش‌نوازی و ماساژ',
        icon: '🕯️',
        description: 'ایجاد آمادگی، آرامش و صمیمیت بیشتر',
        items: List.generate(
          25,
          (i) => PositionItem(
            id: 'foreplay_$i',
            title: 'حالت شماره ${i + 1}',
            imagePath: '${(i % 5) + 1}.png',
            description: 'توضیحات و نکات کلیدی برای اجرای بهتر این حالت...',
            difficulty: i % 2 == 0 ? 'آسان' : 'متوسط',
          ),
        ),
      ),
      Category(
        id: 'oral',
        title: 'پوزیشن‌های دهانی',
        icon: '💋',
        description: 'تنوع و تکنیک‌های تحریک دهانی',
        items: List.generate(
          35,
          (i) => PositionItem(
            id: 'oral_$i',
            title: 'حالت شماره ${i + 1}',
            imagePath: '${(i % 5) + 1}.png',
            description: 'توضیحات و نکات مربوط به زاویه و تنفس...',
            difficulty: 'متوسط',
          ),
        ),
      ),
      Category(
        id: 'vaginal',
        title: 'پوزیشن‌های واژینال',
        icon: '💖',
        description: 'حالت‌های متنوع برای دخول واژینال',
        items: List.generate(
          50,
          (i) => PositionItem(
            id: 'vaginal_$i',
            title: 'حالت شماره ${i + 1}',
            imagePath: '${(i % 5) + 1}.png',
            description: 'میزان نفوذ و کنترل در این پوزیشن...',
            difficulty: i % 3 == 0 ? 'پیشرفته' : 'متوسط',
          ),
        ),
      ),
      Category(
        id: 'anal',
        title: 'پوزیشن‌های مقعدی',
        icon: '🔥',
        description: 'حالت‌های مناسب همراه با نکات ایمنی',
        items: List.generate(
          30,
          (i) => PositionItem(
            id: 'anal_$i',
            title: 'حالت شماره ${i + 1}',
            imagePath: '${(i % 5) + 1}.png',
            description: 'نکات بهداشتی و آمادگی‌های لازم...',
            difficulty: 'پیشرفته',
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final categories = _getSampleCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('راهنمای روابط زوجین', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.grey[900]!, Colors.grey[850]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(20),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Text(cat.icon, style: const TextStyle(fontSize: 28)),
              ),
              title: Text(
                cat.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '${cat.description}\n${cat.items.length} پوزیشن',
                  style: TextStyle(color: Colors.grey[400], height: 1.3),
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.pinkAccent),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryGridPage(category: cat),
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

// صفحه دوم: نمایش کارت‌ها با قابلیت SharedPreferences و Pagination
class CategoryGridPage extends StatefulWidget {
  final Category category;
  const CategoryGridPage({super.key, required this.category});

  @override
  State<CategoryGridPage> createState() => _CategoryGridPageState();
}

class _CategoryGridPageState extends State<CategoryGridPage> {
  int currentPage = 0;
  final int itemsPerPage = 20;
  Set<String> revealedIds = {};

  @override
  void initState() {
    super.initState();
    _loadRevealedCards();
  }

  // بارگذاری کارت‌های آنلاک‌شده از قبل
  Future<void> _loadRevealedCards() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      revealedIds = (prefs.getStringList('revealed_cards') ?? []).toSet();
    });
  }

  // ذخیره کارت جدید تراشیده شده
  Future<void> _markAsRevealed(String id) async {
    final prefs = await SharedPreferences.getInstance();
    revealedIds.add(id);
    await prefs.setStringList('revealed_cards', revealedIds.toList());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = widget.category.items.length;
    final totalPages = (totalItems / itemsPerPage).ceil();

    final startIndex = currentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage < totalItems) ? startIndex + itemsPerPage : totalItems;

    final currentItems = widget.category.items.sublist(startIndex, endIndex);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: currentItems.length,
              itemBuilder: (context, index) {
                final item = currentItems[index];
                final isRevealed = revealedIds.contains(item.id);

                return GestureDetector(
                  onTap: () {
                    if (isRevealed) {
                      _showDetailDialog(context, item);
                    }
                  },
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    clipBehavior: Clip.antiAlias,
                    child: isRevealed
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(item.imagePath, fit: BoxFit.cover),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                  color: Colors.black87,
                                  child: Text(
                                    item.title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Scratcher(
                            brushSize: 40,
                            threshold: 40,
                            color: Colors.pink[700]!,
                            onThreshold: () => _markAsRevealed(item.id),
                            child: Container(
                              color: Colors.black,
                              child: Image.asset(item.imagePath, fit: BoxFit.cover),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
          if (totalPages > 1)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: currentPage > 0 ? () => setState(() => currentPage--) : null,
                  ),
                  Text('صفحه ${currentPage + 1} از $totalPages', style: const TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: currentPage < totalPages - 1 ? () => setState(() => currentPage++) : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // نمایش کارت به صورت کامل و حرفه‌ای
  void _showDetailDialog(BuildContext context, PositionItem item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Image.asset(item.imagePath, height: 250, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Chip(
                        label: Text(item.difficulty, style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.pink.withOpacity(0.2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(item.description, style: TextStyle(color: Colors.grey[300], height: 1.4)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[700],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('بستن'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
