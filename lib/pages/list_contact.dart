import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobcontact/database/db_helper.dart';
import 'package:mobcontact/models/contact_model.dart';
import 'package:mobcontact/pages/form_contact.dart';

class ListContact extends StatefulWidget {
  const ListContact({Key? key}) : super(key: key);

  @override
  State<ListContact> createState() => _ListContactState();
}

class _ListContactState extends State<ListContact> {
  final List<Contact> listContact = [];
  final DbHelper dbHelper = DbHelper();
  final List<Contact> sampleData = [
    Contact(
      id: 1,
      name: 'Abdul Ghozali',
      mobileNo: '081234567890',
      email: 'gho@gmail.com',
      company: 'PT ABC',
    ),
    Contact(
      id: 2,
      name: 'Fajar Sidik Prasetio',
      mobileNo: '08765432123',
      email: 'bel@gmail.com',
      company: 'PT DEF',
    ),
  ];

  Future<List<Contact>> getAllContact() async {
    listContact.clear();
    await dbHelper.getListContact().then((value) {
      for (var json in (value as List)) {
        listContact.add(Contact.fromJson(json));
      }
    });

    return listContact;
  }

  @override
  void initState() {
    getAllContact().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("List Contacts")),
        body: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return ListView.builder(
                itemCount: listContact.length,
                itemBuilder: (context, index) {
                  Contact contact = listContact[index];
                  return ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.amber,
                        foregroundImage: FileImage(File(contact.photo!)),
                      ),
                      title: Text("${contact.name}"),
                      subtitle: Text("${contact.email}, ${contact.mobileNo}"),
                      trailing: FittedBox(
                          fit: BoxFit.fill,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    await dbHelper.delete(contact.id!).then(
                                        (value) =>
                                            getAllContact().then((value) {
                                              setState(() {});
                                            }));
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          )));
                });
          },
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton(
              heroTag: 'add contact',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FormContact(Contact());
                }));
              },
              child: const Icon(Icons.add),
            ),
            FloatingActionButton(
              onPressed: () async {
                getAllContact().then((value) {
                  setState(() {});
                });
              },
              child: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }
}
