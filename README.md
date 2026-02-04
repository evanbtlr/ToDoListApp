# 📱 ToDo List App

A simple iOS task management application with initial data loading from API and local storage.

![Swift](https://img.shields.io/badge/Swift-5.5+-orange.svg)
![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![Architecture](https://img.shields.io/badge/Architecture-VIPER-brightgreen.svg)

## ✨ Features

- ✅ **View tasks** sorted by date
- ➕ **Add/Edit** tasks with title, description, and status
- 🔍 **Real-time search**
- ❌ **Delete** by swiping
- ✅ **Mark as completed** via toggle
- 🔄 **Pull-to-refresh** for updates
- 📱 **Modern UI** with dark mode support

## 🏗️ Architecture

The app is built using the **VIPER** architecture:
- **View** - displays data
- **Interactor** - business logic and data handling
- **Presenter** - mediator between View and Interactor
- **Entity** - data models
- **Router** - navigation between screens

**Modules:**
1. `TodoList` - main screen with task list
2. `TodoEdit` - create/edit task screen

## 🛠️ Technologies

- **Swift 5.5+** - main language
- **UIKit** - interface building
- **CoreData** - local storage
- **GCD** - multithreading
- **URLSession** - network requests
- **VIPER** - application architecture

## 🚀 Installation

1. Clone the repository:
```bash
git clone https://github.com/evanbtlr/ToDoListApp.git
```

2. Open `ToDoListApp.xcodeproj` in Xcode 26+

3. Build and run the project (Cmd + R)

## 📁 Project Structure

```
TodoListApp/
├── Modules/          # VIPER modules (TodoList, EditTodo)
├── Core/            # Core components
│   ├── Data/        # CoreData manager and models
│   ├── Network/     # Network layer
│   └── Extensions/  # Extensions
├── Resources/       # App resources
└── Tests/           # Unit and UI tests
```

## 🧪 Testing

The project includes:
- **Unit tests** for CoreData, network layer, and business logic
- **UI tests** for main user scenarios
- **Code coverage > 85%**

Run tests: `Cmd + U` in Xcode

## 🔄 Key Features

**Data Loading:**
- Loads 30 tasks from [dummyjson.com/todos](https://dummyjson.com/todos) on first launch
- All subsequent launches use local data
- Works offline after initial load

**Performance:**
- All data operations in background threads
- UI never blocks
- Optimized CoreData usage

## 📱 Requirements

- **iOS 18.6+**
- **iPhone/iPad** (adaptive interface supported)
- **Xcode 26.2+** for building
