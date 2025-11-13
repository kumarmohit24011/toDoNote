import 'package:home_widget/home_widget.dart';
import 'package:myapp/models/task.dart';

class HomeWidgetService {
  static const String _appGroupId = 'group.com.mohitbhardwaj.doNote';

  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId(_appGroupId);
  }

  static Future<void> updateTasks(List<Task> tasks) async {
    final taskList = tasks.map((task) => task.title).join('\n');
    await HomeWidget.saveWidgetData<String>('tasks', taskList);
    await HomeWidget.updateWidget(
      name: 'HomeWidgetProvider',
      iOSName: 'HomeWidgetProvider',
    );
  }
}
