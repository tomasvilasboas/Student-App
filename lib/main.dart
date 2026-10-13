import 'package:flutter/material.dart';

void main() {
  runApp(const StudentListApp());
}

// 1. Criar a classe Student
class Student {
  final int id;
  final String name;
  final String course;

  const Student({
    required this.id,
    required this.name,
    required this.course,
  });
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

  // 2. Criar três objetos Student
  final List<Student> students = const [
    Student(
      id: 1,
      name: 'Rita',
      course: 'Programação',
    ),
    Student(
      id: 2,
      name: 'João',
      course: 'Redes',
    ),
    Student(
      id: 3,
      name: 'Inês',
      course: 'Programação',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // 3. Filtrar os estudantes do curso Programação
    final programmingStudents = students
        .where((s) => s.course == 'Programação')
        .toList();

    // 4. Criar uma lista apenas com os nomes
    final names = programmingStudents
        .map((s) => s.name)
        .toList();

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
                  'Estudantes de Programação',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Lista de nomes filtrados por curso.',
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
              'ESTUDANTES DE PROGRAMAÇÃO',
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
              itemCount: names.length,
              itemBuilder: (context, index) {
                final name = names[index];

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
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text('Curso: Programação'),
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
                            content: Text(name),
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Total de estudantes: ${names.length}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF10243A),
              ),
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