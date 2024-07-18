import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'task_detail_page.dart';
import 'note_detail_page.dart';
import 'edit_task_page.dart';
import 'edit_note_page.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatelessWidget {
  final String nim;
  final String email;

  Home({required this.nim, required this.email});

  final Stream<QuerySnapshot> _taskStream =
      FirebaseFirestore.instance.collection('Tasks').snapshots();
  final Stream<QuerySnapshot> _noteStream =
      FirebaseFirestore.instance.collection('Notes').snapshots();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Task Organizer'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Tugas'),
              Tab(text: 'Catatan'),
              Tab(text: 'Profil'), 
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TaskTab(taskStream: _taskStream),
            NoteTab(noteStream: _noteStream),
            ProfileTab(nim: nim, email: email), 
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 150,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.task),
                        title: Text('Tambah Tugas'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/tugas');
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.note),
                        title: Text('Tambah Catatan'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/catatan');
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  final String nim;
  final String email;

  ProfileTab({required this.nim, required this.email});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Email: $nim', style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
          Text('NIM: $email', style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class TaskTab extends StatelessWidget {
  final Stream<QuerySnapshot> taskStream;

  TaskTab({required this.taskStream});

  void _deleteTask(String id) {
    FirebaseFirestore.instance.collection('Tasks').doc(id).delete();
  }

  Future<void> _shareTask(String title, String description, String deadline,
      String mataKuliah) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: '',
      query:
          'subject=Tugas: $title&body=Deskripsi: $description\nMata Kuliah: $mataKuliah\nDeadline: $deadline',
    );
    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: taskStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No tasks available'));
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic>? data =
                document.data() as Map<String, dynamic>?;

            if (data == null) {
              return SizedBox(); 
            }

            String title = data['title'] ?? 'No title';
            String description = data['description'] ?? 'No description';
            String mataKuliah = data['mata_kuliah'] ?? 'No subject';
            DateTime? deadline = (data['deadline'] as Timestamp?)?.toDate();
            String deadlineStr = deadline != null
                ? DateFormat.yMMMd().format(deadline)
                : 'No deadline';

            return Card(
              elevation: 4.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text(title),
                subtitle: Text('Deadline: $deadlineStr'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.read_more),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailPage(
                              title: title,
                              description: description,
                              mataKuliah: mataKuliah,
                              deadline: deadlineStr,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditTaskPage(documentId: document.id),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteTask(document.id);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                        _shareTask(title, description, deadlineStr, mataKuliah);
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class NoteTab extends StatelessWidget {
  final Stream<QuerySnapshot> noteStream;

  NoteTab({required this.noteStream});

  void _deleteNote(String id) {
    FirebaseFirestore.instance.collection('Notes').doc(id).delete();
  }

  Future<void> _shareNote(
      String title, String description, String createdAt) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: '',
      query:
          'subject=Catatan: $title&body=Deskripsi: $description\nDibuat pada: $createdAt',
    );
    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: noteStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No notes available'));
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic>? data =
                document.data() as Map<String, dynamic>?;

            if (data == null) {
              return SizedBox(); 
            }

            String title = data['title'] ?? 'No title';
            String description = data['description'] ?? 'No description';
            Timestamp? createdAtTimestamp = data['created_at'] as Timestamp?;
            DateTime? createdAt = createdAtTimestamp?.toDate();
            String createdAtStr = createdAt != null
                ? DateFormat.yMMMd().format(createdAt)
                : 'Unknown time';

            return Card(
              elevation: 4.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text(title),
                subtitle: Text('Created at: $createdAtStr'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.read_more),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteDetailPage(
                              title: title,
                              description: description,
                              createdAt: createdAtStr,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditNotePage(documentId: document.id),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteNote(document.id);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                        _shareNote(title, description, createdAtStr);
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
