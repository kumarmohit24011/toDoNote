
# Blueprint for ToDoNote App

## Overview

ToDoNote is a simple and clean Flutter application for managing tasks. It allows users to add, view, complete, and delete tasks, with all data stored locally on the device.

## Features

*   **Add Tasks:** Quickly add new tasks with a title.
*   **View Tasks:** See a list of active and completed tasks in separate tabs.
*   **Complete Tasks:** Mark tasks as complete.
*   **Delete Tasks:** Remove tasks from the list.
*   **Local Storage:** Tasks are saved locally using the `shared_preferences` package, so they persist between app launches.

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
|-- screens/
|   `-- home_screen.dart
|-- widgets/
|   |-- add_task_dialog.dart
|   `-- task_list.dart
`-- main.dart
```

## Current Plan

1.  **Add Dependencies:** Add `provider` and `shared_preferences` to `pubspec.yaml`.
2.  **Create Project Structure:** Create the necessary directories and files.
3.  **Implement `Task` Model:** Define the `Task` class.
4.  **Implement `TaskProvider`:** Manage task state and local storage.
5.  **Implement UI:** Build the main screen, task lists, and dialogs.
6.  **Update `main.dart`:** Set up the app's entry point with the `ChangeNotifierProvider`.
