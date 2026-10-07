import 'package:flutter/material.dart';
import 'models/student.dart';
import 'screens/add_student_page.dart';
import 'screens/student_details_page.dart';

void main() {
  runApp(const StudentInformationSystem());
}

class StudentInformationSystem extends StatelessWidget {
  const StudentInformationSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Information System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Student> students = [
    Student(
      id: 1,
      name: 'patrick badap',
      course: 'BS Information Technology',
      yearLevel: 2,
      email: 'patrickbadap@example.com',
    ),
    Student(
      id: 2,
      name: 'uncle dags',
      course: 'BS Information Technology',
      yearLevel: 1,
      email: 'uncle dags@example.com',
    ),
  ];

  final searchController = TextEditingController();
  String query = '';

  List<Student> get filteredStudents {
    final q = query.toLowerCase();
    return students.where((s) {
      return s.name.toLowerCase().contains(q) ||
          s.course.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> addStudent() async {
    final newStudent = await Navigator.push<Student>(
      context,
      MaterialPageRoute(builder: (context) => const AddStudentPage()),
    );
    if (newStudent != null) {
      setState(() {
        students.add(newStudent);
      });
    }
  }

  Future<void> editStudent(Student student) async {
    final updated = await Navigator.push<Student>(
      context,
      MaterialPageRoute(builder: (context) => AddStudentPage(student: student)),
    );
    if (updated != null) {
      setState(() {
        final i = students.indexWhere((s) => s.id == student.id);
        if (i != -1) students[i] = updated;
      });
    }
  }

  Future<void> confirmDelete(Student student) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete\n${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) {
      setState(() {
        students.removeWhere((s) => s.id == student.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = filteredStudents;

    return Scaffold(
      appBar: AppBar(title: const Text('Student Information System')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: searchController,
              onChanged: (value) => setState(() => query = value),
              decoration: const InputDecoration(
                labelText: 'Search by name or course',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Total Students: ${students.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text('No students found.'))
                : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final student = list[index];
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(student.name),
                        subtitle: Text(
                            '${student.course} • Year ${student.yearLevel}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => editStudent(student),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => confirmDelete(student),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StudentDetailsPage(student: student),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addStudent,
        child: const Icon(Icons.add),
      ),
    );
  }
}