import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:grow_me_app/colors.dart';
import 'package:grow_me_app/components/bottom_sheet.dart';
import 'package:grow_me_app/components/button.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(widget.device.description.name),
      ..._motorStepValues.asMap().entries.map((entry) =>
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 15),
            Text(
              "Motor ${entry.key + 1}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (widget.device.motorStatus == null
                    ? Container()
                    : Row(
                        children: widget.device.motorStatus!.status
                            .asMap()
                            .entries
                            .map((e) => Column(
                                  children: [Text("M${e.key} pos: ${e.value}")],
                                ))
                            .toList(),
                      )),
                // IconButton(
                //     onPressed: () {
                //       widget.device.resetMotorPosition(entry.key);
                //     },
                //     icon: const Icon(Icons.replay_outlined)),

                Expanded(
                    child: Slider(
                  value: entry.value,
                  max: 1000,
                  divisions: 25,
                  thumbColor: green,
                  activeColor: green.shade400,
                  inactiveColor: green.shade200,
                  label: _motorStepValues[entry.key].round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _motorStepValues[entry.key] = value;
                    });
                  },
                )),
                IconButton(
                    onPressed: () {
                      widget.device.moveMotor(
                          entry.key, -1 * _motorStepValues[entry.key].toInt());
                    },
                    icon: const Icon(
                      Icons.remove_circle,
                      color: burnedEarth,
                    )),
                IconButton(
                    onPressed: () {
                      widget.device.moveMotor(
                          entry.key, _motorStepValues[entry.key].toInt());
                    },
                    icon: const Icon(
                      Icons.add_circle,
                      color: green,
                    ))
              ],
            )
          ])),
      const SizedBox(height: 15),
      Button(
        "Reload state",
        (() {
          widget.device.fetchStatusUpdate().then((value) {
            setState(() {});
          });
        }),
        type: ButtonType.outlined,
      )
    ]);
  }
}

Future showDeviceDebugView(BuildContext context, LinkedDevice device) {
  return showCustomModalBottomSheet(
    context,
    DeviceDebugView(device: device),
  );
}
