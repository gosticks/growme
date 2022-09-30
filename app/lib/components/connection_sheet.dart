import 'dart:developer';

import 'package:grow_me_app/app.pb.dart';
import 'package:grow_me_app/colors.dart';
import 'package:grow_me_app/components/bottom_sheet.dart';
import 'package:grow_me_app/components/button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:grow_me_app/components/device_model.dart';
import 'package:grow_me_app/components/edit_device.dart';
import 'package:provider/provider.dart';

const bleServiceName = "4FAFC201-1FB5-459E-8FCC-C5C9C331914B";
const searchDuration = Duration(seconds: 20);

class ConnectionSheet extends StatefulWidget {
  const ConnectionSheet({super.key});

  @override
  ConnectionSheetState createState() => ConnectionSheetState();
}

class ConnectionSheetState extends State<ConnectionSheet> {
  bool isScanning = false;
  List<BluetoothDevice> candidates = [];
  BluetoothDevice? currentlyConnectingDevice;

  Future _scan() async {
    if (isScanning) {
      return;
    }

    isScanning = true;
    FlutterBlue flutterBlue = FlutterBlue.instance;

    // Start scanning
    // Listen to scan results
    flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        if (r.advertisementData.serviceUuids.contains(bleServiceName)) {
          log("found device with known service type");
          if (candidates.indexWhere((d) => d.id == r.device.id) != -1) {
            continue;
          }

          setState(() {
            candidates = [r.device, ...candidates];
          });
        }

        // TODO: forget devices that did not appear after multiple scans
      }
    });

    try {
      var resp = flutterBlue.startScan(timeout: searchDuration);

      await resp;

      // Stop scanning
      flutterBlue.stopScan();

      isScanning = false;
    } catch (e) {
      log("failed to start scan");
      isScanning = false;
      return;
    }

    isScanning = false;
  }

  Widget _scanningProgress() {
    if (!isScanning) {
      return const Scaffold();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        const Icon(Icons.bluetooth, size: 50, color: green),
        const SizedBox(height: 10),
        const Text(
          "scanning for nearby devices",
          textScaleFactor: 2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 50),
        const LinearProgressIndicator(
          value: null,
        ),
      ].toList(),
    );
  }

  Future<bool> _onConnectDevice(
      DeviceModel model, BluetoothDevice device) async {
    if (currentlyConnectingDevice != null) {
      return false;
    }

    var resp = device
        .connect()
        .then((value) {
          Navigator.pop(context);
          // remove devive after successfull connection.
          setState(() {
            candidates.remove(device);
          });

          var linkedDevice = model.addFromDevice(device);

          showEditDeviceModal(context, linkedDevice);
          return true;
        })
        .catchError((err) => false)
        .whenComplete(() => setState(() {
              currentlyConnectingDevice = null;
            }));
    setState(() {
      currentlyConnectingDevice = device;
    });

    return resp;
  }

  List<Widget> _availableDeviceList(DeviceModel model) {
    if (candidates.isEmpty) {
      return [const ListTile(title: Text('No devices found yet'))].toList();
    }

    return candidates.map((device) {
      return ListTile(
          title: Text(device.name),
          subtitle: Text(device.id.toString()),
          enabled: device.id != currentlyConnectingDevice?.id,
          onTap: () {
            _onConnectDevice(model, device);
          });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceModel>(
        builder: (context, model, child) => Button(
              "Add Product",
              () {
                // start scanning for nearby devices
                _scan();

                showCustomModalBottomSheet(
                    context,
                    Flex(
                      direction: Axis.vertical,
                      children: <Widget>[
                        _scanningProgress(),
                        ..._availableDeviceList(model),
                        const SizedBox(height: 50),
                        // const Spacer(),
                        Button("Cancel", () {
                          Navigator.pop(context);
                        })
                      ],
                    ));
              },
            ));
  }
}
