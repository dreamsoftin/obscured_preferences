import 'package:flutter/material.dart';
import 'package:obscured_preferences/obscured_preferences.dart';

const STR_KEY = "StrKey";
const BOOL_KEY = "BoolKey";
const INT_KEY = "IntKey";
const DOUBLE_KEY = "DoubleKey";
const STR_LIST_KEY = "StrListKey";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PrefsPage(),
    );
  }
}

class PrefsPage extends StatefulWidget {
  @override
  PrefsPageState createState() => PrefsPageState();
}

class PrefsPageState extends State<PrefsPage> {
  ObscuredPrefs _prefs;

  List<String> _randomList = ['Hello', 'One', 'Flutter', 'World'];

  String _savedStringValue;
  bool _savedBoolValue;
  int _savedIntValue;
  double _savedDoubleValue;
  List<String> _savedStringListValue = [];

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  void _initPrefs() async {
    _prefs = await ObscuredPrefs.getInstance();
    setState(() {
      _savedStringValue = _prefs.getString(STR_KEY);
      _savedBoolValue = _prefs.getBool(BOOL_KEY);
      _savedIntValue = _prefs.getInt(INT_KEY);
      _savedDoubleValue = _prefs.getDouble(DOUBLE_KEY);
      _savedStringListValue = _prefs.getStringList(STR_LIST_KEY) ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Obscured Prefs",
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: "String Value",
                ),
                onSubmitted: _onSaveStringPressed,
              ),
              Text(
                "Saved String: $_savedStringValue",
              ),
              _savedBoolValue == null
                  ? Text("Bool value not saved")
                  : SizedBox(
                      width: 0,
                      height: 0,
                    ),
              Switch(
                value: _savedBoolValue ?? false,
                onChanged: _onSaveBoolPressed,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Int Value",
                ),
                onSubmitted: _onSaveIntPressed,
                keyboardType: TextInputType.numberWithOptions(
                  signed: true,
                ),
              ),
              Text(
                "Saved Int: $_savedIntValue",
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Double Value",
                ),
                onSubmitted: _onSaveDoublePressed,
                keyboardType: TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
              ),
              Text(
                "Saved Double: $_savedDoubleValue",
              ),
              RaisedButton(
                onPressed: _onSaveStringListPressed,
                color: Colors.blue,
                child: Text(
                  "Save List",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                height: 100,
                child: ListView(
                  children: _savedStringListValue
                      .map((s) => ListTile(
                            title: Text(s),
                          ))
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onSaveStringPressed(String value) async {
    if (_prefs != null) {
      await _prefs.setString(STR_KEY, value);
    }
    setState(() {
      _savedStringValue = _prefs.getString(STR_KEY);
    });
  }

  void _onSaveStringListPressed() async {
    if (_prefs != null) {
      await _prefs.setStringList(STR_LIST_KEY, _randomList);
    }
    setState(() {
      _savedStringListValue = _prefs.getStringList(STR_LIST_KEY);
    });
  }

  void _onSaveIntPressed(String value) async {
    if (_prefs != null) {
      await _prefs.setInt(INT_KEY, int.tryParse(value));
    }
    setState(() {
      _savedIntValue = _prefs.getInt(INT_KEY);
    });
  }

  void _onSaveDoublePressed(String value) async {
    if (_prefs != null) {
      await _prefs.setDouble(DOUBLE_KEY, double.tryParse(value));
    }
    setState(() {
      _savedDoubleValue = _prefs.getDouble(DOUBLE_KEY);
    });
  }

  void _onSaveBoolPressed(bool value) async {
    if (_prefs != null) {
      await _prefs.setBool(BOOL_KEY, value);
    }
    setState(() {
      _savedBoolValue = _prefs.getBool(BOOL_KEY);
    });
  }
}
