import 'dart:async';

import 'package:flutter/material.dart';

enum ColorEvent {
  // ignore: constant_identifier_names
  event_red,
  // ignore: constant_identifier_names
  event_green,
}

class ColorBloc {
  Color _color = Colors.red;
  final _inputEventController = StreamController<ColorEvent>();

  StreamSink<ColorEvent> get inputEventSink => _inputEventController.sink;

  final _outputStreamController = StreamController<Color>();

  Stream<Color> get outputStream => _outputStreamController.stream;

  void mapEventToState(ColorEvent event) {
    if (event == ColorEvent.event_red) {
      _color = Colors.red;
    } else if (event == ColorEvent.event_green) {
      _color = Colors.green;
    } else {
      throw Exception('Error Event');
    }
    _outputStreamController.sink.add(_color);
  }

  ColorBloc() {
    _inputEventController.stream.listen(mapEventToState);
  }

  void dispose() {
    _inputEventController.close();
    _outputStreamController.close();
  }
}
