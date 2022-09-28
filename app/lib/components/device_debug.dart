import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:grow_me_app/components/bottom_sheet.dart';
import 'package:grow_me_app/components/connection_sheet.dart';
import 'package:grow_me_app/components/device_model.dart';
import 'package:grow_me_app/message.pb.dart';

import 'dart:developer' as developer;

class DeviceDebugView extends StatefulWidget {
  const DeviceDebugView({super.key, required this.device});

  final LinkedDevice device;

  @override
  State<StatefulWidget> createState() => DeviceDebugViewState();
}

class DeviceDebugViewState extends State<DeviceDebugView> {
  final List<double> _motorStepValues = [20, 20, 40, 50, 60, 20];

  Future<BluetoothCharacteristic?> _getCharacteristic() async {
    var device = widget.device.device;
    try {
      var services = await device!.discoverServices();

      BluetoothService service = services.firstWhere(
          (element) => element.uuid.toString() == bleServiceName.toLowerCase());
      if (service == null) {
        developer.log("device does not offer motor control service",
            name: "device.debug");
      }
      return service.characteristics.first;
    } catch (e) {
      return null;
    }
  }

  void _resetMotorPosition(int index) async {
    var ch = await _getCharacteristic();
    if (ch == null) {
      return;
    }

    var cmd = Command(reset: ResetMotorPositionCommand());

    await ch.write(cmd.writeToBuffer(), withoutResponse: false);
    await ch.setNotifyValue(true);
  }

  void _sendMotorControl(int index, bool isDecriment) async {
    var ch = await _getCharacteristic();
    if (ch == null) {
      return;
    }

    // find motor control service
    int factor = isDecriment ? -1 : 1;

    var cmd = Command(
        move:
            MoveMotorCommand(target: factor * _motorStepValues[index].toInt()));

    await ch.write(cmd.writeToBuffer(), withoutResponse: false);
    await ch.setNotifyValue(true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(widget.device.description.name),
      ..._motorStepValues.asMap().entries.map((entry) => Column(children: [
            const SizedBox(height: 15),
            Text("Motor ${entry.key + 1}"),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      _resetMotorPosition(entry.key);
                    },
                    icon: const Icon(Icons.replay_outlined)),
                const Spacer(),
                Slider(
                  value: entry.value,
                  max: 1000,
                  divisions: 25,
                  label: _motorStepValues[entry.key].round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _motorStepValues[entry.key] = value;
                    });
                  },
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      _sendMotorControl(entry.key, true);
                    },
                    icon: const Icon(Icons.remove_circle)),
                IconButton(
                    onPressed: () {
                      _sendMotorControl(entry.key, false);
                    },
                    icon: const Icon(Icons.add_circle))
              ],
            )
          ])),
    ]);
  }
}

Future showDeviceDebugView(BuildContext context, LinkedDevice device) {
  return showCustomModalBottomSheet(
    context,
    DeviceDebugView(device: device),
  );
}
