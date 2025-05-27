class ApiConfig {
  static const String baseUrl =
      "https://d00c-2400-1a00-bb20-cf36-b8e5-8992-e243-3546.ngrok-free.app";

  static String get loginUrl => "$baseUrl/api/Auth/login";
  static String get registerPatientUrl =>
      "$baseUrl/api/AuthPatientRegistration/register-patient";
  static const String doctorLoginUrl = '$baseUrl/Auth/doctor/login';
  static const String doctorRegisterUrl =
      '$baseUrl/AuthDoctorRegistration/register-doctor';
  static const String adminLoginUrl = "$baseUrl/Auth/admin/login";
}
