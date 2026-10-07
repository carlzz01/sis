import 'package:flutter/material.dart';
import '../models/student.dart';

class AddStudentPage extends StatefulWidget {
  final Student? student;

  const AddStudentPage({super.key, this.student});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController courseController;
  late final TextEditingController yearController;
  late final TextEditingController emailController;

  bool get isEditing => widget.student != null;

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    nameController = TextEditingController(text: s?.name ?? '');
    courseController = TextEditingController(text: s?.course ?? '');
    yearController = TextEditingController(text: s?.yearLevel.toString() ?? '');
    emailController = TextEditingController(text: s?.email ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    courseController.dispose();
    yearController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void save() {
    if (!_formKey.currentState!.validate()) return;

    final student = Student(
      id: widget.student?.id ?? DateTime.now().millisecondsSinceEpoch,
      name: nameController.text.trim(),
      course: courseController.text.trim(),
      yearLevel: int.parse(yearController.text.trim()),
      email: emailController.text.trim(),
    );
    Navigator.pop(context, student);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Student' : 'Add Student')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Student Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Name is required'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: courseController,
                  decoration: const InputDecoration(
                    labelText: 'Course',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Course is required'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: yearController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Year Level',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final year = int.tryParse((v ?? '').trim());
                    if (year == null) return 'Enter a valid number';
                    if (year < 1 || year > 6) return 'Year level must be 1-6';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final email = (v ?? '').trim();
                    if (email.isEmpty) return 'Email is required';
                    if (!email.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: save,
                    child: Text(isEditing ? 'Update Student' : 'Save Student'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}