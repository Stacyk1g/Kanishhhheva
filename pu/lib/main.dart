import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://frvexfoezbscdbcvuxas.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZydmV4Zm9lemJzY2RiY3Z1eGFzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk3NDY4ODgsImV4cCI6MjA3NTMyMjg4OH0.XDr9MFxBMX0P42a4MwjstxtZeh_Caqdyrfpfr7d9ec8',
  );
  
  runApp(MaterialApp(home: AuthScreen()));
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorText = '';

  Future<void> _signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorText = 'Заполните все поля');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = '';
    });
    
    try {
      print('Пытаюсь войти: ${_emailController.text}');
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      
      print('Успешный вход: ${response.user?.email}');
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MapScreen()),
      );
    } catch (e) {
      print('Ошибка входа: $e');
      setState(() => _errorText = 'Ошибка входа: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signUp() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorText = 'Заполните все поля');
      return;
    }

    if (_passwordController.text.length < 6) {
      setState(() => _errorText = 'Пароль должен быть не менее 6 символов');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = '';
    });
    
    try {
      print('Пытаюсь зарегистрировать: ${_emailController.text}');
      final response = await Supabase.instance.client.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );
      
      print('Успешная регистрация: ${response.user?.email}');
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MapScreen()),
      );
    } catch (e) {
      print('Ошибка регистрации: $e');
      setState(() => _errorText = 'Ошибка регистрации: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Вход')),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Поля ввода
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'example@gmail.com',
                      labelText: 'Email',
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'минимум 6 символов',
                      labelText: 'Пароль',
                    ),
                  ),
                  
                  if (_errorText.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        _errorText,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _signIn,
                            child: Text('Войти'),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _signUp,
                            child: Text('Регистрация'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _currentIndex = 0;

  // Координаты 
  final List<LatLng> locations = [
    LatLng(59.913586, 30.347686), 
    LatLng(60.003570, 30.329330), 
  ];

  List<Marker> getMarker() {
    return [
      Marker(
        width: 80,
        height: 80,
        point: locations[_currentIndex],
        child: CircleAvatar(
          backgroundColor: _currentIndex == 0 
            ? Colors.pink.withOpacity(0.6)  // Дом - розовый
            : Colors.purple.withOpacity(0.6), // Работа - фиолетовый
          child: Text(
            _currentIndex == 0 ? "дом" : "работа",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ];
  }

  // Круги вокруг текущего местоположения
  List<CircleMarker> getCircles() {
    if (_currentIndex == 0) {
      // Дом - розовый и голубой
      return [
        CircleMarker(
          borderStrokeWidth: 5,
          borderColor: Colors.blue.withOpacity(0.4),
          color: Colors.pink.withOpacity(0.4),
          point: locations[0],
          radius: 1000,
          useRadiusInMeter: true,
        ),
      ];
    } else {
      // Работа - розовый с фиолетовым
      return [
        CircleMarker(
          borderStrokeWidth: 5,
          borderColor: Colors.purple.withOpacity(0.4),
          color: Colors.pinkAccent.withOpacity(0.4),
          point: locations[1],
          radius: 1000,
          useRadiusInMeter: true,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Карта"),
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'дом',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'работа',
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: locations[_currentIndex],
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: getMarker(),
          ),
          CircleLayer(
            circles: getCircles(),
          ),
        ],
      ),
    );
  }
}