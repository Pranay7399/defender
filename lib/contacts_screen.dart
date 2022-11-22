import 'package:contacts_service/contacts_service.dart';
import 'package:defender/helpers.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> phoneContacts = [];

  @override
  void initState() {
    _checkForPermissions();
    super.initState();
  }

  Future<void> _checkForPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      print('Permission granted. Now getting contacts');
      await getContacts();
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      showSnackBar(
          title: 'Access to contact data denied',
          context: context,
          type: SnackType.info);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      showSnackBar(
          title: 'Contact data not available on device',
          context: context,
          type: SnackType.error);
    }
  }

  Future<void> getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      phoneContacts = contacts.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
        ),
        body: phoneContacts.isEmpty
            ? const Center(
                child: Text('Fetching contacts... Please wait'),
              )
            : ListView.builder(
                itemCount: phoneContacts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        phoneContacts[index].displayName?[0].toString() ?? 'A',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    title: isValidContact(phoneContacts[index])
                        ? Text(phoneContacts[index].displayName ?? '')
                        : const Text(
                            'Invalid Contact',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                    subtitle: isValidContact(phoneContacts[index])
                        ? Text(
                            (phoneContacts[index].phones?.isNotEmpty ?? false)
                                ? phoneContacts[index].phones?.first.value ?? ''
                                : 'No contact number')
                        : const SizedBox(),
                  );
                },
              ));
  }

  bool isValidContact(Contact phoneContact) {
    //is valid contact
    bool val = phoneContact.displayName != null &&
        phoneContact.displayName!.isNotEmpty &&
        phoneContact.phones != null &&
        phoneContact.phones!.isNotEmpty &&
        phoneContact.phones!.first.value != null;
    //check phone number is 10 digits and having country code
    if (val) {
      val = phoneContact.phones!.first.value!.length <= 13;
    }
    return val;
  }
}
