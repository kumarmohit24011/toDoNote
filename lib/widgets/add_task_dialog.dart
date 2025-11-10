
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(String, DateTime?, bool) onAddTask;
  final Task? task;

  const AddTaskDialog({super.key, required this.onAddTask, this.task});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _controller = TextEditingController();
  DateTime? _selectedDate;
  bool _isImportant = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _controller.text = widget.task!.title;
      _selectedDate = widget.task!.dueDate;
      _isImportant = widget.task!.isImportant;
    }
  }

  Future<void> _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(2101),
    );
    if (pickedDate == null) {
      return;
    }
    // ignore: use_build_context_synchronously
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate ?? now),
    );
    if (pickedTime == null) {
      return;
    }
    setState(() {
      _selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Task' : 'New Task', style: Theme.of(context).textTheme.titleLarge),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter task title'),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Text('Due Date', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          InkWell(
            onTap: _presentDatePicker,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 20, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Not set'
                          : DateFormat('MMM d, yyyy, h:mm a').format(_selectedDate!),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: _isImportant,
                onChanged: (value) {
                  setState(() {
                    _isImportant = value ?? false;
                  });
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),
              const Text('Mark as Important'),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: Theme.of(context).textTheme.labelLarge),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onAddTask(_controller.text, _selectedDate, _isImportant);
              Navigator.pop(context);
            }
          },
          child: Text(isEditing ? 'Save' : 'Add Task', style: Theme.of(context).textTheme.labelLarge),
        ),
      ],
    );
  }
}
