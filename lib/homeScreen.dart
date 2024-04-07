import 'package:etherNotes/note.dart';
import 'package:flutter/material.dart';
import 'package:etherNotes/web3client.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isFabVisible = true;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var notesServices = context.watch<NotesServices>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'etherNotes',
          style: TextStyle(
            fontFamily: 'Pacifico',
            color: Colors.white,
            fontSize: 36,
          ),
        ),
        backgroundColor: Colors.blueGrey[900],
        elevation: 0,
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: notesServices.isLoading
            ? Center(
          child: CircularProgressIndicator(
            color: Colors.deepPurpleAccent,
          ),
        )
            : notesServices.notes.isEmpty
            ? Center(
          child: Text(
            'No notes available',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
            ),
          ),
        )
            : RefreshIndicator(
          onRefresh: () async {
            await notesServices.fetchNotes();
          },
          child: ListView.builder(
            itemCount: notesServices.notes.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _showNoteDetails(
                      context, notesServices.notes[index]);
                },
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  child: ListTile(
                    title: Text(
                      notesServices.notes[index].title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      notesServices.notes[index].description,
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _showDeleteDialog(
                            context, notesServices, index);
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: isFabVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            _showAddDialog(context, notesServices);
          },
        ),
      ),
    );
  }

  void _showNoteDetails(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            note.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                note.description,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _showEditDialog(context, note);
              },
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Note note) {
    titleController.text = note.title;
    descriptionController.text = note.description;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Edit Note',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter title',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Enter description',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Update note logic goes here
                Navigator.pop(context);
              },
              child: const Text(
                'Update',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddDialog(BuildContext context, NotesServices notesServices) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'New Note',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter title',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Enter description',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                notesServices.addNote(
                  titleController.text,
                  descriptionController.text,
                );
                Navigator.pop(context);
              },
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(
      BuildContext context, NotesServices notesServices, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Note',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to delete this note?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                notesServices.deleteNote(
                  notesServices.notes[index].id,
                );
                Navigator.pop(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
