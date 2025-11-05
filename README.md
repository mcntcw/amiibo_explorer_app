# Amiibo Explorer App

A Flutter application that allows users to explore, search, and view data related to Amiibo characters.

---

## Overview

Amiibo Explorer is a cross-platform Flutter app that uses modern libraries and patterns such as BLoC for state management and Dio for network requests.  
It features custom fonts, animations, and a structured architecture designed for scalability.

<img width="3542" height="2214" alt="amiibo_explorer_mockup" src="https://github.com/user-attachments/assets/de98ae57-34e6-4543-bdff-5646bdaeb662" />


---

## Getting Started

### 1. Prerequisites

Before running the application, make sure you have installed:

- Flutter SDK (version 3.9.2 or higher)
- Dart SDK (included with Flutter)
- Android Studio / Xcode (for emulator/simulator support)
- A device or emulator configured properly

To check your Flutter setup, run: 
flutter doctor

### 2. Clone the Repository

git clone https://github.com/mcntcw/amiibo_explorer_app.git

cd amiibo_explorer_app

### 3. Install Dependencies

Install all project dependencies defined in pubspec.yaml:

### 4. Run the Application

Use one of the following commands depending on your target platform:

**Android / iOS**

flutter run

### 5. Run Tests

This project uses bloc_test and mocktail for testing.

To execute the test suite:

flutter test

---

## Dependencies

Key libraries used in the project:

- flutter_bloc - State management using BLoC pattern  
- dio - For HTTP requests  
- equatable - Simplified equality comparison in models and states  
- get - Simple navigation and dependency management  

- flutter_animate - Smooth and declarative animations  
