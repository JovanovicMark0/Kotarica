# flutter_app

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Упутство за покретање Flutter апликације:
1. Покренути Android Studio или Visual Studio Code
2. Покренути Ganache и наместити подешавања
3. Изменити ИП адресе у фајловима PostModel.dart, UserModel.dart, truffle-config.js
4. У терминалу извршити команду truffle migration
5. Отворити Ganache кликом на иконицу кључ са десне стране отвара се прозор одакле треба прекопирати приватни кључ
6. Приватни кључ изменити на страницама PostModel.dart и UserModel.dart
7. Покренути емулатор или повезати телефон(Потребно је да телефон и рачунар буду на истој мрежи)
7. Покренути програм кликом на Play button у Android Studio-u или извршити команду "flutter run" у терминалу Аndroid Studio-а или Visual Studio Code-а

Упуство за повезивање са MateMask-ом:
1. Инсталирамо ектензију за MateMask на Chrome-у
2. При одабиру налога изаберемо Custom Rpc (кориснички дефинисан RPC)
	- постављамо жељено име за мрежу
	- за New RPC URL: постављамо RPC SERVER из Ganache-а (HTTP://192.168.1.155:7545)
	- Chain ID: 1337
	- Сачувамо
3. Кликом на нови налог (Account1) потребно је да увеземо налог 
4. Тип: приватни кључ, поставимо приватни приватни кључ налога којег желимо да кориситимо
5. Увеземо и спремно је за трансакције