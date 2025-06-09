class ApiConfig {
  static const String baseUrl =
      "https://ed36-2400-1a00-bb20-8ae-96e-b9a9-e04b-b7a5.ngrok-free.app";

  static String get loginUrl => "$baseUrl/api/Auth/login";
  static String get registerPatientUrl =>
      "$baseUrl/api/AuthPatientRegistration/register-patient";
  static const String doctorLoginUrl =
      "$baseUrl/api/AuthDoctorRegistration/doctorLogin";
  static const String doctorRegisterUrl =
      '$baseUrl/api/AuthDoctorRegistration/register-doctor';
  static const String adminLoginUrl = "$baseUrl/api/Auth/admin/login";
  static const String ratingUrl = "$baseUrl/api/Ratings/UserRating/{doctorId}";
}
