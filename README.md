# Personal Task Manager

A Flutter app for creating tasks, organising work and tracking progress. It was built as a beginner-friendly project to practise Flutter UI, state management and local data storage.

## Features

- Create, view, edit and delete tasks
- Each task has a title, description, due date and priority (low, medium, high)
- Change a task's status between **To Do**, **In Progress** and **Completed**, either in the edit form or from a quick menu on the task card
- Search tasks by title or description
- Filter tasks by status
- Form validation (a title is required)
- Loading spinner while tasks load
- Delete confirmation popup
- Error messages shown in snackbars when saving, updating or deleting fails
- Tasks are saved on the device, so they are still there after the app is closed

## Tech stack

| Part | Choice |
|---|---|
| Framework | Flutter and Dart |
| State management | Provider |
| Database | SQLite through `sqflite` |
| Desktop support | `sqflite_common_ffi` |

## Project structure

```
lib/
  main.dart                      App entry point, sets up the database and Provider
  models/
    task.dart                    The Task class, with TaskStatus and TaskPriority enums
  services/
    database_service.dart        All database code (create, read, update, delete)
  provider/
    task_provider.dart           Holds the task list, search text and status filter
  screens/
    task_list_screen.dart        Main screen: search box, filter chips and task list
    task_form_screen.dart        Form used to add and edit a task
  widgets/
    task_card.dart               One task shown as a card
```

## How it works

1. `DatabaseService` is the only class that talks to the database.
2. `TaskProvider` calls the database service and keeps the current list of tasks in memory. When something changes, it tells the screens to rebuild.
3. The screens read from `TaskProvider` and show the data. They never touch the database directly.

## Getting started

### Requirements

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (run `flutter doctor` to check your setup)
- For Windows desktop: Visual Studio with the "Desktop development with C++" workload

### Run the app

```
git clone https://github.com/GreatOwumi/personaltaskmanager.git
cd personaltaskmanager
flutter pub get
flutter run -d windows
```

Use `flutter devices` to see which devices are available, and pass the one you want after `-d`.

## Current status

- Tested on Windows desktop.
- Android and iOS are supported by Flutter and the database code is written to work there, but the app has not been tested on those devices yet.

## Possible next steps

- Firebase Authentication, so each user has a private task list
- Sync tasks to the cloud (Firestore)
- Test on Android and iOS devices
- Add automated tests

## Scope

This app is kept deliberately small. Team collaboration, chat, push notifications and recurring tasks are not included.

## Author

Built by Great Owumi ([GreatOwumi](https://github.com/GreatOwumi)).