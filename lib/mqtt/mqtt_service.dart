import 'dart:convert';
import 'dart:developer';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

typedef OnDataReceivedCallback = void Function(Map<String, dynamic> data);

class MQTTService {
  MQTTService({
    this.host,
    this.port,
    this.topics,
    // this.model,
    this.isMe = false,
  });

  // final MQTTModel? model;

  final String? host;

  final int? port;

  final List<String>? topics;

  late MqttServerClient _client;

  bool isMe;

  OnDataReceivedCallback? onDataReceived;

  void initializeMQTTClient() {
    _client = MqttServerClient("mqttserver.tk", 'flutter_mobile')
      ..port = 1883
      ..logging(on: false)
      ..onDisconnected = onDisConnected
      ..onSubscribed = onSubscribed
      ..keepAlivePeriod = 20
      ..onConnected = onConnected;

    final connMess = MqttConnectMessage()
        .authenticateAs('innovation', 'Innovation_RgPQAZoA5N')
        .withWillTopic('willTopic')
        .withWillMessage('willMessage')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print('Connecting....');
    _client.connectionMessage = connMess;
  }

  Future connectMQTT() async {
    try {
      await _client.connect();
    } on NoConnectionException catch (e) {
      log(e.toString());
      _client.disconnect();
    }
  }

  void disConnectMQTT() {
    try {
      _client.disconnect();
    } catch (e) {
      log(e.toString());
    }
  }

  Map<String, dynamic> onConnected() {
    log('Connected');
    Map<String, dynamic> data = {};

    try {
      for (var topic in topics!) {
        _client.subscribe(topic, MqttQos.atLeastOnce);
        _client.updates!.listen(
          (dynamic t) {
            final MqttPublishMessage recMess = t[0].payload;
            final message = MqttPublishPayload.bytesToStringAsString(
                recMess.payload.message);

            // log('message id : ${recMess.variableHeader?.messageIdentifier}');
            // log('message : $message');
            data = json.decode(message);
            // print(data['data_sensor']);

            if (onDataReceived != null) {
              onDataReceived!(data);
            }
          },
        );
      }

      return data;
    } catch (e) {
      log(e.toString());
      return data;
    }
  }

  void onDisConnected() {
    log('Disconnected');
  }

  void publish(String message, String topic) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);

    builder.clear();
  }

  void onSubscribed(String topic) {
    log(topic);
  }
}
