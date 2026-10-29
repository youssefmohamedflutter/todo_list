import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

const Color primaryColor = Color(0xFF6558F5);
const Color backgroundColor = Color(0xFFF7F8FC);
const Color headingColor = Color(0xFF20213A);
const Color subtitleColor = Color(0xFF898A9C);

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Tasks',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const TodoHomePage(),
    );
  }
}

class TodoTask {
  final String title;
  bool isCompleted;

  TodoTask({required this.title, this.isCompleted = false});
}

// ==================== HOME PAGE ====================

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final List<TodoTask> tasks = [
    TodoTask(title: 'Review Flutter fundamentals'),
    TodoTask(title: 'Complete UI design'),
    TodoTask(title: 'Read a new chapter'),
  ];

  Future<void> _openAddTaskScreen() async {
    final String? newTask = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskPage()),
    );

    if (!mounted) return;

    if (newTask != null && newTask.trim().isNotEmpty) {
      setState(() {
        tasks.insert(0, TodoTask(title: newTask.trim()));
      });
    }
  }

  void _toggleTask(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int remainingTasks = tasks.where((task) => !task.isCompleted).length;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Header
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAE8FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.checklist_rounded,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Tasks',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: headingColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Organize your day',
                          style: TextStyle(fontSize: 14, color: subtitleColor),
                        ),
                      ],
                    ),
                  ),
                  const CircleAvatar(
                    radius: 23,
                    backgroundColor: Color(0xFFEAE8FF),
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              const Text(
                'Today',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: headingColor,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                '$remainingTasks tasks to focus on',
                style: const TextStyle(fontSize: 14, color: subtitleColor),
              ),

              const SizedBox(height: 20),

              // Task list
              Expanded(
                child: tasks.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: tasks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          return _buildTaskCard(tasks[index], index);
                        },
                      ),
              ),

              // Add task button
              Padding(
                padding: const EdgeInsets.only(bottom: 16, top: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton.icon(
                    onPressed: _openAddTaskScreen,
                    icon: const Icon(Icons.add_rounded, size: 25),
                    label: const Text(
                      'Add Task',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFEAE8FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.task_alt_rounded,
                size: 52,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No tasks yet',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: headingColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add a task to get started!',
              textAlign: TextAlign.center,
              style: TextStyle(color: subtitleColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(TodoTask task, int index) {
    const List<Color> colors = [
      Color(0xFFEAE8FF),
      Color(0xFFE2F5EE),
      Color(0xFFFFEBD9),
    ];

    const List<Color> iconColors = [
      primaryColor,
      Color(0xFF25A878),
      Color(0xFFEF9A45),
    ];

    final int colorIndex = index % colors.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEFEFF5)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => _toggleTask(index),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: task.isCompleted
                    ? const Color(0xFFE2F5EE)
                    : colors[colorIndex],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                task.isCompleted
                    ? Icons.check_circle_rounded
                    : Icons.circle_outlined,
                color: task.isCompleted
                    ? const Color(0xFF25A878)
                    : iconColors[colorIndex],
                size: 25,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: task.isCompleted
                    ? subtitleColor
                    : const Color(0xFF303149),
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: Color(0xFF9B9CAD),
            ),
            onSelected: (value) {
              if (value == 'delete') {
                _deleteTask(index);
              } else if (value == 'toggle') {
                _toggleTask(index);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'toggle',
                child: Text(
                  task.isCompleted ? 'Mark as incomplete' : 'Mark as completed',
                ),
              ),
              const PopupMenuItem(value: 'delete', child: Text('Delete task')),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== ADD TASK PAGE ====================

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _saveTask() {
    final String task = _taskController.text.trim();

    if (task.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a task name')));
      return;
    }

    Navigator.pop(context, task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: headingColor,
          ),
        ),
        title: const Text(
          'Add New Task',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: headingColor,
          ),
        ),
        centerTitle: true,
      ),

      // The body resizes when the keyboard appears.
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Scrollable content has bounded height via Expanded.
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Illustration
                      Center(
                        child: Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAE8FF),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: const Icon(
                            Icons.edit_note_rounded,
                            size: 65,
                            color: primaryColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        'What needs to be done?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: headingColor,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Write down your task and keep your day organized.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: subtitleColor,
                        ),
                      ),

                      const SizedBox(height: 28),

                      const Text(
                        'Task name',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF303149),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: _taskController,
                        autofocus: true,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _saveTask(),
                        decoration: InputDecoration(
                          hintText: 'Enter your task...',
                          hintStyle: const TextStyle(
                            color: Color(0xFFAAABBA),
                            fontSize: 15,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(
                            Icons.edit_outlined,
                            color: primaryColor,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: Color(0xFFE6E6F0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: Color(0xFFE6E6F0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: primaryColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Save button remains outside the scroll view.
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Save Task',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
