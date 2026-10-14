
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentListApp());
}

// MODELO
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

// DADOS SIMULADOS
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
      course: 'Redes',
    ),
    Student(
      id: 3,
      name: 'Inês Lopes',
      number: '2024003',
      course: 'Cibersegurança',
    ),
  ];
}

// APLICAÇÃO
class StudentListApp extends StatefulWidget {
  const StudentListApp({super.key});

  @override
  State<StudentListApp> createState() => _StudentListAppState();
}

class _StudentListAppState extends State<StudentListApp> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Management',
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF2F5F9),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
      ),
      home: StudentsPage(
        darkMode: darkMode,
        onThemeChanged: (value) {
          setState(() => darkMode = value);
        },
      ),
    );
  }
}

// PÁGINA PRINCIPAL E NAVEGAÇÃO
class StudentsPage extends StatefulWidget {
  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;

  const StudentsPage({
    super.key,
    required this.darkMode,
    required this.onThemeChanged,
  });

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  int selectedIndex = 0;
  bool loading = true;
  List<Student> students = [];
  int nextId = 4;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await loadStudents();

    if (!mounted) return;

    setState(() {
      students = data;
      loading = false;
    });
  }

  Future<void> addStudent() async {
    final nameController = TextEditingController();
    final numberController = TextEditingController();
    final courseController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    final result = await showDialog<Student>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Novo estudante'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome completo',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Introduz o nome'
                            : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: numberController,
                    decoration: const InputDecoration(
                      labelText: 'Número de estudante',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Introduz o número'
                            : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: courseController,
                    decoration: const InputDecoration(
                      labelText: 'Curso',
                      prefixIcon: Icon(Icons.school_outlined),
                    ),
                    validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Introduz o curso'
                            : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;

                final newStudent = Student(
                  id: nextId,
                  name: nameController.text.trim(),
                  number: numberController.text.trim(),
                  course: courseController.text.trim(),
                );

                Navigator.pop(dialogContext, newStudent);
              },
              child: const Text('Criar'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    numberController.dispose();
    courseController.dispose();

    if (result == null || !mounted) return;

    setState(() {
      students.add(result);
      nextId++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${result.name} foi adicionado.')),
    );
  }

  Future<void> deleteStudent(Student student) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar estudante?'),
        content: Text(
          'Queres eliminar ${student.name} da lista?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() {
      students.removeWhere((s) => s.id == student.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${student.name} foi eliminado.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        students: students,
        loading: loading,
        onViewStudents: () => setState(() => selectedIndex = 1),
      ),
      StudentsListPage(
        students: students,
        loading: loading,
        onAdd: addStudent,
        onDelete: deleteStudent,
      ),
      SettingsPage(
        darkMode: widget.darkMode,
        onThemeChanged: widget.onThemeChanged,
        studentCount: students.length,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF10243A),
        foregroundColor: Colors.white,
        title: const Text(
          'Student Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      floatingActionButton: selectedIndex == 1 && !loading
          ? FloatingActionButton.extended(
              onPressed: addStudent,
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.person_add),
              label: const Text('Adicionar'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Estudantes',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Definições',
          ),
        ],
      ),
    );
  }
}

// PÁGINA INICIAL
class HomePage extends StatelessWidget {
  final List<Student> students;
  final bool loading;
  final VoidCallback onViewStudents;

  const HomePage({
    super.key,
    required this.students,
    required this.loading,
    required this.onViewStudents,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF10243A),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.school, color: Colors.tealAccent, size: 40),
              SizedBox(height: 16),
              Text(
                'Bem-vindo!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Gere os teus estudantes de forma simples.',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'RESUMO',
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFE0F2F1),
              child: Icon(Icons.people, color: Colors.teal),
            ),
            title: const Text('Total de estudantes'),
            subtitle: Text(
              loading ? 'A carregar...' : '${students.length} estudantes',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: onViewStudents,
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: onViewStudents,
          icon: const Icon(Icons.list_alt),
          label: const Text('Ver todos os estudantes'),
        ),
      ],
    );
  }
}

// LISTA DE ESTUDANTES
class StudentsListPage extends StatelessWidget {
  final List<Student> students;
  final bool loading;
  final VoidCallback onAdd;
  final ValueChanged<Student> onDelete;

  const StudentsListPage({
    super.key,
    required this.students,
    required this.loading,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (students.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.people_outline,
                size: 64,
                color: Colors.teal,
              ),
              const SizedBox(height: 16),
              const Text('Ainda não existem estudantes.'),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                label: const Text('Criar estudante'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 90),
      children: [
        Text(
          'ESTUDANTES INSCRITOS (${students.length})',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 12),
        ...students.map(
          (student) => StudentCard(
            student: student,
            onDelete: () => onDelete(student),
          ),
        ),
      ],
    );
  }
}

// CARTÃO REUTILIZÁVEL
class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onDelete;

  const StudentCard({
    super.key,
    required this.student,
    required this.onDelete,
  });

  void showDetails(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const CircleAvatar(
          radius: 32,
          child: Icon(Icons.person, size: 36),
        ),
        title: Text(student.name, textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailItem(label: 'ID', value: '${student.id}'),
            DetailItem(label: 'Número', value: student.number),
            DetailItem(label: 'Curso', value: student.course),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Theme.of(context).cardTheme.color,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(
          left: 14,
          right: 4,
          top: 6,
          bottom: 6,
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade50,
          child: const Icon(Icons.person, color: Colors.teal),
        ),
        title: Text(
          student.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${student.number} • ${student.course}'),
        onTap: () => showDetails(context),
        trailing: IconButton(
          tooltip: 'Eliminar estudante',
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline, color: Colors.red),
        ),
      ),
    );
  }
}

// COMPONENTE REUTILIZÁVEL DE DETALHES
class DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const DetailItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

// DEFINIÇÕES
class SettingsPage extends StatelessWidget {
  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;
  final int studentCount;

  const SettingsPage({
    super.key,
    required this.darkMode,
    required this.onThemeChanged,
    required this.studentCount,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'DEFINIÇÕES DA APLICAÇÃO',
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: SwitchListTile(
            secondary: Icon(
              darkMode ? Icons.dark_mode : Icons.light_mode,
              color: Colors.teal,
            ),
            title: const Text('Modo escuro'),
            subtitle: const Text('Alterar a aparência da aplicação'),
            value: darkMode,
            onChanged: onThemeChanged,
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.people, color: Colors.teal),
            title: const Text('Estudantes registados'),
            subtitle: Text('$studentCount estudantes'),
          ),
        ),
        Card(
          child: const ListTile(
            leading: Icon(Icons.info_outline, color: Colors.teal),
            title: Text('Sobre a aplicação'),
            subtitle: Text(
              'Student Management\n'
              'Aplicação Flutter com Material 3.',
            ),
          ),
        ),
      ],
    );
  }
}
