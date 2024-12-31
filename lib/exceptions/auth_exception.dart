class CustomAuthException implements Exception {
  final String message;

  const CustomAuthException(this.message);

  @override
  String toString() => message;
}
