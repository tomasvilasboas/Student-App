
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentCardApp());
}

class StudentCardApp extends StatelessWidget {
  const StudentCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cartão de Estudante',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF3F6FA),
      ),
      home: const StudentPage(),
    );
  }
}

class StudentPage extends StatelessWidget {
  const StudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF101A2C),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Cartão de Estudante',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 5,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PERFIL DO ESTUDANTE',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Center(
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Color(0xFFD9F3EF),
                      child: Icon(
                        Icons.person,
                        size: 58,
                        color: Color(0xFF087F73),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Center(
                    child: Text(
                      'Tomás Vilas Boas',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF101A2C),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Center(
                    child: Text(
                      'Desenvolvimento de Software',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Divider(),

                  const SizedBox(height: 12),

                  const Row(
                    children: [
                      Icon(
                        Icons.school_outlined,
                        color: Colors.teal,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Estudante',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const Row(
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        color: Colors.teal,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Cartão de estudante digital',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Perfil do estudante'),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text('Nome: Tomás Vilas Boas'),
                                SizedBox(height: 8),
                                Text(
                                  'Curso: Desenvolvimento de Software',
                                ),
                                SizedBox(height: 8),
                                Text('Estado: Estudante'),
                                 SizedBox(height: 8),
                                Text(
                                  'Número: 67',
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context),
                                child: const Text('Fechar'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.person_outline),
                      label: const Text('Ver perfil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF087F73),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
