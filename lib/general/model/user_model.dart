class Users {
  final String id;
  final String username;
  final String email;
  final String role;

  Users({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'role' : role,
  };

}