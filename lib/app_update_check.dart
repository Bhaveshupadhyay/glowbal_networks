import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AppUpdateCheck{
  // Check for updates based on version from the store
  Future<void> checkForUpdate(BuildContext context) async {
    // Get the current app version
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;


    // Platform-specific update check
    if (Platform.isAndroid) {
      _checkAndroidUpdate(currentVersion: currentVersion,context: context);
    } else if (Platform.isIOS) {
      _checkIOSUpdate(currentVersion: currentVersion,context: context);
    }
  }

  // For Android: Check for app update via the Play Store
  Future<void> _checkAndroidUpdate({required String currentVersion,required BuildContext context}) async {
    try {
      InAppUpdate.checkForUpdate().then((info) {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          // Prompt user to update
          _showUpdateDialog(context);
        }
      });
    } catch (e) {
      print('Error checking Android update: $e');
    }
  }

  // For iOS: Check the app version from the App Store API
  Future<void> _checkIOSUpdate({required String currentVersion,required BuildContext context}) async {
    try {
      final response = await http.get(Uri.parse('https://itunes.apple.com/lookup?bundleId=co.uk.glowbalnetwork'));
      final data = json.decode(response.body);
      if (data['resultCount'] > 0) {
        String appStoreVersion = data['results'][0]['version'];
        if (currentVersion != appStoreVersion) {
          _showUpdateDialog(context);
        }
      }
    } catch (e) {
      print('Error checking iOS update: $e');
    }
  }

  // Display a dialog prompting the user to update the app
  void _showUpdateDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Update Available'),
        content: Text(
          'A new version of the app is available. Please update to continue using the latest features and improvements.',
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
              // Redirect to App Store (iOS) or Play Store (Android)
              _redirectToStore(context);
            },
            isDefaultAction: true,
            child: Text('Update'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without updating
            },
            isDestructiveAction: true,
            child: Text('Later'),
          ),
        ],
      ),
    );
  }

  // Redirect the user to the respective store
  void _redirectToStore(BuildContext context) async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      InAppUpdate.performImmediateUpdate();
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      // Open the App Store
      const url = 'https://apps.apple.com/app/6737516777';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    }
  }
}