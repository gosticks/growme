import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:grow_me_app/colors.dart';
import 'package:grow_me_app/components/bottom_sheet.dart';
import 'package:grow_me_app/components/button.dart';
import 'package:grow_me_app/components/device_model.dart';
import 'package:provider/provider.dart';

class EditDeviceView extends StatefulWidget {
  const EditDeviceView({
    required this.device,
    super.key,
  });

  final LinkedDevice device;

  @override
  EditDeviceViewState createState() => EditDeviceViewState();
}

class EditDeviceViewState extends State<EditDeviceView> {
  TextEditingController _deviceNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _deviceNameController =
        TextEditingController(text: widget.device.description.name);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _deviceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceModel>(
        builder: (context, model, value) => Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  backgroundColor: green,
                  radius: 100.0,
                  child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Image(
                          image:
                              AssetImage('assets/images/grow-me-medium.png'))),
                ),
                const SizedBox(height: 50),
                const Text("Give your plant a name",
                    textScaleFactor: 1.5, textAlign: TextAlign.left),
                const SizedBox(height: 15),
                TextField(
                  controller: _deviceNameController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Give your plant a name',
                  ),
                ),
                const SizedBox(height: 25),
                Button("Save", () {
                  widget.device.description.name =
                      _deviceNameController.value.text;

                  model.updateEntry(widget.device.description.remoteId,
                      widget.device.description);

                  Navigator.pop(context);
                })
              ].toList(),
            ));
  }
}

Future showEditDeviceModal(BuildContext context, LinkedDevice device) {
  return showCustomModalBottomSheet(
      context,
      Padding(
          padding: const EdgeInsets.all(25),
          child: EditDeviceView(
            device: device,
          )));
}
