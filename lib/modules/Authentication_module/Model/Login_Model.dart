class LoginResponse {
  final String message;
  final String accessToken;
  final String refreshToken;
  final String tokenGeneratedTime;
  final int userId;

  LoginResponse({
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenGeneratedTime,
    required this.userId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] ?? '',
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      tokenGeneratedTime: json['token_generated_time'] ?? '',
      userId: json['user_id'] ?? 0,
    );
  }
}
