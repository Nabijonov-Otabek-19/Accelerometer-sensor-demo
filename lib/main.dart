import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accelerometer demo',
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _accX = 0.0;
  double _accY = 0.0;

  double ballX = 0.0;
  double ballY = 0.0;

  double ballWidth = 50;
  double ballHeight = 50;
  final myWidgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    listenSensor();
  }

  void listenSensor() async {
    // Listen to gyroscope data stream
    accelerometerEventStream().listen((event) {
      Future.delayed(const Duration(milliseconds: 80)).then(
        (value) => setState(() {
          _accX = event.x;
          _accY = event.y;

          calculate();
        }),
      );
    });
  }

  void calculate() {
    RenderBox renderBox =
        myWidgetKey.currentContext!.findRenderObject() as RenderBox;
    double width = renderBox.size.width;
    double height = renderBox.size.height;
    print('Widget Container coordinates: x=$width, y=$height');

    ballX -= ballWidth * (_accX / 5);
    if (ballX < 0) {
      ballX = 0.0;
    }
    if (ballX > width - ballWidth - 5) {
      ballX = width - ballWidth - 5;
    }

    ballY += ballHeight * (_accY / 5);
    if (ballY < 0.0) {
      ballY = 0.0;
    }
    if (ballY > height - ballHeight - 5) {
      ballY = height - ballHeight - 5;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accelerometer demo"),
      ),
      body: SizedBox(
        key: myWidgetKey,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: ballX,
              top: ballY,
              child: Card(
                elevation: 6,
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80),
                ),
                child: SizedBox(
                  width: ballWidth,
                  height: ballHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
