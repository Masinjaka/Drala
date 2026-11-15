import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationPermissionService {
  NotificationPermissionService({FirebaseMessaging? messaging})
      : _providedMessaging = messaging;

  final FirebaseMessaging? _providedMessaging;
  FirebaseMessaging get _messaging =>
      _providedMessaging ?? FirebaseMessaging.instance;

  Future<bool> isGranted() async {
    if (!kReleaseMode) return false;
    final settings = await _messaging.getNotificationSettings();
    return isGrantedStatus(settings.authorizationStatus);
  }

  Future<bool> request() async {
    if (!kReleaseMode) return false;
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    return isGrantedStatus(settings.authorizationStatus);
  }

  static bool isGrantedStatus(AuthorizationStatus status) {
    return status == AuthorizationStatus.authorized ||
        status == AuthorizationStatus.provisional;
  }
}
