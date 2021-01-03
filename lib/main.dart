import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: Login(),
    theme: ThemeData(),
  ));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus{notSignIn, SignIn}

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String email,password;
  final _key = new GlobalKey<FormState>();

  check(){
    final form = _key.currentState;
    if(form.validate()){
      form.save();
      login();
    }
  }

  login() async{
    final response = await http.post("http://192.168.3.172/apiflutter/login.php",body:{
      "email":email,
      "password":password
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String namaAPI = data['nama'];
    String emailAPI = data['email'];
    String passwordAPI = data['password'];
    String id = data['id'];
    if(value == 1){
      setState(() {
        _loginStatus = LoginStatus.SignIn;
        savePref(value, emailAPI, namaAPI, id);
      });
      print(pesan);
    }else{
      print(pesan);
    }
  }

  savePref(value, email, nama, id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value",value);
      preferences.setString("nama", nama);
      preferences.setString("email", email);
      preferences.setString("id", id);
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.SignIn : LoginStatus.notSignIn;
    });
  }

  SignOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState(){
    super.initState();
    getPref();
  }

  bool _secureText = true;

  showHide(){
    setState(() {
      _secureText = !_secureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context);
    switch(_loginStatus){
      case LoginStatus.notSignIn:
        return Scaffold(
          body: Form(
            key: _key,
            child:Container(
              padding: const EdgeInsets.all(8),
              color: Colors.lightBlue,
              child: ListView(
                  children: <Widget>[
                    SizedBox(height: 20,),
                    Container(
                      width: 100,
                      height: 100,
                      decoration:
                      BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
                      child: Center(
                        child: Icon(Icons.person, size: 50, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text("Selamat Datang", textAlign: TextAlign.center, style: TextStyle(fontSize:20, color:Colors.black),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator:(e){
                        if(e.isEmpty){
                          return "Masukkan Email";
                        }
                      },
                      onSaved: (e)=>email = e,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.person,
                          size: 40,
                        ),
                        hintText: "Masukan Email",
                        labelText: "Email",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator:(e){
                        if(e.isEmpty){
                          return "Masukkan Password";
                        }
                      },
                      onSaved: (e)=>password = e,
                      obscureText: _secureText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.lock,
                          size: 40,
                        ),
                        suffixIcon: IconButton(
                          onPressed: showHide,
                          icon:
                          Icon(_secureText ? Icons.visibility_off : Icons.visibility),
                        ),
                        hintText: "Masukan Password",
                        labelText: "Password",
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        check();
                      },
                      child: Text("Login"),
                      minWidth: 500,
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => Register()));
                      },
                      child: Text("Register"),
                      minWidth: 500,
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                  ]),
            ),
          ),
        );
        break;
      case LoginStatus.SignIn:
        return Home(SignOut);
        break;
    }

  }
}

class Home extends StatefulWidget {
  final VoidCallback SignOut;
  Home(this.SignOut);
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  SignOut(){
    setState(() {
      widget.SignOut();
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.dashboard),
          title: Text("Halaman Pertama"),
          actions: <Widget>[
            Icon(Icons.search),
            IconButton(
              onPressed: (){
                SignOut();
              },
                icon: Icon(Icons.logout),
            ),
          ],
          backgroundColor: Colors.blueGrey,
        ),
      ),
    );
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String nama,email,password;
  final _key = new GlobalKey<FormState>();

  check(){
    final form = _key.currentState;
    if(form.validate()){
      form.save();
      register();
    }
  }

  register() async{
    final response = await http.post("http://192.168.3.172/apiflutter/register.php",body:{
      "nama":nama,
      "email":email,
      "password":password
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if(value == 1){
      setState(() {
        Navigator.pop(context);
        print(pesan);
      });
    }else{
      print(pesan);
    }

  }

  bool _secureText = true;

  showHide(){
    setState(() {
      _secureText = !_secureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child:Container(
          padding: const EdgeInsets.all(8),
          color: Colors.lightBlue,
          child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 20,),
                Container(
                  width: 100,
                  height: 100,
                  decoration:
                  BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
                  child: Center(
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 20,),
                Text("Silahkan Register", textAlign: TextAlign.center, style: TextStyle(fontSize:20, color:Colors.black),
                ),
                TextFormField(
                  validator:(e){
                    if(e.isEmpty){
                      return "Masukkan Nama";
                    }
                  },
                  onSaved: (e)=>nama = e,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        size: 40,
                      ),
                      labelText: "Masukan Nama"),
                ),
                TextFormField(
                  validator:(e){
                    if(e.isEmpty){
                      return "Masukkan Email";
                    }
                  },
                  onSaved: (e)=>email = e,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        size: 40,
                      ),
                      labelText: "Masukan Email"),
                ),
                TextFormField(
                  validator:(e){
                    if(e.isEmpty){
                      return "Masukkan Password";
                    }
                  },
                  onSaved: (e)=>password = e,
                  obscureText: _secureText,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        size: 40,
                      ),
                      labelText: "Masukan Password",
                      suffixIcon: IconButton(
                        onPressed: showHide,
                        icon: Icon(
                            _secureText ? Icons.visibility_off : Icons.visibility),
                      )),
                ),
                MaterialButton(
                    onPressed: () {
                      check();
                    },
                    child: Text("Register"),
                    minWidth: 500,
                    color: Colors.blue,
                    textColor: Colors.white
                ),
              ]),
        ),

      ),
    );
  }
}