import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:grow_me_app/colors.dart';
import 'package:grow_me_app/components/button.dart';
import 'package:grow_me_app/components/card.dart';
import 'package:grow_me_app/components/device_action_sheet.dart';
import 'package:grow_me_app/components/device_model.dart';
import 'package:grow_me_app/components/edit_metric.dart';
import 'package:provider/provider.dart';

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_NOT_ADDED,
  STEPS_READY,
}

class MetricIcon extends StatelessWidget {
  const MetricIcon(this.metric, this.onTap, {super.key});

  final void Function(DeviceMetric?) onTap;
  final DeviceMetric? metric;

  IconData _icon() {
    if (metric == null) {
      return Icons.add;
    }

    switch (metric!.type) {
      case MetricType.pomodor:
        return Icons.timelapse;
      case MetricType.sleep:
        return Icons.bed_rounded;
      case MetricType.water:
      case MetricType.steps:
        return Icons.water_drop_outlined;
    }
  }

  Color _bgColor() {
    if (metric == null) {
      return sand.shade800;
    }

    if (metric!.percentage < 0.10) {
      return burnedEarth.shade900;
    } else if (metric!.percentage < 0.20) {
      return burnedEarth.shade800;
    } else if (metric!.percentage < 0.25) {
      return burnedEarth.shade500;
    } else if (metric!.percentage < 0.35) {
      return green.shade100;
    } else if (metric!.percentage < 0.50) {
      return green.shade300;
    } else if (metric!.percentage < 0.70) {
      return green.shade500;
    } else {
      return green.shade700;
    }
  }

  Color _textColor() {
    if (metric == null) {
      return green.shade400;
    }

    return sand;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onTap(metric);
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: _bgColor(),
              shape: BoxShape.rectangle,
            ),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  _icon(),
                  size: 33,
                  color: _textColor(),
                )),
          ),
        ));
  }
}

class DeviceView extends StatefulWidget {
  const DeviceView({super.key, required this.device});

  final LinkedDevice device;

  @override
  State<StatefulWidget> createState() => DeviceViewState();
}

class DeviceViewState extends State<DeviceView> {
  @override
  Widget build(BuildContext context) {
    var device = widget.device;
    return Consumer<DeviceModel>(builder: (context, model, child) {
      return Column(
        children: [
          Text(
            device.description.name,
            textScaleFactor: 2,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 25),
          CircleAvatar(
            backgroundColor: device.isConnected ? sand.shade900 : sand.shade900,
            radius: min(MediaQuery.of(context).size.height * 0.13,
                MediaQuery.of(context).size.width * 0.5),
            child: const Padding(
                padding: EdgeInsets.all(25),
                child: Image(
                    image: AssetImage('assets/images/grow-me-medium.png'))),
          ),
          const Spacer(),
          const Text(
            "Progress",
            textScaleFactor: 1.25,
          ),
          const SizedBox(height: 5),
          Flex(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              direction: Axis.horizontal,
              children: device.metrics
                  .map((m) => MetricIcon(m, (_) {
                        showEditMetricModal(context, device, m);
                      }))
                  .toList()),
          const Spacer(),
          !device.isConnected
              ? Button(
                  "Reconnect",
                  () {
                    model.reconnect(device);
                  },
                  type: ButtonType.outlined,
                )
              : Container(),
          const SizedBox(height: 15),
          DeviceActionSheet(device: device, model: model)
        ].toList(),
      );
    });
  }
}
