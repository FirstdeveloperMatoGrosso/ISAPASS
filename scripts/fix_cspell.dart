import 'dart:io';
import 'dart:convert';
import 'package:logging/logging.dart';

void main() async {
  // Setup logging
  final logger = Logger('CSpellUpdater');
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    stderr.writeln('${record.level.name}: ${record.message}');
  });

  // Common Flutter/Dart technical terms
  final technicalWords = {
    'screens', 'Binding', 'ensure', 'Initialized', 'anon',
    'Checked', 'Mode', 'Banner', 'EdgeInsets', 'LinearGradient',
    'BorderRadius', 'Column', 'Row', 'Widget', 'BuildContext',
    'StatelessWidget', 'StatefulWidget', 'setState', 'async', 'await',
    'Future', 'Stream', 'void', 'bool', 'int', 'double', 'String',
    'List', 'Map', 'Set', 'const', 'final', 'var', 'class', 'extends',
    'implements', 'with', 'mixin', 'override', 'return', 'if', 'else',
    'switch', 'case', 'default', 'for', 'while', 'do', 'break',
    'continue', 'try', 'catch', 'finally', 'throw', 'rethrow',
    'assert', 'this', 'super', 'new', 'true', 'false', 'null', 'late',
    'required', 'abstract', 'factory', 'operator', 'typedef', 'enum',
    'get', 'set', 'static', 'external', 'library', 'import', 'export',
    'part', 'show', 'hide', 'as', 'deferred', 'dynamic', 'covariant',
    'yield', 'sync', 'MaterialApp', 'Scaffold', 'AppBar', 'Text',
    'Container', 'Center', 'Padding', 'SizedBox', 'Stack', 'Positioned',
    'GestureDetector', 'InkWell', 'TextButton', 'ElevatedButton',
    'IconButton', 'FloatingActionButton', 'TextField', 'TextFormField',
    'Form', 'FormState', 'GlobalKey', 'Navigator', 'Route',
    'MaterialPageRoute', 'Theme', 'ThemeData', 'Colors', 'Color',
    'BoxDecoration', 'Border', 'BoxShadow', 'Alignment',
    'MainAxisAlignment', 'CrossAxisAlignment', 'FontWeight',
    'TextStyle', 'TextAlign', 'TextDirection', 'Locale', 'MediaQuery',
    'Size', 'Offset', 'Rect', 'RRect', 'Path', 'Canvas', 'Paint',
    'Image', 'Icon', 'Icons', 'AssetImage', 'NetworkImage', 'FileImage',
    'MemoryImage', 'ImageProvider', 'Completer', 'StreamController',
    'Provider', 'ChangeNotifier', 'ValueNotifier', 'Animation',
    'AnimationController', 'CurvedAnimation', 'Curve', 'Curves',
    'Duration', 'Timer', 'Key', 'State'
  };

  try {
    final cspellFile = File('cspell.json');
    if (!await cspellFile.exists()) {
      logger.severe('Error: cspell.json file not found!');
      return;
    }

    // Read current file
    final content = await cspellFile.readAsString();
    final json = jsonDecode(content);
    
    // Get current words
    final currentWords = Set<String>.from(json['words'] as List<dynamic>);
    
    // Add new technical words
    currentWords.addAll(technicalWords);
    
    // Update JSON with all words
    json['words'] = currentWords.toList()..sort();
    
    // Save updated file
    await cspellFile.writeAsString(
      JsonEncoder.withIndent('  ').convert(json),
      flush: true
    );
    
    logger.info('✅ cspell.json updated successfully!');
    logger.info('Total words in dictionary: ${currentWords.length}');
  } catch (e) {
    logger.severe('❌ Error updating cspell.json: $e');
  }
}
