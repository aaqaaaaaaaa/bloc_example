import 'dart:async';

import 'package:flutter/material.dart';

enum ColorEvent { event_red, event_green }

class ColorBloc {
  Color _color = Colors.red;

  final _inputEventController = StreamController<ColorEvent>();

  StreamSink<ColorEvent> get inputEvent => _inputEventController.sink;

  final _outputState = StreamController<Color>();

  Stream<Color> get outputState => _outputState.stream;

  void mapEventToState(ColorEvent event) {
    _color = (event == ColorEvent.event_red) ? Colors.red : Colors.green;
    _outputState.sink.add(_color);
  }

  ColorBloc() {
    _inputEventController.stream.listen(mapEventToState);
  }

  void dispose() {
    _inputEventController.close();
    _outputState.close();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ColorBloc _bloc = ColorBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('BloC Animated Container'),
      ),
      body: Center(
        child: StreamBuilder(
          initialData: ColorEvent.event_red,
          stream: _bloc.outputState,
          builder: (context, AsyncSnapshot snapshot) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              margin: EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: MediaQuery.of(context).size.height / 4),
              color: snapshot.data,
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              _bloc.inputEvent.add(ColorEvent.event_red);

            },
          ),
          const SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () {
              _bloc.inputEvent.add(ColorEvent.event_green);
            },
          ),
        ],
      ),
    );
  }
}
