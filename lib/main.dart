import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

const CHANNEL = "com.oblivion.barcode";
const KEY_NATIVE = "showNativeView";
const KEY_READ = "read";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter-Native Bridging',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new MyHomePage(title: 'Bridging Demo - Flutter Layer'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  static const platform = const MethodChannel(CHANNEL);
  final String title;
  final myController = TextEditingController();

  String _result = '';
  String _filename = '';
  bool _isExisted = false;

  MyHomePage({Key key, this.title}) : super(key: key) {
    platform.setMethodCallHandler(_handleMethod);
  }

  @override
  Widget build(BuildContext context) {
    if (_isExisted) {
      return new Material(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text('QR Reader'),
              new TextField(
                decoration: InputDecoration(
                  labelText: "Please input the image path",
                ),
                controller: myController,
                autofocus: true,
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new RaisedButton(
                    child: new Text('Read'),
                      onPressed: _showRead,
                  ),
                  new RaisedButton(
                    child: new Text('Reset'),
                      onPressed: _resetResult
                  ),
                  new RaisedButton(
                    child: new Text("Test"),
                    onPressed: _showNativeView,
                  ),
                ],
              ),
              new Image.file(new File(_filename)),
              new Text('$_result'),
            ],
          )
        )
      );
    } else {
      return new Material(
        child: new Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Text('QR Reader'),
                new TextField(
                  decoration: InputDecoration(
                    labelText: "Please input the image path",
                  ),
                  controller: myController,
                  autofocus: true,
                ),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new RaisedButton(
                          child: new Text('Read'),
                          onPressed: _showRead
                      ),
                      new RaisedButton(
                          child: new Text('Reset'),
                          onPressed: _resetResult
                      ),
                      new RaisedButton(
                        child: new Text("Test"),
                        onPressed: _showNativeView,
                      ),
                    ]
                ),
                new Text('$_result'),
            ]
          )
        )
      );
    }

  }

  Future<Null> _showNativeView() async {
    await platform.invokeMethod(KEY_NATIVE);
  }

  Future<Null> _showRead() async {
    String message = myController.text;
    _filename = message;
    await platform.invokeMethod(KEY_READ,{"barcode":message});
    if (!mounted)
      return;
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "message":
        debugPrint(call.arguments);
        return new Future.value("");
    }
  }
}