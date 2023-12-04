import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerSensor {
  Stream<AccelerometerEvent>? _accelerometerStream;

  // Constructor
  AccelerometerSensor() {
    _accelerometerStream = accelerometerEvents;
  }

  // Method to start listening to accelerometer data
  void startListening(void Function(AccelerometerEvent) onData) {
    _accelerometerStream?.listen(onData);
  }

  // Method to stop listening to accelerometer data
  void stopListening() {
    _accelerometerStream = null;
  }
}
