class XelaUser {
  final String username;
  final String documentId;
  final String passwordHashSha1; // ver auth_service.dart: vuln #5

  XelaUser({
    required this.username,
    required this.documentId,
    required this.passwordHashSha1,
  });

  factory XelaUser.fromJson(Map<String, dynamic> json) => XelaUser(
        username: json['username'] as String,
        documentId: json['documentId'] as String,
        passwordHashSha1: json['passwordHash'] as String,
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'documentId': documentId,
        'passwordHash': passwordHashSha1,
      };
}
