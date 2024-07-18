import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTaskPage extends StatefulWidget {
  final String documentId;

  EditTaskPage({required this.documentId});

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _mataKuliahController = TextEditingController();
  DateTime? _selectedDeadline;

  @override
  void initState() {
    super.initState();
    _getTaskData();
  }

  void _getTaskData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Tasks')
        .doc(widget.documentId)
        .get();

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    _titleController.text = data['title'];
    _descriptionController.text = data['description'];
    _mataKuliahController.text = data['mata_kuliah'];
    _selectedDeadline = (data['deadline'] as Timestamp).toDate();
  }

  void _updateTask() {
    FirebaseFirestore.instance
        .collection('Tasks')
        .doc(widget.documentId)
        .update({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'mata_kuliah': _mataKuliahController.text,
      'deadline': Timestamp.fromDate(_selectedDeadline!),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Tugas'),
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
              maxLines: null, // Allow multiple lines
              keyboardType: TextInputType.multiline,
            ),
            TextField(
              controller: _mataKuliahController,
              decoration: InputDecoration(labelText: 'Mata Kuliah'),
            ),
            SizedBox(height: 20),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: _selectedDeadline == null
                    ? 'Deadline'
                    : 'Deadline: ${_selectedDeadline!.toLocal()}'.split(' ')[0],
              ),
              onTap: () {

              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTask,
              child: Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
