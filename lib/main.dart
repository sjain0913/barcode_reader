import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

const CHANNEL = "com.oblivion.barcode";
const KEY_NATIVE = "showNativeView";
const KEY_OTHER = "showOther";
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

  MyHomePage({Key key, this.title}) : super(key: key) {
    platform.setMethodCallHandler(_handleMethod);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              child: new Text('Move to Native World!'),
              onPressed: _showNativeView,
            ),
            new RaisedButton(
              child: new Text('Other'),
              onPressed: _showOther,
            ),
            new RaisedButton(
              child: new Text('Read'),
              onPressed: _showRead,
            ),
            new TextField(
              controller: myController,
            )
          ],
        ),
      ),
    );
  }

  Future<Null> _showNativeView() async {
    await platform.invokeMethod(KEY_NATIVE);
  }

  Future<Null> _showOther() async {
    await platform.invokeMethod(KEY_OTHER);
  }

  Future<Null> _showRead() async {
    String message = myController.text;
    await platform.invokeMethod(KEY_READ,{"barcode":message});
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "message":
        debugPrint(call.arguments);
        return new Future.value("");
    }
  }
}