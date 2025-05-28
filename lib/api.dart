class ApiConfig {
  static const String baseUrl =
      "https://72c3-2400-1a00-bb20-55ee-4866-1c1-dedf-ced.ngrok-free.app";

  static String get loginUrl => "$baseUrl/api/Auth/login";
  static String get registerPatientUrl =>
      "$baseUrl/api/AuthPatientRegistration/register-patient";
  static const String doctorLoginUrl = '$baseUrl/api/Auth/doctor/login';
  static const String doctorRegisterUrl =
      '$baseUrl/api/AuthDoctorRegistration/register-doctor';
  static const String adminLoginUrl = "$baseUrl/api/Auth/admin/login";
}
