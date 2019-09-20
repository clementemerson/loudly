import 'package:loudly/project_textconstants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:loudly/resources/services/permissions_manager.dart';
import 'package:phone_number/phone_number.dart';

class PhoneContact {
  final String displayName;
  final String phoneNumber;
  final String identifier;

  PhoneContact({this.displayName, this.phoneNumber, this.identifier});
}

class ContactsHelper {
  static Map<String, PhoneContact> phoneContacts = Map<String, PhoneContact>();
  static DateTime lastSynchedTime;

  static Future<Map<String, PhoneContact>> getPhoneContacts() async {
    try {
      bool hasPermission = await PermissionManager.requestPermission(
          permissionGroup: PermissionGroup.contacts);
      if (hasPermission == true) {
        await _getPhoneContactsHelper();
      } else {
        throw Exception(failedGetContactsFromPhone);
      }
    } catch (Exception) {
      throw Exception(failedGetContactsFromPhone);
    }
    return phoneContacts;
  }

  static Future<Map<String, PhoneContact>> updatePhoneContacts() async {
    try {
      bool hasPermission = await PermissionManager.checkPermission(
          permissionGroup: PermissionGroup.contacts);
      if (hasPermission == true) {
        await _getPhoneContactsHelper();
      } else {
        throw Exception(failedGetContactsFromPhone);
      }
    } catch (Exception) {
      throw Exception(failedGetContactsFromPhone);
    }
    return phoneContacts;
  }

  static String getUserNameInPhone(String phoneNumber) {
    PhoneContact contact = phoneContacts[phoneNumber];
    if (contact != null) {
      return contact.displayName;
    }
    return null;
  }

  static Future<Map<String, PhoneContact>> _getPhoneContactsHelper() async {
    assert(await PermissionManager.checkPermission(
        permissionGroup: PermissionGroup.contacts));
    try {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      for (var contact in contacts) {
        for (var phone in contact.phones) {
          print(phone);
          String phoneNumber;
          try {
            dynamic phoneParsed =
                await PhoneNumber.parse(phone.value.toString(), region: 'IN');
            phoneNumber = phoneParsed['e164'].toString();
          } catch (Exception) {}
          if (phoneNumber != null)
            phoneContacts[phoneNumber] = PhoneContact(
                displayName: contact.displayName,
                phoneNumber: phoneNumber,
                identifier: contact.identifier);
        }
      }
    } catch (Exception) {
      throw Exception(failedGetContactsFromPhone);
    }

    return phoneContacts;
  }
}
