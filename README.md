Task Management App in Flutter

## Getting Started

To run this project, download the zip folder, extract it, and then open it as an Android Studio Project.
Run the following command in the terminal
```bash
flutter pub get
```
Connect a real device or open the already installed emulator from the device manager within Android Studio.
Run the following command in the terminal to run the project
```bash
flutter run
```
The output is an application where a user can create, update, and retrieve all his tasks, whereas an
admin can create, update, retrieve, and delete all tasks.
To use the application, a user must register within the application first via the signup page.

## Authentication
The authentication system works in a way that a user registers via the signup page, providing details including
name, role, and password. The input data is validated, and the email is checked to be not already in use by
someone else. This data is then saved in Firebase with the password being encrypted first by the application.
Hence, on the login page, the user enters his email and password, and the credentials are checked against
the data in Firebase after decrypting the password. If the user is successfully authenticated, the user is redirected
to the home screen; otherwise, an appropriate error message is displayed for a better understanding of the error.

## Architecture
The application follows the MVC pattern, hence the project structure is well-maintained throughout the development.

## Demo
The demo video of the application is also provided in the assets folder.