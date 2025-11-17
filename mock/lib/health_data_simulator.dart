import 'dart:async';
import 'dart:math';

Stream<Map<String, double>> getMockHealthDataStream() async* {
  final random = Random();
  while (true) {
    await Future.delayed(Duration(seconds: 5));
    yield {
      'heart_rate': 70 + random.nextInt(70).toDouble(), // 70–130 bpm
      'spo2': 85 + random.nextInt(15).toDouble(),       // 85–100%
      'temp': 35 + random.nextDouble() * 3            // 35.0–37.5°C
    };
  }
}

bool isHealthDataDangerous(Map<String, double> data) {
  return data['heart_rate']! > 120 ||
         data['spo2']! < 90 ||
         data['temp']! > 38.0;
}