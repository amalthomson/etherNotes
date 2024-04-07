import 'package:flutter/material.dart';
import 'package:etherNotes/note.dart';
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
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text(
          'etherNotes',
          style: TextStyle(
            fontFamily: 'Pacifico',
            color: Colors.white,
            fontSize: 36,
          ),
        ),
        backgroundColor: Colors.black,
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
                child: Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.deepPurple[50],
                    child: ListTile(
                      title: Text(
                        notesServices.notes[index].title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[900],
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
                          notesServices.deleteNote(
                              notesServices.notes[index].id);
                        },
                      ),
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
          backgroundColor: Colors.deepPurpleAccent,
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    'New Note',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        style: TextStyle(color: Colors.deepPurple[900]),
                        decoration: const InputDecoration(
                          hintText: 'Enter title',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: descriptionController,
                        style: TextStyle(color: Colors.deepPurple[900]),
                        decoration: const InputDecoration(
                          hintText: 'Enter description',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  actions: [
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
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showNoteDetails(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  note.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.deepPurple[900],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  note.description,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.deepPurple[900],
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
