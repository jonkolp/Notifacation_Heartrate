import 'package:flutter/material.dart';
import 'health_data_simulator.dart'; // Make sure this file exists in /lib
import 'notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ml_model_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ask for permission (Android 13+)
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  await NotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Monitor Prototype',
      debugShowCheckedModeBanner: false, // Removes the debug banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Health Monitor (Simulated)'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Stream<Map<String, double>> _healthStream;
  final HealthModelService _modelService = HealthModelService();
  bool _modelLoaded = false;

  @override
  void initState() {
    super.initState();
    _healthStream = getMockHealthDataStream(); // Your simulated health data
    _loadModel();
  }

  Future<void> _loadModel() async {
    setState(() {
      _modelLoaded = true; // Model is loaded after the server call
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: !_modelLoaded
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<Map<String, double>>(
              stream: _healthStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!;
                return FutureBuilder<bool>(
                  future: _modelService.isDangerous(
                    heartRate: data['heart_rate']!,
                    temperature: data['temp']!,
                    oxygen: data['spo2']!,
                  ),
                  builder: (context, dangerSnapshot) {
                    if (!dangerSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final isDanger = dangerSnapshot.data!;
                    if (isDanger) {
                      NotificationService.showDangerNotification();
                    }

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("❤️ Heart Rate: ${data['heart_rate']!.toStringAsFixed(0)} bpm",
                              style: Theme.of(context).textTheme.headlineSmall),
                          Text("🩸 SpO2: ${data['spo2']!.toStringAsFixed(1)}%",
                              style: Theme.of(context).textTheme.headlineSmall),
                          Text("🌡 Temp: ${data['temp']!.toStringAsFixed(1)}°C",
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 20),
                          Text(
                            isDanger ? "⚠ DANGER DETECTED!" : "✅ Normal Condition",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDanger ? Colors.red : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
