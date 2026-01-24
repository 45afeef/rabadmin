import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rab_dio/rab_dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env"); // Specify the path if not in root
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Response<Token>? result;

  Future<void> _loginUser() async {
    Dio dio = Dio(BaseOptions(baseUrl: dotenv.env['API_URL'] ?? ''));

    RabDio rab = RabDio(dio: dio);

    LoginApi loginApi = rab.getLoginApi();

    Response<Token> res = await loginApi.loginLoginAccessToken(
      grantType: dotenv.env['GRANDTYPE'] ?? '',
      username: dotenv.env['PASSWORD'] ?? '',
      password: dotenv.env['USERNAME'] ?? '',
    );

    setState(() {
      result = res;
    });

    result?.data?.accessToken;

    print(res);
    print("Afeef is doing this.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [Text(result.toString())],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loginUser,
        tooltip: 'Get the user',
        child: const Icon(Icons.add),
      ),
    );
  }
}
