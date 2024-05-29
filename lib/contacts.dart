import 'dart:math';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  bool isLoading = true;
  @override
  void initState() {
    getPermission();
    super.initState();
  }

  void getPermission() async {
    if (await Permission.contacts.isGranted) {
      fetchContact();
    } else {
      await Permission.contacts.request();
    }
  }

  void fetchContact() async {
    contacts = await ContactsService.getContacts();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${contacts[index].displayName}'),
                  subtitle: Text(
                      '${contacts[index].phones!.first.value!.replaceAll(' ', '').replaceAll('-', '')} \n ${contacts[index].emails!.isNotEmpty ? contacts[index].emails!.first.value : ''}'),
                  leading: Icon(
                    Icons.person,
                    color: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)],
                  ),
                );
              },
            ),
    );
  }
}
