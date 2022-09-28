import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:grow_me_app/app.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';

const storageKey = "known-devices";

class LinkedDevice {
  BluetoothDevice? device;
  KnownDevice description;
  BluetoothDeviceState _status = BluetoothDeviceState.disconnected;

  bool get isConnected {
    return device != null && _status == BluetoothDeviceState.connected;
  }

  LinkedDevice(this.description, this.device) {
    if (device != null) {
      device!.state.listen((event) {
        _status = event;
      });
    }
  }
}

class DeviceModel extends ChangeNotifier {
  List<LinkedDevice> _devices = [];

  UnmodifiableListView<LinkedDevice> get devices =>
      UnmodifiableListView(_devices);

  DeviceModel() {
    // try reloading state
    _loadState();
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
    var idx =
        _devices.indexWhere((element) => element.device?.id.toString() == id);
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

  void _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceData = prefs.getString(storageKey);
    if (deviceData != null) {
      var state = KnownDevicesState.fromJson(jsonDecode(deviceData));
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
