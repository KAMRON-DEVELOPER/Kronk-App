import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class FeedWsService {
  final IOWebSocketChannel _channel = IOWebSocketChannel.connect('ws://192.168.31.43:8000/community/ws/post_notify');
  final StreamController<Map<String, dynamic>> _streamController = StreamController.broadcast();

  FeedWsService() {
    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      _streamController.add(data);
    });
  }

  Stream<Map<String, dynamic>> get postNotifyStream => _streamController.stream;

  void dispose() {
    _channel.sink.close();
    _streamController.close();
  }
}
