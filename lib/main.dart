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
      theme: ThemeData(useMaterial3: true),
      home: const BookListScreen(),
    );
  }
}

class BookListScreen extends StatelessWidget {
  const BookListScreen({super.key});

  final List<Map<String, String>> books = const [
    {'title': 'Harry Potter', 'author': 'J.K. Rowling', 'description': 'Wizard story', 'pdf': 'assets/book1.pdf', 'image': 'assets/cover1.jpg'},
    {'title': 'The Hobbit', 'author': 'Tolkien', 'description': 'Adventure', 'pdf': 'assets/book2.pdf', 'image': 'assets/cover2.jpg'},
    {'title': 'Narnia', 'author': 'C.S Lewis', 'description': 'Fantasy', 'pdf': 'assets/book3.pdf', 'image': 'assets/cover3.jpg'},
    {'title': 'Percy Jackson', 'author': 'Rick', 'description': 'Demigod', 'pdf': 'assets/book4.pdf', 'image': 'assets/cover4.jpg'},
    {'title': 'Hunger Games', 'author': 'Collins', 'description': 'Battle', 'pdf': 'assets/book5.pdf', 'image': 'assets/cover5.jpg'},
    {'title': 'Divergent', 'author': 'Roth', 'description': 'Future', 'pdf': 'assets/book6.pdf', 'image': 'assets/cover6.jpg'},
    {'title': 'Twilight', 'author': 'Meyer', 'description': 'Vampire', 'pdf': 'assets/book7.pdf', 'image': 'assets/cover7.jpg'},
    {'title': 'Alice', 'author': 'Carroll', 'description': 'Fantasy', 'pdf': 'assets/book8.pdf', 'image': 'assets/cover8.jpg'},
    {'title': 'LOTR', 'author': 'Tolkien', 'description': 'Epic', 'pdf': 'assets/book9.pdf', 'image': 'assets/cover9.jpg'},
    {'title': 'Mockingbird', 'author': 'Lee', 'description': 'Justice', 'pdf': 'assets/book10.pdf', 'image': 'assets/cover10.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFE4EC), Color(0xFFEDE9FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Fiction Library💕",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const Text(
                "Choose your book 📚",
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: books.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.65, // Mengatur rasio agar cukup untuk teks di bawah
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailScreen(book: books[index]),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // GAMBAR: Menggunakan Expanded agar mengisi ruang atas secara fleksibel
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                child: Image.asset(
                                  books[index]['image']!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            
                            // JUDUL DAN PENULIS: Di bagian bawah gambar
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    books[index]['title']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    books[index]['author']!,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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
      backgroundColor: const Color(0xFFFFF0F6),
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                book['image']!,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SafeArea(
                child: IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Colors.black26,
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book['title']!,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "by ${book['author']}",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    book['description']!,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9EDC),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReadingBookFile(pdfPath: book['pdf']!),
                          ),
                        );
                      },
                      child: const Text("Read the Book 💕", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
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
    try {
      final data = await rootBundle.load(widget.pdfPath);
      final bytes = data.buffer.asUint8List();
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/temp.pdf");
      await file.writeAsBytes(bytes, flush: true);
      setState(() => localPath = file.path);
    } catch (e) {
      debugPrint("Error loading PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📖 Reading'),
        backgroundColor: const Color(0xFFD8B4FE),
      ),
      body: localPath == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(filePath: localPath!),
    );
  }
}