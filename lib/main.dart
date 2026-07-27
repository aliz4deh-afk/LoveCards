import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(const LoveCardsApp());
}

class LoveCardsApp extends StatelessWidget {
  const LoveCardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Love Cards',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      ),
      home: const ScratchGridPage(),
    );
  }
}

class ScratchGridPage extends StatefulWidget {
  const ScratchGridPage({super.key});

  @override
  State<ScratchGridPage> createState() => _ScratchGridPageState();
}

class _ScratchGridPageState extends State<ScratchGridPage> {
  final List<String> images = [
    '1.png',
    '2.png',
    '3.png',
    '4.png',
    '5.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💘 Love Cards 💘', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.pink[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Scratcher(
                  brushSize: 40,
                  threshold: 50,
                  color: Colors.pink[400]!,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.black,
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
