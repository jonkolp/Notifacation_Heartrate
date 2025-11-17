import 'dart:convert';
import 'package:http/http.dart' as http;

class HealthModelService {
  final String apiUrl = "http://10.0.2.2:8000/predict"; // Replace with your FastAPI server's IP and port

  Future<bool> isDangerous({
    required double heartRate,
    required double temperature,
    required double oxygen,
  }) async {
    // Prepare the data to send in the POST request
    final Map<String, dynamic> healthData = {
      'heart_rate': heartRate,
      'temperature': temperature,
      'oxygen': oxygen,
    };

    // Send the POST request to the FastAPI server
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(healthData),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the prediction
      final data = json.decode(response.body);
      double prediction = data['prediction'];
      return prediction >= 0.55;
    } else {
      // If the server returns an error, throw an exception
      throw Exception('Failed to load prediction');
    }
  }
}
