import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/event_service.dart';
import '../constants/app_theme.dart';
import 'dart:io';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _maxCapacityController = TextEditingController();
  final _areaController = TextEditingController();
  final _ticketsController = TextEditingController(); 
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Shows';
  String _selectedClassification = 'Livre';
  XFile? _imageFile;
  final _eventService = EventService();
  bool _isLoading = false;
  final List<String> _areas = []; 

  final List<String> _categories = ['Shows', 'Esportes', 'Teatro', 'Cinema', 'Outros'];
  final List<String> _classifications = ['Livre', '10 anos', '12 anos', '14 anos', '16 anos', '18 anos'];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        if (!mounted) return;
        setState(() {
          _imageFile = image;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao selecionar imagem')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!mounted) return;

    final navigator = Navigator.of(context);

    final DateTime? picked = await showDatePicker(
      context: navigator.context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (!mounted) return;
    if (picked == null) return;

    final TimeOfDay? time = await showTimePicker(
      context: navigator.context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    
    if (!mounted) return;
    if (time == null) return;

    setState(() {
      _selectedDate = DateTime(
        picked.year,
        picked.month,
        picked.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      String? imageUrl;
      if (_imageFile != null) {
        try {
          final bytes = await File(_imageFile!.path).readAsBytes();
          final fileExt = _imageFile!.path.split('.').last;
          final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
          
          final storage = Supabase.instance.client.storage;
          await storage.from('event-images').uploadBinary(
            fileName,
            bytes,
            fileOptions: FileOptions(
              contentType: 'image/$fileExt',
            ),
          );
          
          imageUrl = storage
              .from('event-images')
              .getPublicUrl(fileName);
              
        } catch (e) {
          if (mounted) {
            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('Error uploading image'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      await _eventService.createEvent(
        name: _nameController.text,
        description: _descriptionController.text,
        date: _selectedDate,
        location: _locationController.text,
        price: double.parse(_priceController.text),
        maxCapacity: int.parse(_ticketsController.text),
        category: _selectedCategory,
        imageUrl: imageUrl,
        area: _areas.join(', '),
        classification: _selectedClassification,
      );

      if (mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Event created successfully'),
            backgroundColor: Colors.green,
          ),
        );
        navigator.pop(true);
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Error creating event: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;
    final contentWidth = isSmallScreen ? screenWidth : screenWidth * 0.5;
    final padding = isSmallScreen ? 8.0 : 12.0; 
    final imageHeight = screenHeight * 0.2; 

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Criar Evento'),
      ),
      body: Center(
        child: Container(
          width: contentWidth,
          padding: EdgeInsets.symmetric(
            horizontal: padding * 2,
            vertical: padding * 3,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Seleção de imagem
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: imageHeight,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: _imageFile != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(_imageFile!.path),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_photo_alternate,
                                          size: isSmallScreen ? 32 : 48,
                                          color: Colors.grey[400]),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Adicionar imagem do evento',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: isSmallScreen ? 12 : 14,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        SizedBox(height: padding * 0.5),

                        // Grid de campos principais
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _nameController,
                                label: 'Nome do evento',
                                icon: Icons.event,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira o nome do evento';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: padding),
                            Expanded(
                              child: _buildTextField(
                                controller: _priceController,
                                label: 'Preço',
                                icon: Icons.attach_money,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira o preço';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Por favor, insira um valor válido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: padding * 0.5),

                        // Segunda linha do grid
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _locationController,
                                label: 'Local',
                                icon: Icons.location_on,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira o local do evento';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: padding),
                            Expanded(
                              child: _buildTextField(
                                controller: _maxCapacityController,
                                label: 'Capacidade',
                                icon: Icons.people,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira a capacidade';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Por favor, insira um número válido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: padding * 0.5),

                        // Área
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _areaController,
                                    label: 'Nome da Área (ex: Pista, Camarote)',
                                    icon: Icons.area_chart,
                                    validator: null, 
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle),
                                  color: AppTheme.primaryColor,
                                  onPressed: () {
                                    if (_areaController.text.isNotEmpty) {
                                      setState(() {
                                        _areas.add(_areaController.text);
                                        _areaController.clear();
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                            if (_areas.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: _areas.map((area) => Chip(
                                  label: Text(area),
                                  deleteIcon: const Icon(Icons.close, size: 18),
                                  onDeleted: () {
                                    setState(() {
                                      _areas.remove(area);
                                    });
                                  },
                                )).toList(),
                              ),
                            ],
                            if (_areas.isEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Adicione pelo menos uma área do evento',
                                style: TextStyle(
                                  color: Colors.red[300],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: padding * 0.5),

                        // Ingressos
                        _buildTextField(
                          controller: _ticketsController,
                          label: 'Ingressos',
                          icon: Icons.event_seat,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o número de ingressos';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Por favor, insira um número válido';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: padding * 0.5),

                        // Descrição
                        _buildTextField(
                          controller: _descriptionController,
                          label: 'Descrição',
                          icon: Icons.description,
                          maxLines: 2, 
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira uma descrição';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: padding * 0.5),

                        // Data e hora
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Data e hora',
                              prefixIcon: const Icon(Icons.calendar_today),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} às ${_selectedDate.hour}:${_selectedDate.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        SizedBox(height: padding * 0.5),

                        // Linha de dropdowns
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedClassification,
                                decoration: const InputDecoration(
                                  labelText: 'Classificação',
                                  prefixIcon: Icon(Icons.person_outline),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                style: const TextStyle(fontSize: 14),
                                items: _classifications.map((String classification) {
                                  return DropdownMenuItem(
                                    value: classification,
                                    child: Text(classification),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedClassification = newValue;
                                    });
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: padding),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                decoration: const InputDecoration(
                                  labelText: 'Categoria',
                                  prefixIcon: Icon(Icons.category),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                style: const TextStyle(fontSize: 14),
                                items: _categories.map((String category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedCategory = newValue;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Botão criar (fora do scroll)
                Padding(
                  padding: EdgeInsets.only(top: padding),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createEvent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Criar Evento'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      validator: validator,
      style: const TextStyle(fontSize: 14),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _maxCapacityController.dispose();
    _areaController.dispose();
    _ticketsController.dispose(); 
    super.dispose();
  }
}
