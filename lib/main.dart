
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentListApp());
}

// Modelo de dados
class Student {
  final int id;
  final String name;
  final String number;
  final String course;

  const Student({
    required this.id,
    required this.name,
    required this.number,
    required this.course,
  });
}

// Dados simulados com Future.delayed
Future<List<Student>> loadStudents() async {
  await Future.delayed(const Duration(milliseconds: 700));

  return const [
    Student(
      id: 1,
      name: 'Rita Silva',
      number: '2024001',
      course: 'Programação',
    ),
    Student(
      id: 2,
      name: 'João Costa',
      number: '2024002',
      course: 'Redes e Sistemas',
    ),
    Student(
      id: 3,
      name: 'Inês Lopes',
      number: '2024003',
      course: 'Cibersegurança',
    ),
  ];
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

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  late final Future<List<Student>> studentsFuture;

  @override
  void initState() {
    super.initState();
    studentsFuture = loadStudents();
  }

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
                  'Consulta os dados e os cursos dos estudantes.',
                  style: TextStyle(color: Colors.white70),
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
            child: FutureBuilder<List<Student>>(
              future: studentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('A carregar estudantes...'),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Erro ao carregar os estudantes.',
                    ),
                  );
                }

                final students = snapshot.data ?? [];

                if (students.isEmpty) {
                  return const Center(
                    child: Text('Não existem estudantes.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    return StudentCard(
                      student: students[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StudentDetailsPage(
                              student: students[index],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Componente reutilizável da lista
class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;

  const StudentCard({
    super.key,
    required this.student,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
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
          student.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '${student.number} • ${student.course}',
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.teal,
        ),
        onTap: onTap,
      ),
    );
  }
}

// Ecrã de detalhes
class StudentDetailsPage extends StatelessWidget {
  final Student student;

  const StudentDetailsPage({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF10243A),
        foregroundColor: Colors.white,
        title: const Text('Detalhes do estudante'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.teal.shade50,
                  child: const Icon(
                    Icons.person,
                    color: Colors.teal,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  student.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                StudentDetailItem(
                  label: 'ID',
                  value: '${student.id}',
                ),
                StudentDetailItem(
                  label: 'Número',
                  value: student.number,
                ),
                StudentDetailItem(
                  label: 'Curso',
                  value: student.course,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Componente reutilizável dos detalhes
class StudentDetailItem extends StatelessWidget {
  final String label;
  final String value;

  const StudentDetailItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(
        Icons.school_outlined,
        color: Colors.teal,
      ),
      title: Text(label),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}
