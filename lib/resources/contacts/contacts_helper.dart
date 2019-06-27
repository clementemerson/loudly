import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:loudly/resources/services/permissions_manager.dart';

class PhoneContacts {
  final String displayName;
  final String phoneNumber;
  final String identifier;

  PhoneContacts({this.displayName, this.phoneNumber, this.identifier});
}

class ContactsHelper {
  static List<PhoneContacts> phoneContacts;
  static DateTime lastSynchedTime;

  static Future<List<PhoneContacts>> getPhoneContacts() async {
    try {
      bool hasPermission = await PermissionManager.checkPermission(
          permissionGroup: PermissionGroup.contacts);
      if (hasPermission == true) {
        Iterable<Contact> contacts = await ContactsService.getContacts();
        for (var contact in contacts) {
          for (var phone in contact.phones) {
            phoneContacts.add(PhoneContacts(
                displayName: contact.displayName,
                phoneNumber: phone.value,
                identifier: contact.identifier));
          }
        }
        lastSynchedTime = DateTime.now();
      } else {
        throw Exception('Failed to get contacts from phone');
      }
    } catch (Exception) {
      throw Exception('Failed to get contacts from phone');
    }
    return phoneContacts;
  }
}
