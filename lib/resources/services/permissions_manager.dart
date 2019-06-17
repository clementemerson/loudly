import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<bool> checkPermission(
      {@required PermissionGroup permissionGroup}) async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(permissionGroup);
    if (permission != PermissionStatus.denied &&
        permission != PermissionStatus.disabled &&
        permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([permissionGroup]);
      if (permissions[permissionGroup] == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
}
