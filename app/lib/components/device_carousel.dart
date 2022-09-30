import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:grow_me_app/colors.dart';
import 'package:grow_me_app/components/button.dart';
import 'package:grow_me_app/components/card.dart';
import 'package:grow_me_app/components/device_action_sheet.dart';
import 'package:grow_me_app/components/device_model.dart';
import 'package:grow_me_app/components/device_view.dart';
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
                      padding: const EdgeInsets.all(10),
                      child: DeviceView(
                        device: device,
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
            scrollPhysics: const BouncingScrollPhysics(),
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
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
