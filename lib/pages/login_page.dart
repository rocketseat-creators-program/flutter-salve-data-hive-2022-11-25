import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _value = false;
  late Box box;
  final controllerUser = TextEditingController();
  final controllerPass = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    box = await Hive.openBox('login');
    //buscar aqui
    controllerUser.text = box.get('user') ?? '';
    controllerPass.text = box.get('pass') ?? '';
    setState(() {
      _value = box.get('remember') ?? false;
    });
  }

  Widget _buildLogin() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(10),
        height: 300,
        child: Column(
          children: [
            TextFormField(
              controller: controllerUser,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Usuário'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: controllerPass,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Senha'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CheckboxListTile(
                title: const Text('Lembrar'),
                value: _value,
                onChanged: (value) {
                  setState(() {
                    _value = !_value;
                  });
                }),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  if (_value) {
                    box.put('user', controllerUser.text);
                    box.put('pass', controllerPass.text);
                    box.put('remember', _value);
                  } else {
                    box.delete('user');
                    box.delete('pass');
                    box.delete('remember');
                  }
                },
                child: const Text('Logar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: _buildLogin(),
    );
  }
}
