import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../providers/auth_provider.dart';
import '../providers/book_provider.dart';
import '../providers/loan_provider.dart';
import '../models/book_model.dart';
import '../models/loan_model.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    _BerandaPage(),
    _TambahBukuPage(),
    _RiwayatPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _handleLogout(BuildContext context) async {
    final navigator = Navigator.of(context);
    await context.read<AuthProvider>().logout();
    if (mounted) {
      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Perpus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Tambah Buku',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class _BerandaPage extends StatefulWidget {
  const _BerandaPage();

  @override
  State<_BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<_BerandaPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildImageWidget(String? imageUrl) {
    if (imageUrl == null) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(
            Icons.book,
            size: 50,
            color: Colors.grey,
          ),
        ),
      );
    }

    if (kIsWeb) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Center(
              child: Icon(
                Icons.error_outline,
                size: 50,
                color: Colors.grey,
              ),
            ),
          );
        },
      );
    } else {
      return Image.file(
        File(imageUrl),
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Center(
              child: Icon(
                Icons.error_outline,
                size: 50,
                color: Colors.grey,
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        final books = _searchQuery.isEmpty
            ? bookProvider.books
            : bookProvider.searchBooks(_searchQuery);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari buku...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: books.isEmpty
                  ? Center(
                      child: Text(
                        _searchQuery.isEmpty
                            ? 'Belum ada buku yang tersedia'
                            : 'Tidak ada buku yang sesuai dengan pencarian',
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return Card(
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildImageWidget(book.imageUrl),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      book.author,
                                      style: const TextStyle(fontSize: 14),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => _showPinjamDialog(context, book),
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            minimumSize: const Size(60, 30),
                                          ),
                                          child: const Text('Pinjam'),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit, size: 20),
                                              onPressed: () => _showEditDialog(context, book),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete, size: 20),
                                              onPressed: () => _showDeleteDialog(context, book),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, BookModel book) {
    final titleController = TextEditingController(text: book.title);
    final authorController = TextEditingController(text: book.author);
    final publisherController = TextEditingController(text: book.publisher);
    final yearController = TextEditingController(text: book.year.toString());
    final categoryController = TextEditingController(text: book.category);
    final descriptionController = TextEditingController(text: book.description);
    File? imageFile = book.imageUrl != null ? File(book.imageUrl!) : null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Buku'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    imageFile = File(pickedFile.path);
                    // Perlu setState jika ingin memperbarui UI
                  }
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: imageFile != null
                      ? Image.file(imageFile!, fit: BoxFit.cover)
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 50),
                            SizedBox(height: 8),
                            Text('Tap untuk menambah foto'),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Penulis'),
              ),
              TextField(
                controller: publisherController,
                decoration: const InputDecoration(labelText: 'Penerbit'),
              ),
              TextField(
                controller: yearController,
                decoration: const InputDecoration(labelText: 'Tahun'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Kategori'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              final updatedBook = BookModel(
                id: book.id,
                title: titleController.text,
                author: authorController.text,
                publisher: publisherController.text,
                year: int.tryParse(yearController.text) ?? book.year,
                category: categoryController.text,
                description: descriptionController.text,
                imageUrl: imageFile?.path,
              );
              
              context.read<BookProvider>().updateBook(updatedBook);
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Buku berhasil diperbarui'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, BookModel book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Buku'),
        content: Text('Apakah Anda yakin ingin menghapus buku "${book.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              context.read<BookProvider>().deleteBook(book.id);
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Buku berhasil dihapus'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showPinjamDialog(BuildContext context, BookModel book) {
    if (context.read<LoanProvider>().isBookBorrowed(book.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Buku ini sedang dipinjam'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final borrowerController = TextEditingController();
    DateTime selectedDueDate = DateTime.now().add(const Duration(days: 7));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pinjam Buku'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Judul: ${book.title}'),
            Text('Penulis: ${book.author}'),
            const SizedBox(height: 16),
            TextField(
              controller: borrowerController,
              decoration: const InputDecoration(
                labelText: 'Nama Peminjam',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Tanggal Pengembalian: '),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDueDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (picked != null) {
                      selectedDueDate = picked;
                    }
                  },
                  child: Text(_formatDate(selectedDueDate)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (borrowerController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Nama peminjam harus diisi'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final loan = LoanModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                bookId: book.id,
                bookTitle: book.title,
                bookAuthor: book.author,
                borrowerName: borrowerController.text,
                loanDate: DateTime.now(),
                dueDate: selectedDueDate,
                status: 'dipinjam',
              );
              
              context.read<LoanProvider>().addLoan(loan);
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Buku berhasil dipinjam'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Pinjam'),
          ),
        ],
      ),
    );
  }
}

class _TambahBukuPage extends StatefulWidget {
  const _TambahBukuPage();

  @override
  State<_TambahBukuPage> createState() => _TambahBukuPageState();
}

class _TambahBukuPageState extends State<_TambahBukuPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _publisherController = TextEditingController();
  final _yearController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _selectedImage;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _publisherController.dispose();
    _yearController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      } else {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  void _resetForm() {
    _titleController.clear();
    _authorController.clear();
    _publisherController.clear();
    _yearController.clear();
    _categoryController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: kIsWeb
                            ? Image.network(
                                _selectedImage!.path,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.error_outline,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              )
                            : Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 50),
                          SizedBox(height: 8),
                          Text('Tap untuk menambah foto'),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Buku',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Judul buku harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(
                labelText: 'Penulis',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Penulis harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _publisherController,
              decoration: const InputDecoration(
                labelText: 'Penerbit',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Penerbit harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _yearController,
              decoration: const InputDecoration(
                labelText: 'Tahun Terbit',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tahun terbit harus diisi';
                }
                if (int.tryParse(value) == null) {
                  return 'Tahun harus berupa angka';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kategori harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Deskripsi harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newBook = BookModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: _titleController.text,
                    author: _authorController.text,
                    publisher: _publisherController.text,
                    year: int.parse(_yearController.text),
                    category: _categoryController.text,
                    description: _descriptionController.text,
                    imageUrl: _selectedImage?.path,
                  );

                  context.read<BookProvider>().addBook(newBook);
                  _resetForm();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Buku berhasil ditambahkan'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Simpan Buku'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiwayatPage extends StatelessWidget {
  const _RiwayatPage();

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProvider>(
      builder: (context, loanProvider, child) {
        final loans = loanProvider.loans;
        
        if (loans.isEmpty) {
          return const Center(
            child: Text('Belum ada riwayat peminjaman'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: loans.length,
          itemBuilder: (context, index) {
            final loan = loans[index];
            final bool isActive = loan.status == 'dipinjam';
            
            return Card(
              elevation: 2,
              child: ListTile(
                title: Text(loan.bookTitle),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Penulis: ${loan.bookAuthor}'),
                    Text('Peminjam: ${loan.borrowerName}'),
                    Text('Tanggal Pinjam: ${_formatDate(loan.loanDate)}'),
                    Text('Jatuh Tempo: ${_formatDate(loan.dueDate)}'),
                    if (loan.returnDate != null)
                      Text('Dikembalikan: ${_formatDate(loan.returnDate!)}'),
                  ],
                ),
                trailing: isActive
                    ? ElevatedButton(
                        onPressed: () {
                          loanProvider.returnBook(loan.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Buku berhasil dikembalikan'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: const Text('Kembalikan'),
                      )
                    : Chip(
                        label: const Text('Dikembalikan'),
                        backgroundColor: Colors.green[100],
                      ),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }
} 