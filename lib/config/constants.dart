class AppConstants {
  static const String usersTable = 'users';
  
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String authErrorMessage = 'Authentication failed. Please try again.';
  
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidPhone = 'Please enter a valid phone number';
  static const String minimumAgeMessage = 'You must be at least 18 years old';
  
  static final List<int> ageOptions = List.generate(82, (index) => index + 18); // 18-99 years
}