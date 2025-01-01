import 'dart:io';
import 'dart:convert';
import 'package:logging/logging.dart';

void main() async {
  final logger = Logger('CSpellUpdater');
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.message}');
  });

  // Directories to search
  final directories = ['lib', 'test'];
  final wordsSet = <String>{};
  
  // Read current cspell.json
  final cspellFile = File('cspell.json');
  final cspellJson = jsonDecode(await cspellFile.readAsString());
  final currentWords = Set<String>.from(cspellJson['words'] as List);

  // Find all words in files
  for (final dir in directories) {
    final directory = Directory(dir);
    await for (final file in directory.list(recursive: true)) {
      if (file.path.endsWith('.dart')) {
        final content = await File(file.path).readAsString();
        final words = content.split(RegExp(r'[\s\n\r\t{}()\[\].,;:+\-*/=<>!?]'))
          .where((word) => word.isNotEmpty)
          .where((word) => !word.contains(RegExp(r'[0-9]')))
          .where((word) => word.length > 1);
        wordsSet.addAll(words);
      }
    }
  }

  // Add new words
  final newWords = wordsSet.difference(currentWords);
  if (newWords.isNotEmpty) {
    cspellJson['words'] = [...currentWords, ...newWords]..sort();
    await cspellFile.writeAsString(
      JsonEncoder.withIndent('  ').convert(cspellJson),
    );
    logger.info('Added ${newWords.length} new words to cspell.json');
  } else {
    logger.info('No new words found');
  }
}
