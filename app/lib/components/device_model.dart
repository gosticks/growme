import 'dart:developer';

import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:grow_me_app/app.pb.dart';
import 'package:grow_me_app/components/connection_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

const storageKey = "known-devices";

class LinkedDevice {
  BluetoothDevice? _device;
  KnownDevice description;
  BluetoothDeviceState _status = BluetoothDeviceState.disconnected;

  BluetoothDeviceState get status {
    return _status;
  }

  BluetoothDevice? get device {
    return _device;
  }

  void set device(BluetoothDevice? newDevice) {
    // NOTE: what should be done if device already set?
    if (newDevice != null) {
      newDevice.state.listen((event) {
        _status = event;
      });
      _device = newDevice;
    } else {
      _device = null;
    }
  }

  bool get isConnected {
    return device != null && _status == BluetoothDeviceState.connected;
  }

  LinkedDevice(this.description, BluetoothDevice? device) {
    this.device = device;
  }
}

class DeviceModel extends ChangeNotifier {
  List<LinkedDevice> _devices = [];
  Stream<List<ScanResult>>? _scanStream = null;

  UnmodifiableListView<LinkedDevice> get devices =>
      UnmodifiableListView(_devices);

  DeviceModel() {
    // try reloading state
    _loadState();

    _scanForKnownDevices();
  }

  void add(LinkedDevice device) {
    _devices.add(device);
    notifyListeners();

    _saveState();
  }

  LinkedDevice addFromDevice(BluetoothDevice device) {
    var linkedDevice = LinkedDevice(
      KnownDevice(
          name: "Untitled",
          remoteId: device.id.toString(),
          remoteName: device.name),
      device,
    );

    add(linkedDevice);

    return linkedDevice;
  }

  void remove(LinkedDevice device) {
    _devices.remove(device);
    notifyListeners();

    _saveState();
  }

  void removeById(String id) {
    var idx = _devices
        .indexWhere((element) => element.description.remoteId.toString() == id);
    if (idx == -1) {
      return;
    }
    _devices.removeAt(idx);
    notifyListeners();

    _saveState();
  }

  void updateEntry(String id, KnownDevice description) {
    var idx =
        _devices.indexWhere((element) => element.device?.id.toString() == id);
    if (idx == -1) {
      return;
    }

    // potential trouble if done without thread safety
    _devices[idx].description = description;
    notifyListeners();

    _saveState();
  }

  void _scanForKnownDevices() async {
    // try reconnecting devices
    FlutterBlue flutterBlue = FlutterBlue.instance;

    List<String> connectingIds = [];

    // Listen to scan results
    flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        if (r.advertisementData.serviceUuids.contains(bleServiceName)) {
          log("found plant device  ${r.device.id}");
          // search for known devices
          _devices.forEach((kd) {
            // we found a known device try connecting to it
            if (kd.description.remoteId == r.device.id.toString() &&
                !connectingIds.contains(kd.description.remoteId)) {
              connectingIds.add(kd.description.remoteId);

              log("found previously connected device");
              kd.device = r.device;
              kd.device!.connect().then((value) {
                log("connected: notifying subscribers");
                notifyListeners();
              });
            }
          });
        }
      }
    });

    // Start scanning
    try {
      await flutterBlue.startScan(timeout: const Duration(seconds: 10));

      notifyListeners();
    } catch (e) {
      log("failed to start scan");
      return;
    }
  }

  void _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceData = prefs.getString(storageKey);
    if (deviceData != null) {
      var state = KnownDevicesState.create();
      state.mergeFromProto3Json(jsonDecode(deviceData));
      _devices = state.devices.map((d) => LinkedDevice(d, null)).toList();
      notifyListeners();
    }
  }

  void _saveState() async {
    final prefs = await SharedPreferences.getInstance();

    // encode current devices
    var state = KnownDevicesState(devices: devices.map((d) => d.description));
    prefs.setString(storageKey, jsonEncode(state.toProto3Json()));
  }
}
