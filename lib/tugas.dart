import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Tugas extends StatefulWidget {
  @override
  _TugasState createState() => _TugasState();
}

class _TugasState extends State<Tugas> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _mataKuliahController = TextEditingController();
  DateTime? _selectedDeadline;

  void _selectDeadline(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDeadline) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  void _addTask() {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _mataKuliahController.text.isEmpty ||
        _selectedDeadline == null) {
      // Tambahkan pesan error atau notifikasi di sini
      return;
    }

    FirebaseFirestore.instance.collection('Tasks').add({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'deadline': Timestamp.fromDate(_selectedDeadline!),
      'mata_kuliah': _mataKuliahController.text,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Tugas'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Soal'),
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
              onTap: () => _selectDeadline(context),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addTask,
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
