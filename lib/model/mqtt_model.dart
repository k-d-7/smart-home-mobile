import 'dart:convert';

import 'package:smarthomeui/model/sensor_model.dart';

class MqttModel {
  final List<SensorModel> data;

  const MqttModel({
    required this.data,
  });

  factory MqttModel.fromJson(Map<String, dynamic> data) {
    dynamic rawData = data['data_sensor'];

    // Check if rawData is a List, if yes, convert it to a JSON string
    if (rawData is List<dynamic>) {
      rawData = json.encode(rawData);
    }

    // Decode the JSON string
    final List<dynamic> decodedSensorData = json.decode(rawData);

    // Rest of your code remains unchanged...
    final List<SensorModel> sensors = decodedSensorData
        .map((sensorData) => SensorModel.fromJson(sensorData))
        .toList();

    return MqttModel(
      data: sensors,
    );
  }
}
