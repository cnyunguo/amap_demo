import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_floatwing/flutter_floatwing.dart';

class TravelingApp extends StatelessWidget {
  const TravelingApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PageView().floatwing(debug: false),
    );
  }
}

class PageView extends StatefulWidget {
  const PageView({Key? key}) : super(key: key);

  @override
  State<PageView> createState() => _PageViewState();
}

class _PageViewState extends State<PageView> {
  Window? w;

  initMap() async {
    await AmapService.instance.init(
      iosKey: '7a04506d15fdb7585707f7091d715ef4',
      androidKey: 'ac9279b912e6820d5e809749b4b8bdee',
      webApiKey: '02560e78f194ebcdc0637a31223c51e2',
    );
    await enableFluttifyLog(true);
  }

  @override
  void initState() {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      w = Window.of(context);
      w
          ?.on(EventType.WindowDragStart, (window, data) {})
          .on(EventType.WindowDragEnd, (window, data) {});
      w?.start();
    });
    initMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.white,
        width: 100,
        height: 100,
        child: Center(
          child: MaterialButton(
            onPressed: () async {
              Location _userLocation = await AmapLocation.instance
                  .fetchLocation(
                      mode: LocationAccuracy.High,
                      timeout: const Duration(seconds: 3));

              print({"object": _userLocation.toString()});
            },
            child: const Text("data"),
          ),
        ),
      ),
    );
  }
}
