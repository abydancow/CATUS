import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditNotePage extends StatefulWidget {
  final String documentId;

  EditNotePage({required this.documentId});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getNoteData();
  }

  void _getNoteData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Notes')
        .doc(widget.documentId)
        .get();

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    _titleController.text = data['title'];
    _descriptionController.text = data['description'];
  }

  void _updateNote() {
    FirebaseFirestore.instance
        .collection('Notes')
        .doc(widget.documentId)
        .update({
      'title': _titleController.text,
      'description': _descriptionController.text,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Catatan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: null, 
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateNote,
              child: Text('Update Note'),
            ),
          ],
        ),
      ),
    );
  }
}
