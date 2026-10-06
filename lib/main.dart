import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),

              const Text(
                'Hello world!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Image.asset(
                'assets/messi.png',
                width: 200,
                height: 200,
              ),

              Card(
                margin: const EdgeInsets.all(20),
                elevation: 5,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Lionel Messi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Nacionalidade: Argentina'),
                      Text('Posição: Avançado'),
                      Text('Bolas de Ouro: 8'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Aperta o botão se ele é o melhor de todos os tempos',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: _incrementCounter,
                child: const Text('Votar Messi'),
              ),

              const SizedBox(height: 15),

              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}