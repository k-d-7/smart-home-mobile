import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:smarthomeui/mqtt/mqtt_service.dart';
import 'package:smarthomeui/util/smart_device_box.dart';

//Create a shader linear gradient
final Shader linearGradient = const LinearGradient(
  colors: <Color>[
    Color.fromARGB(255, 227, 241, 255),
    Color.fromARGB(255, 225, 236, 252)
  ],
).createShader(const Rect.fromLTWH(255.0, 255.0, 255.0, 255.0));

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  bool isLoading = false;
  bool isLoadingSensor = true;
  bool isLoadingCo2 = true;

  MQTTService? mqttService;

  // list of smart devices
  List mySmartDevices = [
    ["Smart Light", "lib/icons/light-bulb.png", false],
    ["Smart Fan", "lib/icons/fan.png", false],
    ["Device 3", "lib/icons/air-conditioner.png", false],
    ["Device 4", "lib/icons/smart-tv.png", false],
  ];

  Map<String, dynamic> receiveSensorData = {};
  Map<String, dynamic> receiveCo2Data = {};

  // power button switched
  void powerSwitchChanged(bool value, int index) {
    // final _service = MQTTService(
    //   topics: "/innovation/airmonitoring/smarthome/fan",
    // );
    // _service.initializeMQTTClient();
    // _service.connectMQTT();
    Map<String, dynamic> dataFan = {
      'data_device': {
        'device_key': 'fan',
        'current': -1,
        'voltage': -1,
        'power': -1,
        'status': value
      }
    };

    Map<String, dynamic> dataLight = {
      'data_device': {
        'device_key': 'light',
        'current': -1,
        'voltage': -1,
        'power': -1,
        'status': value
      }
    };

    setState(() {
      try {
        if (index == 0) {
          // _service.publish(jsonEncode(dataLight));
          mqttService?.publish(
            jsonEncode(dataLight),
            "/innovation/airmonitoring/smarthome/light",
          );
        } else if (index == 1) {
          // _service.publish(jsonEncode(dataFan));
          mqttService?.publish(
            jsonEncode(dataFan),
            "/innovation/airmonitoring/smarthome/fan",
          );
        } else if (index == 2) {
          // setDevice3(value);
        } else if (index == 3) {
          // setDevice4(value);
        }
        mySmartDevices[index][2] = value;
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initValueSensor();
  }

  void initValueSensor() {
    mqttService = MQTTService(
      topics: [
        "/innovation/airmonitoring/smarthome/sensors",
        "/innovation/airmonitoring/smarthome/co2",
        "/innovation/airmonitoring/smarthome/light",
        "/innovation/airmonitoring/smarthome/fan",
      ],
    );
    mqttService?.initializeMQTTClient();
    mqttService?.connectMQTT();
    mqttService?.onDataReceived = onDataSensorReceived;
  }

  // Callback function to handle received data
  void onDataSensorReceived(Map<String, dynamic> data) {
    print("Received data in Sensors: $data");
    setState(() {
      if (data['data_device'] == null) {
        if (data['data_sensor'].length > 1) {
          receiveSensorData = data;
          isLoadingSensor = false;
        } else {
          receiveCo2Data = data;
          isLoadingCo2 = false;
        }
      } else {
        if (data['data_device']['device_key'] == "fan") {
          mySmartDevices[1][2] = data['data_device']['status'];
        } else {
          mySmartDevices[0][2] = data['data_device']['status'];
        }
      }
    });
  }

  void onDataLightReceived(Map<String, dynamic> data) {
    print("Received data in Light: $data");
    setState(() {
      mySmartDevices[0][2] = data['data_device']['status'];
      isLoadingSensor = false;
    });
  }

  void onDataFanReceived(Map<String, dynamic> data) {
    print("Received data in Fan: $data");
    setState(() {
      mySmartDevices[1][2] = data['data_device']['status'];
      isLoadingSensor = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Home!",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                const Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 204, 204, 204),
                ),

                const SizedBox(height: 25),

                // general information
                Text(
                  "General Information",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.grey.shade800,
                  ),
                ),

                // const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      isLoadingSensor
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.2), //color of shadow
                                    spreadRadius: 4, //spread radius
                                    blurRadius: 4, // blur radius
                                    offset: const Offset(
                                      0,
                                      2,
                                    ),
                                  ),
                                ],
                              ),
                              height: 150,
                              child: const Center(
                                child: SizedBox(
                                  height: 30,
                                  child: LoadingIndicator(
                                      indicatorType:
                                          Indicator.ballSpinFadeLoader,
                                      colors: [Colors.blueAccent],
                                      strokeWidth: 2,
                                      backgroundColor: Colors.white,
                                      pathBackgroundColor: Colors.white),
                                ),
                              ),
                            )
                          : MyCard(
                              title: receiveSensorData['data_sensor'] != null
                                  ? receiveSensorData['data_sensor'][0]
                                      ['sensor_key']
                                  : "",
                              icon: const Icon(
                                FontAwesomeIcons.temperatureHalf,
                                color: Colors.blueAccent,
                              ),
                              value: Text(
                                receiveSensorData['data_sensor'] != null
                                    ? "${receiveSensorData['data_sensor'][0]['sensor_value'].toString()} °C"
                                    : "0 °C",
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                      const SizedBox(height: 25),
                      isLoadingSensor
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 4,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              height: 150,
                              child: const Center(
                                child: SizedBox(
                                  height: 30,
                                  child: LoadingIndicator(
                                      indicatorType:
                                          Indicator.ballSpinFadeLoader,
                                      colors: [Colors.blueAccent],
                                      strokeWidth: 2,
                                      backgroundColor: Colors.white,
                                      pathBackgroundColor: Colors.white),
                                ),
                              ),
                            )
                          : MyCard(
                              title: receiveSensorData['data_sensor'] != null
                                  ? receiveSensorData['data_sensor'][1]
                                      ['sensor_key']
                                  : "",
                              icon: const Icon(
                                FontAwesomeIcons.water,
                                color: Colors.blueAccent,
                              ),
                              value: Text(
                                receiveSensorData['data_sensor'] == null
                                    ? "0 %"
                                    : "${receiveSensorData['data_sensor'][1]['sensor_value']} %",
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                      const SizedBox(height: 25),
                      isLoadingCo2
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 4,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              height: 150,
                              child: const Center(
                                child: SizedBox(
                                  height: 30,
                                  child: LoadingIndicator(
                                      indicatorType:
                                          Indicator.ballSpinFadeLoader,
                                      colors: [Colors.blueAccent],
                                      strokeWidth: 2,
                                      backgroundColor: Colors.white,
                                      pathBackgroundColor: Colors.white),
                                ),
                              ),
                            )
                          : MyCard(
                              title: receiveCo2Data['data_sensor'] != null
                                  ? receiveCo2Data['data_sensor'][0]
                                      ['sensor_key']
                                  : "",
                              icon: const Icon(
                                FontAwesomeIcons.water,
                                color: Colors.blueAccent,
                              ),
                              value: Text(
                                receiveCo2Data['data_sensor'] == null
                                    ? "0"
                                    : "${receiveCo2Data['data_sensor'][0]['sensor_value']}",
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),

                const Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 204, 204, 204),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Smart Devices",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      child: isLoading
                          ? const LoadingIndicator(
                              indicatorType: Indicator.lineScale,
                              colors: [Colors.blueAccent],
                              strokeWidth: 2,
                              backgroundColor: Colors.white,
                              pathBackgroundColor: Colors.white,
                            )
                          : Container(),
                    )
                  ],
                ),
                const SizedBox(height: 10),

                // grid
                isLoading
                    ? Container()
                    : GridView.builder(
                        itemCount: 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        // padding: const EdgeInsets.symmetric(horizontal: 25),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1.3,
                        ),
                        itemBuilder: (context, index) {
                          return SmartDeviceBox(
                            smartDeviceName: mySmartDevices[index][0],
                            iconPath: mySmartDevices[index][1],
                            powerOn: mySmartDevices[index][2],
                            onChanged: (value) =>
                                powerSwitchChanged(value, index),
                          );
                        },
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyCard extends StatefulWidget {
  const MyCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.value});

  final String title;
  final Icon icon;
  final Text value;

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), //color of shadow
            spreadRadius: 4, //spread radius
            blurRadius: 4, // blur radius
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(44, 164, 167, 189),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          FontAwesomeIcons.airbnb,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.title.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.cloud,
                  color: Colors.blueAccent,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    widget.icon,
                    const SizedBox(
                      width: 20,
                    ),
                    widget.value,
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Detail",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
