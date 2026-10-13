
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentListApp());
}

class StudentListApp extends StatelessWidget {
  const StudentListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Estudantes',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF2F5F9),
      ),
      home: const StudentsPage(),
    );
  }
}

class StudentsPage extends StatelessWidget {
  const StudentsPage({super.key});

  final List<Map<String, String>> students = const [
    {
      'nome': 'Rita Silva',
      'curso': 'Desenvolvimento de Software',
    },
    {
      'nome': 'João Costa',
      'curso': 'Redes e Sistemas',
    },
    {
      'nome': 'Inês Lopes',
      'curso': 'Cibersegurança',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF10243A),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Lista de Estudantes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF10243A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Os nossos estudantes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Consulta os estudantes e os seus cursos.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'ESTUDANTES INSCRITOS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.teal,
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                final nome = student['nome']!;
                final curso = student['curso']!;

                return Card(
                  elevation: 2,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),

                    leading: CircleAvatar(
                      radius: 27,
                      backgroundColor: Colors.teal.shade50,
                      child: const Icon(
                        Icons.person,
                        color: Colors.teal,
                        size: 30,
                      ),
                    ),

                    title: Text(
                      nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(curso),
                    ),

                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.teal,
                    ),

                    onTap: () {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(nome),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Estudantes',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Definições',
          ),
        ],
        onDestinationSelected: (index) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ['Início', 'Estudantes', 'Definições'][index],
              ),
            ),
          );
        },
      ),
    );
  }
}
