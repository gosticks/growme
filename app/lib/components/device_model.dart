import 'dart:developer';

import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:grow_me_app/app.pb.dart';
import 'package:grow_me_app/components/connection_sheet.dart';
import 'package:grow_me_app/message.pbserver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

const storageKey = "known-devices";

const Map<String, String> deviceCharacteristics = {
  "M1": "68023a4e-e253-46e4-a439-f716b3702ae1",
  "M2": "a9102165-7b40-4cce-9008-f4af28b5ac5e",
  "M3": "4e9cad83-71d8-40c1-8876-53c1cd5fe27e",
  "M4": "e0b49f4b-d7b0-4336-8562-41a16e16e8e6",
  "M5": "5f01e609-182f-45fe-aa23-45c12b82e2df",
  "M6": "09da8768-b6ba-4b4e-b91f-65d624581d48",
  "info": "9c05490f-cc74-4fd2-8d16-fb228e3f2270"
};

class LinkedDevice {
  BluetoothDevice? _device;
  MotorStatus? _motorStatus;
  KnownDevice description;
  BluetoothDeviceState _status = BluetoothDeviceState.disconnected;

  MotorStatus? get motorStatus {
    return _motorStatus;
  }

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

  Future<BluetoothCharacteristic?> _getCharacteristic(String uuid) async {
    if (_device == null) {
      return null;
    }

    try {
      var services = await _device!.discoverServices();

      BluetoothService service = services.firstWhere(
          (element) => element.uuid.toString() == bleServiceName.toLowerCase());
      if (service == null) {
        log("device does not offer motor control service",
            name: "device.debug");
      }

      // find selected characteristic
      return service.characteristics
          .firstWhereOrNull((ch) => ch.uuid.toString() == uuid.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  Future<bool> fetchStatusUpdate() async {
    var ch = await _getCharacteristic(deviceCharacteristics["info"]!);
    if (ch == null) {
      return false;
    }

    var resp = await ch.read();
    try {
      var status = MotorStatus.fromBuffer(resp);
      _motorStatus = status;
      return true;
    } catch (e) {
      log("failed to fetch new machine status $e");
      return false;
    }
  }

  Future<bool> moveMotor(int motorIndex, int offset) async {
    var ch =
        await _getCharacteristic(deviceCharacteristics["M${motorIndex + 1}"]!);
    if (ch == null) {
      return false;
    }

    var cmd = Command(move: MoveMotorCommand(target: offset));

    await ch.write(cmd.writeToBuffer(), withoutResponse: false);
    await ch.setNotifyValue(true);

    return true;
  }

  Future<bool> resetMotorPosition(int motorIndex) async {
    var ch =
        await _getCharacteristic(deviceCharacteristics["M${motorIndex + 1}"]!);
    if (ch == null) {
      return false;
    }

    var cmd = Command(reset: ResetMotorPositionCommand());

    await ch.write(cmd.writeToBuffer(), withoutResponse: false);
    await ch.setNotifyValue(true);

    return true;
  }
}

class DeviceModel extends ChangeNotifier {
  List<LinkedDevice> _devices = [];

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
