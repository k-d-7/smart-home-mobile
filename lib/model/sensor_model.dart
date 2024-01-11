class SensorModel {
  final String name;
  final String value;

  const SensorModel({
    required this.name,
    required this.value,
  });

  factory SensorModel.fromJson(Map<String, dynamic> data) {
    return SensorModel(
      name: data['sensor_key'],
      value: data['sensor_value'],
    );
  }
}
