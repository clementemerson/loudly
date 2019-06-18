//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <contacts_service/ContactsServicePlugin.h>
#import <flutter_secure_storage/FlutterSecureStoragePlugin.h>
#import <permission_handler/PermissionHandlerPlugin.h>
#import <phone_number/PhoneNumberPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [ContactsServicePlugin registerWithRegistrar:[registry registrarForPlugin:@"ContactsServicePlugin"]];
  [FlutterSecureStoragePlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterSecureStoragePlugin"]];
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
  [PhoneNumberPlugin registerWithRegistrar:[registry registrarForPlugin:@"PhoneNumberPlugin"]];
}

@end
