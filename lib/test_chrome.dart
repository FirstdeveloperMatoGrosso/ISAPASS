import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:universal_html/html.dart' as html;

class ChromeTest extends StatelessWidget {
  static final _logger = Logger('ChromeTest');
  
  const ChromeTest({super.key});

  void testChromeFunctions() {
    // Chrome specific features
    final navigator = html.window.navigator;
    _logger.info('Is Chrome: ${navigator.userAgent.contains('Chrome')}');
    
    // Web storage
    html.window.localStorage['key'] = 'value';
    html.window.sessionStorage.clear();
    
    // Web APIs
    html.window.location.href = 'https://example.com';
    html.window.history.pushState({}, '', '/new-route');
    html.window.localStorage['newKey'] = 'value';
    
    // Browser features
    html.document.cookie = 'name=value; expires=Thu, 18 Dec 2024 12:00:00 UTC';
    html.window.console.log('Testing Chrome features');
    html.window.alert('Alert message');
    html.window.confirm('Confirm action?');
    
    // DOM manipulation
    final div = html.document.createElement('div');
    div.id = 'myDiv';
    div.className = 'myClass';
    div.style.backgroundColor = '#ffffff';
    html.document.body?.nodes.add(div);
    
    // XMLHttpRequest
    final xhr = html.HttpRequest();
    xhr.open('GET', 'https://api.example.com');
    xhr.onLoad.listen((event) {
      _logger.info('Response: ${xhr.responseText}');
    });
    
    // WebSocket
    final ws = html.WebSocket('wss://websocket.example.com');
    ws.onMessage.listen((html.MessageEvent e) {
      _logger.info('Received message: ${e.data}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chrome Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: testChromeFunctions,
              child: const Text('Test Chrome Features'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Testing Chrome and Browser APIs',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
