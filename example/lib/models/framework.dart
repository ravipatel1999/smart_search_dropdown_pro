/// Tech stack framework model for developer examples.
class Framework {
  final String id;
  final String name;
  final String language;
  final String category;

  const Framework({
    required this.id,
    required this.name,
    required this.language,
    required this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Framework && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => name;
}

const sampleFrameworks = [
  Framework(
      id: 'f1',
      name: 'Flutter',
      language: 'Dart',
      category: 'Mobile & Multiplatform'),
  Framework(
      id: 'f2',
      name: 'React Native',
      language: 'JavaScript / TypeScript',
      category: 'Mobile & Multiplatform'),
  Framework(
      id: 'f3',
      name: 'Next.js',
      language: 'TypeScript',
      category: 'Web Frontend'),
  Framework(
      id: 'f4',
      name: 'Vue.js',
      language: 'JavaScript',
      category: 'Web Frontend'),
  Framework(
      id: 'f5', name: 'FastAPI', language: 'Python', category: 'Backend API'),
  Framework(
      id: 'f6',
      name: 'Spring Boot',
      language: 'Java / Kotlin',
      category: 'Backend Enterprise'),
  Framework(
      id: 'f7',
      name: 'NestJS',
      language: 'TypeScript',
      category: 'Backend API'),
  Framework(
      id: 'f8', name: 'SwiftUI', language: 'Swift', category: 'Native Mobile'),
];
