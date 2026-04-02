import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF5F3FF),
        fontFamily: 'Roboto',
      ),
      home: const BookListScreen(),
    );
  }
}

class BookListScreen extends StatelessWidget {
  const BookListScreen({super.key});

  final List<Map<String, String>> books = const [
    {'title': 'Harry Potter', 'author': 'J.K. Rowling', 'description': 'A young wizard story', 'pdf': 'assets/book1.pdf'},
    {'title': 'The Hobbit', 'author': 'J.R.R. Tolkien', 'description': 'Adventure of a hobbit', 'pdf': 'assets/book2.pdf'},
    {'title': 'Narnia', 'author': 'C.S. Lewis', 'description': 'Magical world', 'pdf': 'assets/book3.pdf'},
    {'title': 'Percy Jackson', 'author': 'Rick Riordan', 'description': 'Demigod adventure', 'pdf': 'assets/book4.pdf'},
    {'title': 'Hunger Games', 'author': 'Suzanne Collins', 'description': 'Dystopian battle', 'pdf': 'assets/book5.pdf'},
    {'title': 'Divergent', 'author': 'Veronica Roth', 'description': 'Future society', 'pdf': 'assets/book6.pdf'},
    {'title': 'Twilight', 'author': 'Stephenie Meyer', 'description': 'Vampire romance', 'pdf': 'assets/book7.pdf'},
    {'title': 'Alice in Wonderland', 'author': 'Lewis Carroll', 'description': 'Fantasy journey', 'pdf': 'assets/book8.pdf'},
    {'title': 'Lord of the Rings', 'author': 'J.R.R. Tolkien', 'description': 'Epic fantasy', 'pdf': 'assets/book9.pdf'},
    {'title': 'Mockingbird', 'author': 'Harper Lee', 'description': 'Justice story', 'pdf': 'assets/book10.pdf'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 My Fiction Library'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade400],
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(Icons.menu_book, size: 40, color: Colors.white),
              title: Text(
                books[index]['title']!,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                books[index]['author']!,
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetailScreen(book: books[index]),
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

class BookDetailScreen extends StatelessWidget {
  final Map<String, String> book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book['title']!)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.menu_book, size: 100, color: Colors.deepPurple),
            const SizedBox(height: 20),

            Text(
              book['title']!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              book['author']!,
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),

            const SizedBox(height: 20),

            Text(
              book['description']!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: const Color.fromARGB(255, 189, 158, 234),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReadingBookFile(
                        pdfPath: book['pdf']!,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.menu_book),
                label: const Text('Read the Book', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReadingBookFile extends StatefulWidget {
  final String pdfPath;

  const ReadingBookFile({super.key, required this.pdfPath});

  @override
  State<ReadingBookFile> createState() => _ReadingBookFileState();
}

class _ReadingBookFileState extends State<ReadingBookFile> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  Future<void> loadPdf() async {
    final data = await rootBundle.load(widget.pdfPath);
    final bytes = data.buffer.asUint8List();

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/temp.pdf");

    await file.writeAsBytes(bytes, flush: true);

    setState(() {
      localPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📖 Reading')),
      body: localPath == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(filePath: localPath!),
    );
  }
}