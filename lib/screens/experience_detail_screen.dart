import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/experience.dart';

class ExperienceDetailScreen extends StatelessWidget {
  const ExperienceDetailScreen({required this.experience, super.key});

  final Experience experience;

  @override
  Widget build(BuildContext context) {
    final period = experience.endedAt.isNotEmpty
        ? '${experience.startedAt} - ${experience.endedAt}'
        : '${experience.startedAt} - Present';

    return Scaffold(
      appBar: AppBar(title: Text(experience.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (experience.thumbnail.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  experience.thumbnail,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, size: 48),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              experience.title,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(label: Text(experience.category)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    period,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              experience.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
