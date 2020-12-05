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
  String encrypted;
  var formKey = GlobalKey<FormState>();
  var formKey2 = GlobalKey<FormState>();
  decode(String password){
    var aesEncrypter = AesCrypt(key: CryptKey().genFortuna(), padding: PaddingAES.pkcs7);
    String decrypted = aesEncrypter.gcm.decrypt(enc: encrypted, iv: password);
    return decrypted;
  }
  encode(String password){
    var aesEncrypter = AesCrypt(key: CryptKey().genFortuna(), padding: PaddingAES.pkcs7);
    encrypted = aesEncrypter.gcm.encrypt(inp: 'somedatahere', iv: password);
    return encrypted;
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "AES Encryption",
              style: TextStyle(fontSize: 30),
            ),
            Form(
              key: formKey,
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter the value'),
                onSaved: (String value) {
                  setState(() {
                    textValue = value;
                  });
                },
              ),
            ),
            Form(
              key: formKey2,
              child: TextFormField(
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  onPressed: () {
                    formKey.currentState.save();
                    formKey2.currentState.save();
                  },
                  child: Text("Encode", style: TextStyle(fontSize: 20)),
                ),
                FlatButton(
                  onPressed: () {
                    formKey.currentState.save();
                    formKey2.currentState.save();
                  },
                  child: Text("Decode", style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
            Text(textValue + textPass),
            TextField(
              enabled: false,
              maxLines: 15,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
