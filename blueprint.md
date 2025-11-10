# ToDoNote Blueprint

## Overview

ToDoNote is a simple and beautiful To-Do list application for Flutter. It helps users organize their tasks, set due dates, and receive notifications. The app features a modern, clean UI with both light and dark themes.

## Design & Features

### Theming

*   **Modern Theme:** The app uses a modern theme with a clean and spacious layout.
*   **Light & Dark Modes:** ToDoNote supports both light and dark themes, which can be toggled by the user.
*   **Custom Fonts:** The app uses Google Fonts (`Oswald`, `Roboto Condensed`, and `Open Sans`) to create a unique and readable typography.
*   **Consistent Styling:** The `ThemeData` is used to ensure consistent styling for all widgets, including `AppBar`, `Card`, `Dialog`, and `FloatingActionButton`.

### Task Management

*   **Add Tasks:** Users can add new tasks with a title and an optional due date.
*   **View Tasks:** Tasks are displayed in two tabs: "Active" and "Completed".
*   **Complete Tasks:** Users can mark tasks as complete by tapping on them.
*   **Due Date Notifications:** The app schedules local notifications for tasks with a due date.
*   **Task Editing:** Users can edit existing tasks by tapping the edit button, which opens a pre-filled dialog.
*   **Task Deletion:** Users can delete tasks by tapping the delete button.
*   **Task Prioritization:** Users can mark tasks as "important," which visually distinguishes them with a yellow border and moves them to the top of the task list.

### UI Components

*   **`TaskListItem`:** A custom widget that displays a task with a checkbox, title, and due date. The card has a modern, lifted design with a subtle shadow.
*   **`AddTaskDialog`:** A styled dialog for adding new tasks. The text fields and buttons are themed to match the app's design.
*   **`EmptyTaskList`:** A helpful message that appears when a task list is empty.

### Performance

*   **Optimized for Performance:** The app is optimized to prevent unnecessary widget rebuilds, ensuring a smooth and responsive user experience.
*   **`const` Widgets:** Static widgets are declared as `const` to improve performance.
*   **Isolated State:** The `Consumer` widget is used to isolate theme-dependent widgets, preventing unnecessary rebuilds of the entire screen.

## Next Steps

*   **Firebase Integration:** The next step is to integrate Firebase to enable cloud storage and real-time data synchronization.
