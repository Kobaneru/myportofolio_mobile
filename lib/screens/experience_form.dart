import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _experienceName = "";
  String _description = "";
  String _category = "full-time"; // default
  String _experienceLink = "";
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSubmitting = false;

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _formatIsoDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Widget _dateField({
    required String label,
    required ValueChanged<DateTime?> onChanged,
    required FormFieldValidator<DateTime> validator,
    bool canClear = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FormField<DateTime>(
        validator: validator,
        builder: (field) {
          final date = field.value;

          void updateDate(DateTime? value) {
            onChanged(value);
            field.didChange(value);
          }

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
                    updateDate(picked);
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    errorText: field.errorText,
                    suffixIcon: canClear && date != null
                        ? IconButton(
                            tooltip: 'Hapus tanggal selesai',
                            icon: const Icon(Icons.clear),
                            onPressed: () => updateDate(null),
                          )
                        : const Icon(Icons.calendar_today_outlined),
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

  static const _categories = <String, String>{
    'freelance': 'Freelance',
    'full-time': 'Full-Time',
    'part-time': 'Part-Time',
    'volunteer': 'Volunteer',
    'research': 'Research',
    'internship': 'Internship',
  };

  String? _validateThumbnailUrl(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    if (text.runes.length > 200) {
      return 'URL thumbnail maksimal 200 karakter';
    }

    const allowedSchemes = {'http', 'https', 'ftp', 'ftps'};
    final uri = Uri.tryParse(text);
    if (uri == null ||
        !allowedSchemes.contains(uri.scheme) ||
        uri.host.isEmpty ||
        RegExp(r'[\s\\]').hasMatch(text)) {
      return 'Masukkan URL thumbnail yang valid';
    }

    final host = uri.host;
    final domain = host.endsWith('.')
        ? host.substring(0, host.length - 1)
        : host;
    final labels = domain.split('.');
    // Uri already parses IPv6 literals. Other hosts need a valid domain or localhost.
    if (host != 'localhost' &&
        !host.contains(':') &&
        (labels.length < 2 || labels.any((label) => label.isEmpty))) {
      return 'Masukkan URL thumbnail yang valid';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!await ensureLoggedIn(context)) return;
    if (!mounted) return;

    final token = context.read<AuthState>().token;
    if (token == null) return;

    final startDate = _startDate!;
    final endDate = _endDate;

    setState(() {
      _isSubmitting = true;
    });

    final newExperience = Experience(
      title: _experienceName.trim(),
      description: _description.trim(),
      category: _category,
      thumbnail: _experienceLink.trim(),
      startedAt: _formatIsoDate(startDate),
      endedAt: endDate == null ? '' : _formatIsoDate(endDate),
    );

    try {
      await context.read<ApiClient>().createExperience(
        newExperience,
        token: token,
      );
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Pengalaman berhasil ditambahkan!'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama Pengalaman: $_experienceName'),
                  Text('Deskripsi: $_description'),
                  Text('Kategori: ${_categories[_category]}'),
                  Text('URL Thumbnail: $_experienceLink'),
                  Text('Tanggal Mulai: ${_formatDate(startDate)}'),
                  Text(
                    'Tanggal Selesai: ${endDate == null ? '—' : _formatDate(endDate)}',
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          );
        },
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        context.read<AuthState>().clearSession();
        if (!mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Sesi berakhir. Silakan login kembali.'),
            ),
          );
        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                'Gagal menyimpan pengalaman (HTTP ${e.statusCode}).',
              ),
            ),
          );
      }
    } on http.ClientException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak bisa menghubungi server. Coba lagi.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Experience Form')),
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
              // === Experience Name ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Pengalaman",
                    labelText: "Nama Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _experienceName = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama pengalaman tidak boleh kosong!";
                    }
                    if (value.trim().runes.length > 255) {
                      return 'Nama pengalaman maksimal 255 karakter';
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
                    hintText: "Deskripsi Pengalaman",
                    labelText: "Deskripsi Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Deskripsi pengalaman tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Category ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Kategori Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _category,
                  items: _categories.entries
                      .map(
                        (entry) => DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _category = value);
                  },
                ),
              ),

              // === Experience Link ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "URL Pengalaman (opsional)",
                    labelText: "URL Thumbnail",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.url,
                  validator: _validateThumbnailUrl,
                  onChanged: (String? value) {
                    setState(() {
                      _experienceLink = value?.trim() ?? '';
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
                label: 'Tanggal Selesai (opsional)',
                canClear: true,
                onChanged: (date) => _endDate = date,
                validator: (date) {
                  final start = _startDate;
                  if (date != null && start != null && date.isBefore(start)) {
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
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
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
