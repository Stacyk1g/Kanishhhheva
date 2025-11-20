import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://diatfsydzbqpfdzwcgil.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRpYXRmc3lkemJxcGZkendjZ2lsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEyMTIxNzIsImV4cCI6MjA3Njc4ODE3Mn0.o5w70G_DuDtwR2MEaylJC68g-UTN5dzOJmVVmzVog8w',
  );
  
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Future<List<Map<String, dynamic>>> _getMessages() async {
    final response = await Supabase.instance.client
        .from('messages')
        .select();
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> _sendMessage() async {
    try {
      final messages = await _getMessages();
      final newId = (messages.length + 1).toString();
      
      await Supabase.instance.client
          .from('messages')
          .insert({
            'id': newId,
            'created_at': DateTime.now().toIso8601String(),
            'text': _messageController.text,
            'username': _nameController.text,
          });
      
      _messageController.clear();
      _nameController.clear();
    } catch (error) {
      print('Ошибка отправки: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Список сообщений
          Expanded(
            child: Container(
              color: Colors.red,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _getMessages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  
                  if (snapshot.hasError) {
                    return Center(child: Text('Ошибка загрузки'));
                  }
                  
                  final messages = snapshot.data ?? [];
                  
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'ID: ${message['id']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    'Автор: ${message['username']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${message['text']}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${message['created_at']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Форма ввода
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: 'Сообщение',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Ваше имя',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text('Отправить'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}