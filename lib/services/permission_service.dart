import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> checkMicrophonePermission() async {
    final status = await Permission.microphone.status;
    return status == PermissionStatus.granted;
  }

  static Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;
    return status == PermissionStatus.granted;
  }

  static Future<Map<String, bool>> requestCallPermissions({bool needCamera = false}) async {
    final Map<Permission, PermissionStatus> permissions = await [
      Permission.microphone,
      if (needCamera) Permission.camera,
    ].request();

    return {
      'microphone': permissions[Permission.microphone] == PermissionStatus.granted,
      if (needCamera) 'camera': permissions[Permission.camera] == PermissionStatus.granted,
    };
  }

  static Future<bool> openAppSettings() async {
    return await openAppSettings();
  }
}