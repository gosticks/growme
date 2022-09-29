import 'dart:developer';

import 'package:grow_me_app/app.pb.dart';
import 'package:grow_me_app/components/bottom_sheet.dart';
import 'package:grow_me_app/components/button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:grow_me_app/components/device_debug.dart';
import 'package:grow_me_app/components/device_model.dart';
import 'package:grow_me_app/components/edit_device.dart';
import 'package:provider/provider.dart';

class DeviceActionSheet extends StatelessWidget {
  final LinkedDevice device;
  final DeviceModel model;

  const DeviceActionSheet(
      {super.key, required this.device, required this.model});

  @override
  Widget build(BuildContext context) {
    return Button(
      "Configure",
      () {
        showCustomModalBottomSheet(
            context,
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                    title: const Text("Rename"),
                    leading: const Icon(Icons.edit),
                    onTap: () {
                      Navigator.pop(context);
                      showEditDeviceModal(context, device);
                    }),
                ListTile(
                    title: const Text("Debug"),
                    leading: const Icon(Icons.bug_report),
                    onTap: () {
                      Navigator.pop(context);
                      showDeviceDebugView(context, device);
                    }),
                ListTile(
                    title: const Text("Remove"),
                    leading: const Icon(Icons.delete),
                    onTap: () {
                      model.removeById(device.description.remoteId);
                      Navigator.pop(context);
                    }),
              ],
            ));
      },
    );
  }
}
