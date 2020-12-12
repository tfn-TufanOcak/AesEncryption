import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:steel_crypt/steel_crypt.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AES Encryption',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'AES Encryption'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String textValue;
  String textPass;
  String result;
  var formKey = GlobalKey<FormState>();
  var _controller = TextEditingController();
  FocusNode _focusNode;
  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _controller.clear();
    });
    super.initState();
  }

  var aesEncrypter = AesCrypt(
      key: "GpEVC0OOhm0/AI/erPiMl7gZU9r27XDcYuaZLdWREtw=",
      padding: PaddingAES.pkcs7);
  decode(String password, String encrypted) {
    String decrypted = aesEncrypter.gcm.decrypt(enc: encrypted, iv: password);
    return decrypted;
  }

  encode(String password, String text) {
    String encrypted = aesEncrypter.gcm.encrypt(inp: text, iv: password);
    return encrypted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Builder(
        builder: (context) {
          return Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    Text(
                      "AES Encryption",
                      style: TextStyle(fontSize: 30),
                    ),
                    TextFormField(
                      focusNode: _focusNode,
                      controller: _controller,
                      autofocus: true,
                      maxLines: 9,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter the value'),
                      onSaved: (String value) {
                        setState(() {
                          textValue = value;
                        });
                      },
                    ),
                    TextFormField(
                      autofocus: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter the password'),
                      onSaved: (String value) {
                        setState(() {
                          textPass = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          onPressed: () {
                            formKey.currentState.save();
                            setState(() {
                              result = encode(textPass.trim(), textValue.trim());
                              copyToClipboard(context, result);
                            });
                          },
                          child: Text("Encode", style: TextStyle(fontSize: 20)),
                        ),
                        FlatButton(
                          onPressed: () {
                            formKey.currentState.save();
                            setState(() {
                              result = decode(textPass.trim(), textValue.trim());
                            });
                          },
                          child: Text("Decode", style: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                    SelectableText(
                      result ?? '',
                      style: TextStyle(fontSize: 30),
                    )

                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
  copyToClipboard(context, result){
    FlutterClipboard.copy(result).then((result) {
      final snackBar = SnackBar(
        content: Text('Copied to Clipboard'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {},
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }
}
