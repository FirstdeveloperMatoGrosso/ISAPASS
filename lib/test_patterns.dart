import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

// Design Patterns
abstract class AbstractFactory {
  Widget createButton();
  Widget createTextField();
}

class MaterialFactory implements AbstractFactory {
  @override
  Widget createButton() => ElevatedButton(
        onPressed: () {},
        child: const Text('Material Button'),
      );

  @override
  Widget createTextField() => const TextField(
        decoration: InputDecoration(
          labelText: 'Material TextField',
        ),
      );
}

// Singleton Pattern
class SingletonExample {
  static final SingletonExample _instance = SingletonExample._internal();
  static final _logger = Logger('SingletonExample');

  factory SingletonExample() {
    return _instance;
  }

  SingletonExample._internal();

  void doSomething() {
    _logger.info('Singleton doing something');
  }
}

// Observer Pattern
class DataRepository extends ChangeNotifier {
  final List<String> _items = [];

  List<String> get items => List.unmodifiable(_items);

  void addItem(String item) {
    _items.add(item);
    notifyListeners();
  }
}

// Builder Pattern
class ComplexWidget {
  final String title;
  final Color backgroundColor;
  final double elevation;
  final BorderRadius borderRadius;
  final List<Widget> children;

  const ComplexWidget({
    required this.title,
    required this.backgroundColor,
    required this.elevation,
    required this.borderRadius,
    required this.children,
  });
}

class ComplexWidgetBuilder {
  String? _title;
  Color _backgroundColor = Colors.white;
  double _elevation = 0.0;
  BorderRadius _borderRadius = BorderRadius.circular(8);
  final List<Widget> _children = [];

  ComplexWidgetBuilder setTitle(String title) {
    _title = title;
    return this;
  }

  ComplexWidgetBuilder setBackgroundColor(Color color) {
    _backgroundColor = color;
    return this;
  }

  ComplexWidgetBuilder setElevation(double elevation) {
    _elevation = elevation;
    return this;
  }

  ComplexWidgetBuilder setBorderRadius(BorderRadius radius) {
    _borderRadius = radius;
    return this;
  }

  ComplexWidgetBuilder addChild(Widget child) {
    _children.add(child);
    return this;
  }

  ComplexWidget build() {
    if (_title == null) {
      throw StateError('Title must be set');
    }
    return ComplexWidget(
      title: _title!,
      backgroundColor: _backgroundColor,
      elevation: _elevation,
      borderRadius: _borderRadius,
      children: List.unmodifiable(_children),
    );
  }
}

// Usage Example Widget
class PatternTestWidget extends StatelessWidget {
  static final _logger = Logger('PatternTestWidget');
  final _dataRepository = DataRepository();
  final _factory = MaterialFactory();

  PatternTestWidget({super.key}) {
    _logger.info('Creating PatternTestWidget');
  }

  @override
  Widget build(BuildContext context) {
    final complexWidget = ComplexWidgetBuilder()
        .setTitle('Test Patterns')
        .setBackgroundColor(Colors.blue.shade100)
        .setElevation(4)
        .addChild(_factory.createButton())
        .addChild(_factory.createTextField())
        .build();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Design Patterns Test'),
      ),
      body: Column(
        children: [
          Card(
            color: complexWidget.backgroundColor,
            elevation: complexWidget.elevation,
            shape: RoundedRectangleBorder(
              borderRadius: complexWidget.borderRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: complexWidget.children,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              SingletonExample().doSomething();
              _dataRepository.addItem('New Item ${_dataRepository.items.length}');
            },
            child: const Text('Test Patterns'),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: _dataRepository,
              builder: (context, child) {
                return ListView.builder(
                  itemCount: _dataRepository.items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_dataRepository.items[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
