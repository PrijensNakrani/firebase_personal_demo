import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatelessWidget {
  final _noteTitle = TextEditingController();
  final _noteContent = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MY NOTES"),
      ),
      drawer: Drawer(
        child: Image.network(""),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Notes")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> notes = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(notes[index].get('noteTitle')),
                  subtitle: Text(notes[index].get('noteContent')),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Column(
                                  children: [
                                    const Text("UPDATE NOTES"),
                                    TextFormField(
                                      controller: _noteTitle,
                                      decoration: const InputDecoration(
                                          hintText: "Note Title"),
                                    ),
                                    TextFormField(
                                      controller: _noteContent,
                                      decoration: const InputDecoration(
                                          hintText: "Note Content"),
                                    ),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel")),
                                  ElevatedButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .collection("Notes")
                                            .doc(notes[index].id)
                                            .update({
                                          "noteTitle": _noteTitle.text,
                                          "noteContent": _noteContent.text,
                                        });
                                        Navigator.pop(context);
                                        _noteTitle.clear();
                                        _noteContent.clear();
                                      },
                                      child: const Text("Update")),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Column(
                                  children: const [
                                    Text("Do you want to delete this note?"),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel")),
                                  ElevatedButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .collection("Notes")
                                            .doc(notes[index].id)
                                            .delete();
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Delete")),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Column(
                  children: [
                    const Text("ADD NOTES"),
                    TextFormField(
                      controller: _noteTitle,
                      decoration: const InputDecoration(hintText: "Note Title"),
                    ),
                    TextFormField(
                      controller: _noteContent,
                      decoration:
                          const InputDecoration(hintText: "Note Content"),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("Notes")
                          .add({
                        "noteTitle": _noteTitle.text,
                        "noteContent": _noteContent.text,
                      });
                      Navigator.pop(context);
                      _noteTitle.clear();
                      _noteContent.clear();
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
