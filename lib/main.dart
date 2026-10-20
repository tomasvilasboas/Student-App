
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentListApp());
}

// ======================================================
// MODELO DE ESTUDANTE
// ======================================================

class Student {
  final int id;
  String name;
  String number;
  String course;
  bool completed;

  Student({
    required this.id,
    required this.name,
    required this.number,
    required this.course,
    this.completed = false,
  });
}

// ======================================================
// APLICAÇÃO E TEMAS
// ======================================================

class StudentListApp extends StatefulWidget {
  const StudentListApp({super.key});

  @override
  State<StudentListApp> createState() => _StudentListAppState();
}

class _StudentListAppState extends State<StudentListApp> {
  bool darkMode = false;

  void changeTheme(bool value) {
    setState(() {
      darkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Management',
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: StudentsPage(
        darkMode: darkMode,
        onThemeChanged: changeTheme,
      ),
    );
  }
}

// ======================================================
// PÁGINA PRINCIPAL
// ======================================================

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
  int nextStudentId = 4;

  final List<Student> students = [
    Student(
      id: 1,
      name: 'Rita Silva',
      number: '2024001',
      course: 'Engenharia Informática',
      completed: true,
    ),
    Student(
      id: 2,
      name: 'João Costa',
      number: '2024002',
      course: 'Sistemas de Informação',
    ),
    Student(
      id: 3,
      name: 'Inês Lopes',
      number: '2024003',
      course: 'Tecnologias de Programação',
    ),
  ];

  final List<Map<String, String>> tasks = [
    {
      'title': 'Estudar Flutter',
      'description': 'Rever os widgets e formulários.',
    },
    {
      'title': 'Fazer exercício',
      'description': 'Praticar os exercícios da aula.',
    },
    {
      'title': 'Entregar projeto',
      'description': 'Finalizar e entregar o projeto.',
    },
  ];

  final List<bool> completedTasks = [false, false, false];

  // ======================================================
  // MENSAGENS
  // ======================================================

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // ======================================================
  // ADICIONAR ESTUDANTE
  // ======================================================

  Future<void> addStudent() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const NewStudentDialog(),
    );

    if (!mounted || result == null) return;

    final name = result['name']?.trim() ?? '';
    final number = result['number']?.trim() ?? '';
    final course = result['course']?.trim() ?? '';

    if (name.isEmpty || number.isEmpty || course.isEmpty) {
      return;
    }

    setState(() {
      students.add(
        Student(
          id: nextStudentId++,
          name: name,
          number: number,
          course: course,
        ),
      );
    });

    showMessage('Estudante adicionado com sucesso!');
  }

  // ======================================================
  // ELIMINAR ESTUDANTE
  // ======================================================

  Future<void> deleteStudent(Student student) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar estudante'),
          content: Text(
            'Tens a certeza de que queres eliminar ${student.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirm != true) return;

    setState(() {
      students.removeWhere((item) => item.id == student.id);
    });

    showMessage('Estudante eliminado.');
  }

  // ======================================================
  // ADICIONAR TAREFA
  // ======================================================

  Future<void> addTask() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const NewTaskDialog(),
    );

    if (!mounted || result == null) return;

    final title = result['title']?.trim() ?? '';
    final description = result['description']?.trim() ?? '';

    if (title.isEmpty) return;

    setState(() {
      tasks.add({
        'title': title,
        'description': description,
      });

      completedTasks.add(false);
    });

    showMessage('Tarefa adicionada com sucesso!');
  }

  // ======================================================
  // ELIMINAR TAREFA
  // ======================================================

  Future<void> deleteTask(int index) async {
    if (index < 0 || index >= tasks.length) return;

    final taskTitle = tasks[index]['title'] ?? 'esta tarefa';

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar tarefa'),
          content: Text('Queres eliminar "$taskTitle"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirm != true) return;
    if (index >= tasks.length) return;

    setState(() {
      tasks.removeAt(index);
      completedTasks.removeAt(index);
    });

    showMessage('Tarefa eliminada.');
  }

  // ======================================================
  // DETALHES DO ESTUDANTE
  // ======================================================

  void showStudentDetails(Student student) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(student.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailItem(
                icon: Icons.numbers,
                label: 'Número',
                value: student.number,
              ),
              const SizedBox(height: 12),
              DetailItem(
                icon: Icons.school_outlined,
                label: 'Curso',
                value: student.course,
              ),
              const SizedBox(height: 12),
              DetailItem(
                icon: Icons.check_circle_outline,
                label: 'Estado',
                value: student.completed
                    ? 'Concluído'
                    : 'Por concluir',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  // ======================================================
  // PÁGINA INICIAL
  // ======================================================

  Widget buildHomePage() {
    final completedStudents =
        students.where((student) => student.completed).length;

    final completedTaskCount =
        completedTasks.where((completed) => completed).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF3949AB),
                Color(0xFF7986CB),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.school,
                color: Colors.white,
                size: 42,
              ),
              SizedBox(height: 16),
              Text(
                'Bem-vindo!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Gere os teus estudantes e acompanha as tuas tarefas.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Resumo',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                icon: Icons.people_alt_outlined,
                title: 'Estudantes',
                value: '${students.length}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                icon: Icons.task_alt,
                title: 'Tarefas',
                value: '${tasks.length}',
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                icon: Icons.school_outlined,
                title: 'Concluídos',
                value: '$completedStudents',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                icon: Icons.check_circle_outline,
                title: 'Feitas',
                value: '$completedTaskCount',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.people_outline),
            ),
            title: const Text('Gerir estudantes'),
            subtitle: const Text(
              'Consultar e adicionar estudantes',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              setState(() {
                selectedIndex = 1;
              });
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.checklist),
            ),
            title: const Text('Gerir tarefas'),
            subtitle: const Text(
              'Adicionar e concluir tarefas',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              setState(() {
                selectedIndex = 2;
              });
            },
          ),
        ),
      ],
    );
  }

  // ======================================================
  // PÁGINA DE ESTUDANTES
  // ======================================================

  Widget buildStudentsPage() {
    if (students.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_outline, size: 60),
            SizedBox(height: 12),
            Text('Ainda não existem estudantes.'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];

        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            leading: CircleAvatar(
              child: Text(
                student.name.isNotEmpty
                    ? student.name[0].toUpperCase()
                    : '?',
              ),
            ),
            title: Text(
              student.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              '${student.number}\n${student.course}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            isThreeLine: true,
            onTap: () => showStudentDetails(student),
            trailing: PopupMenuButton<String>(
              tooltip: 'Opções',
              onSelected: (value) {
                if (value == 'details') {
                  showStudentDetails(student);
                } else if (value == 'delete') {
                  deleteStudent(student);
                } else if (value == 'completed') {
                  setState(() {
                    student.completed = !student.completed;
                  });
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'details',
                  child: Row(
                    children: [
                      Icon(Icons.info_outline),
                      SizedBox(width: 8),
                      Text('Detalhes'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'completed',
                  child: Row(
                    children: [
                      Icon(
                        student.completed
                            ? Icons.undo
                            : Icons.check_circle_outline,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        student.completed
                            ? 'Marcar por concluir'
                            : 'Marcar concluído',
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      SizedBox(width: 8),
                      Text('Eliminar'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ======================================================
  // PÁGINA DE TAREFAS
  // ======================================================

  Widget buildTasksPage() {
    if (tasks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.task_alt, size: 60),
            SizedBox(height: 12),
            Text('Ainda não existem tarefas.'),
            SizedBox(height: 6),
            Text('Carrega no botão + para adicionar uma.'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final title = task['title'] ?? 'Sem título';
        final description = task['description'] ?? '';
        final isCompleted = completedTasks[index];

        return Card(
          child: CheckboxListTile(
            value: isCompleted,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (value) {
              setState(() {
                completedTasks[index] = value ?? false;
              });
            },
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                decoration: isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: description.isEmpty
                ? Text(
                    isCompleted ? 'Concluída' : 'Por concluir',
                  )
                : Text(
                    description,
                    style: TextStyle(
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
            secondary: IconButton(
              tooltip: 'Eliminar tarefa',
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              onPressed: () => deleteTask(index),
            ),
          ),
        );
      },
    );
  }

  // ======================================================
  // DEFINIÇÕES
  // ======================================================

  Widget buildSettingsPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.settings),
            ),
            title: Text('Definições'),
            subtitle: Text('Personaliza a aplicação'),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Modo escuro'),
            subtitle: const Text(
              'Alterar o tema da aplicação',
            ),
            value: widget.darkMode,
            onChanged: widget.onThemeChanged,
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('Total de estudantes'),
            trailing: Text(
              '${students.length}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.checklist),
            title: const Text('Total de tarefas'),
            trailing: Text(
              '${tasks.length}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Text(
            'Student Management\nVersão 1.0.0',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // ======================================================
  // INTERFACE PRINCIPAL
  // ======================================================

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      buildHomePage(),
      buildStudentsPage(),
      buildTasksPage(),
      buildSettingsPage(),
    ];

    const titles = [
      'Início',
      'Estudantes',
      'Tarefas',
      'Definições',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[selectedIndex]),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      floatingActionButton:
          selectedIndex == 1 || selectedIndex == 2
              ? FloatingActionButton.extended(
                  onPressed:
                      selectedIndex == 1 ? addStudent : addTask,
                  icon: const Icon(Icons.add),
                  label: Text(
                    selectedIndex == 1
                        ? 'Novo estudante'
                        : 'Nova tarefa',
                  ),
                )
              : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
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
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Tarefas',
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

// ======================================================
// FORMULÁRIO DE NOVO ESTUDANTE
// Os controladores pertencem exclusivamente a este widget.
// ======================================================

class NewStudentDialog extends StatefulWidget {
  const NewStudentDialog({super.key});

  @override
  State<NewStudentDialog> createState() =>
      _NewStudentDialogState();
}

class _NewStudentDialogState extends State<NewStudentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _courseController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    Navigator.of(context).pop(<String, String>{
      'name': _nameController.text.trim(),
      'number': _numberController.text.trim(),
      'course': _courseController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Novo estudante'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Introduz o nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número',
                  prefixIcon: Icon(Icons.numbers),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Introduz o número.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _courseController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Curso',
                  prefixIcon: Icon(Icons.school_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Introduz o curso.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.add),
          label: const Text('Adicionar'),
        ),
      ],
    );
  }
}

// ======================================================
// FORMULÁRIO DE NOVA TAREFA
// Os controladores pertencem exclusivamente a este widget.
// ======================================================

class NewTaskDialog extends StatefulWidget {
  const NewTaskDialog({super.key});

  @override
  State<NewTaskDialog> createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<NewTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    Navigator.of(context).pop(<String, String>{
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nova tarefa'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Título da tarefa *',
                  hintText: 'Ex.: Estudar Flutter',
                  prefixIcon: Icon(Icons.task_alt),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'O título é obrigatório.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                textCapitalization: TextCapitalization.sentences,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descrição (opcional)',
                  hintText: 'Descreve a tarefa...',
                  prefixIcon: Icon(Icons.description_outlined),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.add),
          label: const Text('Adicionar tarefa'),
        ),
      ],
    );
  }
}

// ======================================================
// CARTÃO DE RESUMO
// ======================================================

class SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// ITEM DE DETALHE
// ======================================================

class DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
