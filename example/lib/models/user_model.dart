/// Developer user profile model for developer examples.
class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String avatarUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatarUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => name;
}

const sampleUsers = [
  UserModel(
      id: 'u1',
      name: 'Alex Rivera',
      email: 'alex@company.com',
      role: 'Engineering Lead',
      avatarUrl: 'https://i.pravatar.cc/150?img=11'),
  UserModel(
      id: 'u2',
      name: 'Samantha Wu',
      email: 'samantha@company.com',
      role: 'Senior Product Designer',
      avatarUrl: 'https://i.pravatar.cc/150?img=5'),
  UserModel(
      id: 'u3',
      name: 'David Chen',
      email: 'david@company.com',
      role: 'Full Stack Architect',
      avatarUrl: 'https://i.pravatar.cc/150?img=12'),
  UserModel(
      id: 'u4',
      name: 'Emily Taylor',
      email: 'emily@company.com',
      role: 'DevOps Engineer',
      avatarUrl: 'https://i.pravatar.cc/150?img=9'),
  UserModel(
      id: 'u5',
      name: 'Marcus Johnson',
      email: 'marcus@company.com',
      role: 'QA Lead Specialist',
      avatarUrl: 'https://i.pravatar.cc/150?img=33'),
];
