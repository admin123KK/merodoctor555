class ApiConfig {
  static const String baseUrl =
      "https://a17b-2400-1a00-bb20-395e-2082-62a-2fe5-40e5.ngrok-free.app";

  static String get loginUrl => "$baseUrl/api/Auth/login";
  static String get registerPatientUrl =>
      "$baseUrl/api/AuthPatientRegistration/register-patient";
  static const String doctorLoginUrl = '$baseUrl/api/Auth/doctor/login';
  static const String doctorRegisterUrl =
      '$baseUrl/api/AuthDoctorRegistration/register-doctor';
  static const String adminLoginUrl = "$baseUrl/api/Auth/admin/login";
}
