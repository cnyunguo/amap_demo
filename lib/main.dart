// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floatwing/flutter_floatwing.dart';

void main() async {
  await FloatwingPlugin().ensureWindow();
  if (FloatwingPlugin().isWindow) {
    // runApp(const TravelingApp());
  } else {
    await AmapService.instance.init(
      iosKey: '7a04506d15fdb7585707f7091d715ef4',
      androidKey: 'ac9279b912e6820d5e809749b4b8bdee',
      webApiKey: '02560e78f194ebcdc0637a31223c51e2',
    );
    await enableFluttifyLog(true);
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Location? location;
  Window? w;

  getLocation() async {
    location = null;
    Location _userLocation = await AmapLocation.instance.fetchLocation(
        mode: LocationAccuracy.High, timeout: const Duration(seconds: 3));
    setState(() {
      location = _userLocation;
    });
  }

  openFloatWindow() async {
    var p1 = await FloatwingPlugin().checkPermission();
    if (!p1) {
      FloatwingPlugin().openPermissionSetting();
      return;
    }
    w = WindowConfig(id: 'floatWindow', autosize: true, draggable: true).to();

    await FloatwingPlugin().initialize();
    await FloatwingPlugin().isServiceRunning().then((v) async {
      if (!v) {
        await FloatwingPlugin().startService().then((_) {});
      }
    });
    w?.create(start: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Colors.blue),
              child: Text(
                location?.toString() ?? '未获取位置',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            MaterialButton(
              color: Colors.blue,
              onPressed: openFloatWindow,
              child: const Text(
                "打开悬浮窗",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getLocation,
        child: const Icon(Icons.location_on),
      ),
    );
  }
}
