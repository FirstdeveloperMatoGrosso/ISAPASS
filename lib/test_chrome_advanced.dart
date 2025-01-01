import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:universal_html/html.dart' as html;
import 'package:js/js.dart';

@JS()
@anonymous
class ChromeStorage {
  external dynamic get local;
}

@JS()
@anonymous
class Chrome {
  external ChromeStorage get storage;
}

@JS('chrome')
external Chrome get chrome;

@JS('chrome.runtime')
external dynamic get runtime;

@JS('chrome.tabs')
external dynamic get tabs;

class ChromeAdvancedTest extends StatelessWidget {
  static final _logger = Logger('ChromeAdvancedTest');

  const ChromeAdvancedTest({super.key});

  Future<void> testChromeAPIs() async {
    try {
      final manifest = runtime.getManifest();
      _logger.info('Extension version: ${manifest.version}');

      final currentTab = await tabs.query({'active': true, 'currentWindow': true});
      if (currentTab.isNotEmpty) {
        _logger.info('Current tab URL: ${currentTab[0].url}');
      }

      final storage = chrome.storage.local;
      await storage.set({'lastAccess': DateTime.now().toIso8601String()});
      final data = await storage.get('lastAccess');
      _logger.info('Last access: ${data['lastAccess']}');
    } catch (e) {
      _logger.warning('Chrome APIs not available: $e');
    }
  }

  Future<void> testModernWebAPIs() async {
    try {
      final serviceWorker = html.window.navigator.serviceWorker;
      final registration = await serviceWorker?.register('service-worker.js');
      if (registration != null) {
        _logger.info('ServiceWorker registered: ${registration.scope}');
      }

      final permission = await html.Notification.requestPermission();
      if (permission == 'granted') {
        final registration = await html.window.navigator.serviceWorker?.ready;
        final pushManager = registration?.pushManager;
        if (pushManager != null) {
          final pushSubscription = await pushManager.subscribe({
            'userVisibleOnly': true,
            'applicationServerKey': 'YOUR_PUBLIC_VAPID_KEY'
          });
          _logger.info('Push subscription: $pushSubscription');
        }
      }

      final navigator = html.window.navigator;
      if (navigator.share is bool) {
        await navigator.share({
          'title': 'Web Share Test',
          'text': 'Testing Web Share API',
          'url': 'https://example.com'
        });
      }

      // Note: File System Access API is not yet available in universal_html
      // Keeping as reference for future implementation
      /*
      final handle = await html.window.showSaveFilePicker();
      final writable = await handle.createWritable();
      await writable.write('Hello from Chrome!');
      await writable.close();
      */

    } catch (e) {
      _logger.warning('Modern Web APIs not available: $e');
    }
  }

  void testPerformanceAPIs() {
    try {
      final performance = html.window.performance;
      final timing = performance.timing;
      _logger.info('Page load time: ${timing.loadEventEnd - timing.navigationStart}ms');

      final memory = performance.memory;
      if (memory != null) {
        _logger.info('JS Heap size: ${memory.usedJSHeapSize}');
      }

      final entries = performance.getEntriesByType('resource');
      for (final entry in entries) {
        _logger.info('Resource: ${entry.name}, Duration: ${entry.duration}ms');
      }

      performance.mark('testStart');
      performance.mark('testEnd');
      performance.measure('testDuration', 'testStart', 'testEnd');
    } catch (e) {
      _logger.warning('Performance APIs not available: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chrome Advanced Features'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => testChromeAPIs(),
              child: const Text('Test Chrome Extension APIs'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => testModernWebAPIs(),
              child: const Text('Test Modern Web APIs'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => testPerformanceAPIs(),
              child: const Text('Test Performance APIs'),
            ),
          ],
        ),
      ),
    );
  }
}
