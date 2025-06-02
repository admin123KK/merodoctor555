class ApiConfig {
  static const String baseUrl =
      "https://8010-2400-1a00-bb20-8604-b815-d1aa-b70-cd9e.ngrok-free.app";

  static String get loginUrl => "$baseUrl/api/Auth/login";
  static String get registerPatientUrl =>
      "$baseUrl/api/AuthPatientRegistration/register-patient";
  static const String doctorLoginUrl = '$baseUrl/api/Auth/doctor/login';
  static const String doctorRegisterUrl =
      '$baseUrl/api/AuthDoctorRegistration/register-doctor';
  static const String adminLoginUrl = "$baseUrl/api/Auth/admin/login";
}
