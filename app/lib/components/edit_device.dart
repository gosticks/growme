import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
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
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                TextField(
                  controller: _deviceNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a search term',
                  ),
                ),
                const SizedBox(height: 25),
                const CircleAvatar(
                  backgroundColor: Colors.lightGreen,
                  backgroundImage: AssetImage('assets/prototype-render.png'),
                  radius: 150.0,
                ),
                const SizedBox(height: 50),
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
      EditDeviceView(
        device: device,
      ));
}
