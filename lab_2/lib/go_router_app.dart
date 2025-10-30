import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoRouterApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomeGoRouterScreen(),
      ),
      GoRoute(
        path: '/profile/:userId',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          final extraData = state.extra as String?;
          return ProfileScreen(userId: userId, extraData: extraData);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoRouter',
      routerConfig: _router,
      theme: ThemeData(primarySwatch: Colors.purple),
    );
  }
}

class HomeGoRouterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Главная - GoRouter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.push(
                  '/profile/123',
                  extra: 'Дополнительные данные',
                );
              },
              child: Text('Профиль пользователя 123'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.push('/profile/456');
              },
              child: Text('Профиль пользователя 456'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.push('/settings');
              },
              child: Text('Настройки'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String userId;
  final String? extraData;

  const ProfileScreen({required this.userId, this.extraData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Профиль $userId')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ID пользователя: $userId',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (extraData != null) ...[
              SizedBox(height: 10),
              Text('Доп данные: $extraData'),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Настройки')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Экран настроек',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}