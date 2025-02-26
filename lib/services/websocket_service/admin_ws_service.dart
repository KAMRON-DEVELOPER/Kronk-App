import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class AdminWsService {
  // final wsUrl = Uri.parse('ws://192.168.31.43:8000/ws/admin/statistics');
  final _channel = IOWebSocketChannel.connect('ws://192.168.31.43:8000/admin/ws/admin/statistics');
  final StreamController<Map<String, dynamic>> _streamController = StreamController.broadcast();

  AdminWsService() {
    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      _streamController.add(data);
    });
  }

  Stream<Map<String, dynamic>> get statsStream => _streamController.stream;

  void dispose() {
    _channel.sink.close();
    _streamController.close();
  }
}
