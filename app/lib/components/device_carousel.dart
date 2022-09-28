import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:grow_me_app/components/button.dart';
import 'package:grow_me_app/components/card.dart';
import 'package:grow_me_app/components/device_debug.dart';
import 'package:grow_me_app/components/device_model.dart';
import 'package:provider/provider.dart';

class DeviceCarousel extends StatefulWidget {
  const DeviceCarousel({super.key, this.leadingCarouselItems});

  final List<Widget>? leadingCarouselItems;

  @override
  State<StatefulWidget> createState() => DeviceCarouselState();
}

class DeviceCarouselState extends State<DeviceCarousel> {
  List<Widget> _plantCards(DeviceModel model) {
    return model.devices.map((device) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: GrowMeCard(
                  child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          Text(device.description.name, textScaleFactor: 2),
                          const SizedBox(height: 15),
                          const CircleAvatar(
                            backgroundColor: Colors.lightGreen,
                            backgroundImage:
                                AssetImage('assets/prototype-render.png'),
                            radius: 150.0,
                          ),
                          const SizedBox(height: 25),
                          TextButton(
                              onPressed: () {
                                showDeviceDebugView(context, device);
                              },
                              child: const Text("Open Debug menu"))
                        ].toList(),
                      ))));
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceModel>(builder: (context, model, child) {
      return CarouselSlider(
        options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.7,
            initialPage: model.devices.isNotEmpty ? 1 : 0,
            autoPlay: false,
            enlargeCenterPage: true,
            clipBehavior: Clip.none,
            enableInfiniteScroll: false),
        items: widget.leadingCarouselItems != null
            ? [...widget.leadingCarouselItems!, ..._plantCards(model)]
            : _plantCards(model),
      );
    });
  }
}
