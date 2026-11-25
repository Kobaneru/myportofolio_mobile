import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _institutionName = "";
  String _major = "";
  String _description = "";
  DateTime? _startDate;
  DateTime? _endDate;

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Widget _dateField({
    required String label,
    required ValueChanged<DateTime> onChanged,
    required FormFieldValidator<DateTime> validator,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FormField<DateTime>(
        validator: validator,
        builder: (field) {
          final date = field.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: field.context,
                    initialDate: date ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100, 12, 31),
                  );
                  if (field.mounted && picked != null) {
                    onChanged(picked);
                    field.didChange(picked);
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    errorText: field.errorText,
                    suffixIcon: const Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(date == null ? 'dd/mm/yyyy' : _formatDate(date)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Education Form')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Institution Name ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Institusi",
                    labelText: "Nama Institusi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _institutionName = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama institusi tidak boleh kosong!";
                    }
                    if (value.trim().runes.length > 255) {
                      return 'Nama institusi maksimal 255 karakter';
                    }
                    return null;
                  },
                ),
              ),

              // === Major ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Gelar / Program Studi",
                    labelText: "Gelar / Program Studi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _major = value!;
                    });
                  },
                  validator: (value) {
                    if ((value ?? '').trim().runes.length > 255) {
                      return 'Gelar / program studi maksimal 255 karakter';
                    }
                    return null;
                  },
                ),
              ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Deskripsi Pendidikan",
                    labelText: "Deskripsi Pendidikan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
                  },
                ),
              ),

              _dateField(
                label: 'Tanggal Mulai',
                onChanged: (date) => _startDate = date,
                validator: (date) =>
                    date == null ? 'Tanggal mulai wajib diisi' : null,
              ),
              _dateField(
                label: 'Tanggal Selesai',
                onChanged: (date) => _endDate = date,
                validator: (date) {
                  if (date == null) {
                    return 'Tanggal selesai wajib diisi';
                  }
                  final start = _startDate;
                  if (start != null && date.isBefore(start)) {
                    return 'Tanggal selesai tidak boleh sebelum tanggal mulai';
                  }
                  return null;
                },
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final startDate = _startDate!;
                        final endDate = _endDate!;
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Pendidikan berhasil ditambahkan!',
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nama Institusi: $_institutionName'),
                                    Text(
                                      'Gelar / Program Studi: ${_major.trim().isEmpty ? '—' : _major.trim()}',
                                    ),
                                    Text(
                                      'Deskripsi: ${_description.trim().isEmpty ? '—' : _description.trim()}',
                                    ),
                                    Text(
                                      'Tanggal Mulai: ${_formatDate(startDate)}',
                                    ),
                                    Text(
                                      'Tanggal Selesai: ${_formatDate(endDate)}',
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _startDate = null;
                                    _endDate = null;
                                    _formKey.currentState!.reset();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
