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
      ),
      home: const FilterAndCatalogPage(),
    );
  }
}

// مدل کامل ویژگی‌های هر پوزیشن
class PositionItem {
  final String id;
  final String title;
  final String imagePath;
  final String description;

  // فیلترها و ویژگی‌ها
  final String positionType;
  final String stimulation;
  final String penetration;
  final List<String> addPetting;
  final String location;
  final String activity;
  final String complexity;
  final bool isLesbian;

  PositionItem({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.description,
    required this.positionType,
    required this.stimulation,
    required this.penetration,
    required this.addPetting,
    required this.location,
    required this.activity,
    required this.complexity,
    this.isLesbian = false,
  });
}

class FilterAndCatalogPage extends StatefulWidget {
  const FilterAndCatalogPage({super.key});

  @override
  State<FilterAndCatalogPage> createState() => _FilterAndCatalogPageState();
}

class _FilterAndCatalogPageState extends State<FilterAndCatalogPage> {
  Set<String> revealedIds = {};
  
  // متغیرهای فیلتر انتخاب شده
  String? selectedPositionType;
  String? selectedStimulation;
  String? selectedPenetration;
  String? selectedLocation;
  String? selectedActivity;
  String? selectedComplexity;
  bool filterLesbianOnly = false;

  int currentPage = 0;
  final int itemsPerPage = 20;

  // نمونه اطلاعات اولیه ۳۰۰ پوزیشن آینده با ساختار تگ‌ها
  late List<PositionItem> allPositions;

  @override
  void initState() {
    super.initState();
    _loadRevealedCards();
    _generateSamplePositions();
  }

  Future<void> _loadRevealedCards() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      revealedIds = (prefs.getStringList('revealed_cards') ?? []).toSet();
    });
  }

  Future<void> _markAsRevealed(String id) async {
    final prefs = await SharedPreferences.getInstance();
    revealedIds.add(id);
    await prefs.setStringList('revealed_cards', revealedIds.toList());
    setState(() {});
  }

  void _generateSamplePositions() {
    final types = ['69 sex position', 'anal sex', 'blowjob', 'anilingus', 'cowgirl', 'criss cross', 'cunnilingus', 'doggy style', 'face to face', 'from behind', 'kneeling', 'lying down', 'man on top', 'oral sex', 'reverse', 'right angle', 'sideways', 'sitting', 'standing', 'woman on top'];
    final stimulations = ['A-spot', 'clitoral', 'G-spot', 'neutral', 'Deep spot'];
    final penetrations = ['deep', 'middle', 'shallow', 'no penetration'];
    final locations = ['armchair', 'ball', 'bed', 'chair', 'sofa', 'table', 'car', 'shower'];
    final activities = ['man active', 'woman active'];
    final complexities = ['easy', 'medium', 'hard', 'crazy'];

    allPositions = List.generate(100, (i) {
      return PositionItem(
        id: 'pos_$i',
        title: 'پوزیشن شماره ${i + 1}',
        imagePath: '${(i % 5) + 1}.png',
        description: 'توضیحات و شیوه صحیح اجرای پوزیشن شماره ${i + 1}...',
        positionType: types[i % types.length],
        stimulation: stimulations[i % stimulations.length],
        penetration: penetrations[i % penetrations.length],
        addPetting: ['kissing', 'hugging'],
        location: locations[i % locations.length],
        activity: activities[i % activities.length],
        complexity: complexities[i % complexities.length],
        isLesbian: i % 10 == 0,
      );
    });
  }

  List<PositionItem> get filteredPositions {
    return allPositions.where((item) {
      if (selectedPositionType != null && item.positionType != selectedPositionType) return false;
      if (selectedStimulation != null && item.stimulation != selectedStimulation) return false;
      if (selectedPenetration != null && item.penetration != selectedPenetration) return false;
      if (selectedLocation != null && item.location != selectedLocation) return false;
      if (selectedActivity != null && item.activity != selectedActivity) return false;
      if (selectedComplexity != null && item.complexity != selectedComplexity) return false;
      if (filterLesbianOnly && !item.isLesbian) return false;
      return true;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      selectedPositionType = null;
      selectedStimulation = null;
      selectedPenetration = null;
      selectedLocation = null;
      selectedActivity = null;
      selectedComplexity = null;
      filterLesbianOnly = false;
      currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = filteredPositions;
    final totalItems = list.length;
    final totalPages = (totalItems / itemsPerPage).ceil();

    final startIndex = currentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage < totalItems) ? startIndex + itemsPerPage : totalItems;

    final currentItems = totalItems > 0 ? list.sublist(startIndex, endIndex) : <PositionItem>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('کاتالوگ و فیلتر پیشرفته', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_alt, color: Colors.pinkAccent),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // نوار خلاصه فیلترها
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[900],
            child: Row(
              children: [
                Text('تعداد یافته‌ها: $totalItems', style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                if (selectedPositionType != null || selectedComplexity != null || selectedLocation != null)
                  TextButton.icon(
                    onPressed: _resetFilters,
                    icon: const Icon(Icons.clear, size: 16, color: Colors.pinkAccent),
                    label: const Text('حذف فیلترها', style: TextStyle(color: Colors.pinkAccent)),
                  ),
              ],
            ),
          ),

          // شبکه کارت‌ها (GridView)
          Expanded(
            child: currentItems.isEmpty
                ? const Center(child: Text('هیچ پوزیشنی با این فیلتر یافت نشد!'))
                : GridView.builder(
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
                          if (isRevealed) _showDetailDialog(context, item);
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
                                        padding: const EdgeInsets.all(6),
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

          // کنترل‌های صفحه‌بندی (Pagination)
          if (totalPages > 1)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: Colors.grey[900],
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

  // پنل فیلتر پیشرفته از پایین صفحه
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Widget buildSection(String title, List<String> options, String? selectedValue, Function(String?) onSelect) {
              return Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
                  ),
                  Wrap(
                    spacing: 8,
                    children: options.map((opt) {
                      final isSelected = selectedValue == opt;
                      return ChoiceChip(
                        label: Text(opt),
                        selected: isSelected,
                        selectedColor: Colors.pink[700],
                        onSelected: (selected) {
                          setModalState(() => onSelect(selected ? opt : null));
                          setState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  const Divider(),
                ],
              );
            }

            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.85,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('فیلتر بر اساس تگ‌ها', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    buildSection('Complexity (درجه سختی)', ['easy', 'medium', 'hard', 'crazy'], selectedComplexity, (val) => selectedComplexity = val),
                    buildSection('Stimulation (نقطه تحریک)', ['A-spot', 'clitoral', 'G-spot', 'neutral', 'Deep spot'], selectedStimulation, (val) => selectedStimulation = val),
                    buildSection('Penetration (میزان دخول)', ['deep', 'middle', 'shallow', 'no penetration'], selectedPenetration, (val) => selectedPenetration = val),
                    buildSection('Location (مکان)', ['armchair', 'ball', 'bed', 'chair', 'sofa', 'table', 'car', 'shower'], selectedLocation, (val) => selectedLocation = val),
                    buildSection('Activity (میزان فعالیت)', ['man active', 'woman active'], selectedActivity, (val) => selectedActivity = val),
                    buildSection('Position Type (نوع پوزیشن)', ['69 sex position', 'anal sex', 'blowjob', 'anilingus', 'cowgirl', 'criss cross', 'cunnilingus', 'doggy style', 'face to face', 'from behind', 'kneeling', 'lying down', 'man on top', 'oral sex', 'reverse', 'right angle', 'sideways', 'sitting', 'standing', 'woman on top'], selectedPositionType, (val) => selectedPositionType = val),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[700]),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('اعمال فیلترها'),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // نمایش جزئیات کامل همراه با تگ‌ها
  void _showDetailDialog(BuildContext context, PositionItem item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Image.asset(item.imagePath, height: 220, width: double.infinity, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    Text(item.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(item.description, style: TextStyle(color: Colors.grey[300])),
                    const SizedBox(height: 16),
                    const Text('ویژگی‌های این پوزیشن:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        Chip(label: Text('Type: ${item.positionType}')),
                        Chip(label: Text('Stimulation: ${item.stimulation}')),
                        Chip(label: Text('Penetration: ${item.penetration}')),
                        Chip(label: Text('Location: ${item.location}')),
                        Chip(label: Text('Complexity: ${item.complexity}')),
                        Chip(label: Text('Activity: ${item.activity}')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[700]),
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
      ),
    );
  }
}
