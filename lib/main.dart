
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentListApp());
}

// ======================================================
// MODELOS
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

class Task {
  final int id;
  String title;
  String description;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
  });
}

// ======================================================
// APLICAÇÃO
// ======================================================

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
        onThemeChanged: (value) {
          setState(() {
            darkMode = value;
          });
        },
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
  int nextTaskId = 4;

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

  final List<Task> tasks = [
    Task(
      id: 1,
      title: 'Estudar Flutter',
      description: 'Rever os widgets e formulários.',
    ),
    Task(
      id: 2,
      title: 'Fazer exercício',
      description: 'Praticar os exercícios da aula.',
    ),
    Task(
      id: 3,
      title: 'Entregar projeto',
      description: 'Finalizar e entregar o projeto.',
    ),
  ];

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
  // ESTUDANTES
  // ======================================================

  Future<void> addStudent() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const NewStudentDialog(),
    );

    if (!mounted || result == null) return;

    setState(() {
      students.add(
        Student(
          id: nextStudentId++,
          name: result['name']!,
          number: result['number']!,
          course: result['course']!,
        ),
      );
    });

    showMessage('Estudante adicionado com sucesso!');
  }

  Future<void> deleteStudent(Student student) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar estudante'),
        content: Text(
          'Tens a certeza de que queres eliminar ${student.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (!mounted || confirm != true) return;

    setState(() {
      students.removeWhere((item) => item.id == student.id);
    });

    showMessage('Estudante eliminado.');
  }

  void showStudentDetails(Student student) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
              value: student.completed ? 'Concluído' : 'Por concluir',
            ),
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

  // ======================================================
  // TAREFAS — CRIAR
  // ======================================================

  Future<void> addTask() async {
    final result = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (_) => const TaskFormPage(),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      tasks.add(
        Task(
          id: nextTaskId++,
          title: result.title,
          description: result.description,
          isCompleted: false,
        ),
      );
    });

    showMessage('Tarefa adicionada com sucesso!');
  }

  // ======================================================
  // TAREFAS — EDITAR
  // ======================================================

  Future<void> editTask(Task task) async {
    final result = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (_) => TaskFormPage(task: task),
      ),
    );

    if (!mounted || result == null) return;

    final index = tasks.indexWhere((item) => item.id == task.id);

    if (index == -1) return;

    setState(() {
      tasks[index] = Task(
        id: task.id,
        title: result.title,
        description: result.description,
        isCompleted: task.isCompleted,
      );
    });

    showMessage('Tarefa atualizada com sucesso!');
  }

  // ======================================================
  // TAREFAS — CONCLUIR
  // ======================================================

  void toggleTask(Task task, bool? value) {
    setState(() {
      task.isCompleted = value ?? false;
    });
  }

  // ======================================================
  // TAREFAS — ELIMINAR
  // ======================================================

  Future<void> deleteTask(Task task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar tarefa'),
        content: Text(
          'Queres eliminar "${task.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (!mounted || confirm != true) return;

    setState(() {
      tasks.removeWhere((item) => item.id == task.id);
    });

    showMessage('Tarefa eliminada.');
  }

  // ======================================================
  // NAVEGAR PARA DETALHES
  // ======================================================

  Future<void> openTaskDetails(Task task) async {
    final action = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailPage(task: task),
      ),
    );

    if (!mounted) return;

    if (action == 'edit') {
      await editTask(task);
    } else if (action == 'delete') {
      await deleteTask(task);
    }
  }

  // ======================================================
  // HOME
  // ======================================================

  Widget buildHomePage() {
    final completedStudents =
        students.where((student) => student.completed).length;

    final completedTaskCount =
        tasks.where((task) => task.isCompleted).length;

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
              Icon(Icons.school, color: Colors.white, size: 42),
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
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Resumo',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
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
            subtitle: const Text('Consultar e adicionar estudantes'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => setState(() => selectedIndex = 1),
          ),
        ),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.checklist),
            ),
            title: const Text('Gerir tarefas'),
            subtitle: const Text('Criar, consultar e editar tarefas'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => setState(() => selectedIndex = 2),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Tarefas recentes',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (tasks.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text('Ainda não existem tarefas.'),
              ),
            ),
          )
        else
          ...tasks.take(3).map(
            (task) => Card(
              child: ListTile(
                leading: Icon(
                  task.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                ),
                title: Text(task.title),
                subtitle: Text(
                  task.isCompleted ? 'Concluída' : 'Por concluir',
                ),
                onTap: () => openTaskDetails(task),
              ),
            ),
          ),
      ],
    );
  }

  // ======================================================
  // LISTA DE ESTUDANTES
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
              child: Text(student.name[0].toUpperCase()),
            ),
            title: Text(
              student.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
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
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'details',
                  child: Text('Detalhes'),
                ),
                PopupMenuItem(
                  value: 'completed',
                  child: Text(
                    student.completed
                        ? 'Marcar por concluir'
                        : 'Marcar concluído',
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Eliminar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ======================================================
  // LISTA DE TAREFAS
  // ======================================================

  Widget buildTasksPage() {
    if (tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.task_alt, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Ainda não existem tarefas.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Cria a tua primeira tarefa para começar.'),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: addTask,
                icon: const Icon(Icons.add),
                label: const Text('Nova tarefa'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];

        return Card(
          child: ListTile(
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (value) => toggleTask(task, value),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Text(
              task.description.isEmpty
                  ? (task.isCompleted ? 'Concluída' : 'Por concluir')
                  : task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => openTaskDetails(task),
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
            leading: CircleAvatar(child: Icon(Icons.settings)),
            title: Text('Definições'),
            subtitle: Text('Personaliza a aplicação'),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Modo escuro'),
            subtitle: const Text('Alterar o tema da aplicação'),
            value: widget.darkMode,
            onChanged: widget.onThemeChanged,
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('Total de estudantes'),
            trailing: Text('${students.length}'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.checklist),
            title: const Text('Total de tarefas'),
            trailing: Text('${tasks.length}'),
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
                  onPressed: selectedIndex == 1 ? addStudent : addTask,
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
// FORMULÁRIO DE ESTUDANTE
// ======================================================

class NewStudentDialog extends StatefulWidget {
  const NewStudentDialog({super.key});

  @override
  State<NewStudentDialog> createState() => _NewStudentDialogState();
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
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Navigator.pop(context, <String, String>{
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
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Introduz o nome.'
                        : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Introduz o número.'
                        : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(
                  labelText: 'Curso',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Introduz o curso.'
                        : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}

// ======================================================
// FORMULÁRIO DE TAREFA — NOVA E EDIÇÃO
// ======================================================

class TaskFormPage extends StatefulWidget {
  final Task? task;

  const TaskFormPage({super.key, this.task});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.task?.title ?? '',
    );

    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final task = Task(
      id: widget.task?.id ?? 0,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      isCompleted: widget.task?.isCompleted ?? false,
    );

    Navigator.pop(context, task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar tarefa' : 'Nova tarefa'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  isEditing ? Icons.edit_note : Icons.add_task,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _titleController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    labelText: 'Título *',
                    hintText: 'Ex.: Estudar Flutter',
                    prefixIcon: Icon(Icons.title),
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
                  minLines: 3,
                  maxLines: 6,
                  maxLength: 500,
                  decoration: const InputDecoration(
                    labelText: 'Descrição (opcional)',
                    hintText: 'Descreve a tarefa...',
                    prefixIcon: Icon(Icons.description_outlined),
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _saveTask,
                  icon: Icon(isEditing ? Icons.save : Icons.add),
                  label: Text(
                    isEditing ? 'Guardar alterações' : 'Criar tarefa',
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ======================================================
// DETALHES DA TAREFA
// ======================================================

class TaskDetailPage extends StatelessWidget {
  final Task task;

  const TaskDetailPage({
    super.key,
    required this.task,
  });

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar tarefa'),
        content: Text('Queres eliminar "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (context.mounted && confirm == true) {
      Navigator.pop(context, 'delete');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da tarefa'),
        actions: [
          IconButton(
            tooltip: 'Editar tarefa',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.pop(context, 'edit'),
          ),
          IconButton(
            tooltip: 'Eliminar tarefa',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      task.isCompleted
                          ? Icons.check_circle
                          : Icons.assignment_outlined,
                      size: 48,
                      color: task.isCompleted
                          ? Colors.green
                          : theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      task.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Descrição',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      task.description.isEmpty
                          ? 'Sem descrição.'
                          : task.description,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Estado',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          task.isCompleted
                              ? Icons.check_circle
                              : Icons.pending_outlined,
                          color: task.isCompleted
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          task.isCompleted ? 'Concluída' : 'Por concluir',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                task.isCompleted = !task.isCompleted;
                Navigator.pop(context, 'refresh');
              },
              icon: Icon(
                task.isCompleted
                    ? Icons.undo
                    : Icons.check_circle_outline,
              ),
              label: Text(
                task.isCompleted
                    ? 'Marcar por concluir'
                    : 'Marcar como concluída',
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context, 'edit'),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Editar tarefa'),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _confirmDelete(context),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Eliminar tarefa'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
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
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
// ITEM DE DETALHE DO ESTUDANTE
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
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
