package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import flutter.plugins.contactsservice.contactsservice.ContactsServicePlugin;
import com.it_nomads.fluttersecurestorage.FlutterSecureStoragePlugin;
import com.baseflow.permissionhandler.PermissionHandlerPlugin;
import com.julienvignali.phone_number.PhoneNumberPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    ContactsServicePlugin.registerWith(registry.registrarFor("flutter.plugins.contactsservice.contactsservice.ContactsServicePlugin"));
    FlutterSecureStoragePlugin.registerWith(registry.registrarFor("com.it_nomads.fluttersecurestorage.FlutterSecureStoragePlugin"));
    PermissionHandlerPlugin.registerWith(registry.registrarFor("com.baseflow.permissionhandler.PermissionHandlerPlugin"));
    PhoneNumberPlugin.registerWith(registry.registrarFor("com.julienvignali.phone_number.PhoneNumberPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
