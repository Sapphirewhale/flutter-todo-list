class AppUser {
  String id = '';
  String email = '';
  String username = '';

  AppUser.fromMap(Map<String, dynamic> map) {
    id = map['id'] ?? '';
    email = map['email'] ?? '';
    username = map['username'] ?? '';
  }

  AppUser({
    this.id = '',
    this.email = '',
    this.username = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
    };
  }
}
