
# Blueprint for ToDoNote App

## Overview

ToDoNote is a simple and clean Flutter application for managing tasks. It allows users to add, view, complete, and delete tasks, with all data stored locally on the device. The app also supports setting due dates for tasks and receiving notifications when a task is due.

## Features

*   **Add Tasks:** Quickly add new tasks with a title.
*   **View Tasks:** See a list of active and completed tasks in separate tabs.
*   **Complete Tasks:** Mark tasks as complete.
*   **Delete Tasks:** Remove tasks from the list.
*   **Local Storage:** Tasks are saved locally using the `shared_preferences` package, so they persist between app launches.
*   **Due Dates:** Set a due date and time for each task.
*   **Notifications:** Receive a notification when a task's due date and time is reached.

## Design and Style

*   **UI:** A modern and clean user interface with a tab-based layout.
*   **State Management:** The app uses the `provider` package for state management, with a `ChangeNotifier` to manage the task list.

## Project Structure

```
lib/
|-- models/
|   `-- task.dart
|-- providers/
|   `-- task_provider.dart
|-- services/
|   `-- notification_service.dart
|-- screens/
|   `-- home_screen.dart
|-- widgets/
|   |-- add_task_dialog.dart
|   `-- task_list.dart
`-- main.dart
```

## Current Plan

1.  **Add Dependencies:** Add `flutter_local_notifications` and `intl` to `pubspec.yaml`.
2.  **Create Notification Service:** Create `lib/services/notification_service.dart` to handle local notifications.
3.  **Initialize Notification Service:** Update `lib/main.dart` to initialize the notification service.
4.  **Update `Task` Model:** Add a `dueDate` field to the `Task` class in `lib/models/task.dart`.
5.  **Update `TaskProvider`:** Modify `lib/providers/task_provider.dart` to handle scheduling and canceling notifications when tasks are added, completed, or deleted.
6.  **Implement UI for Due Dates:** Modify `lib/widgets/add_task_dialog.dart` to include a date and time picker.
7.  **Display Due Dates:** Update `lib/widgets/task_list.dart` to display the due date for each task.
