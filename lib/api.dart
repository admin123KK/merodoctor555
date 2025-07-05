class ApiConfig {
  static const String baseUrl =
      "https://96ba-2400-1a00-bb20-a771-f85e-754e-8d81-1339.ngrok-free.app";

  static String get loginUrl => "$baseUrl/api/Auth/login";
  static String get registerPatientUrl =>
      "$baseUrl/api/AuthPatientRegistration/register-patient";
  static const String doctorLoginUrl =
      "$baseUrl/api/AuthDoctorRegistration/doctorLogin";
  static const String doctorRegisterUrl =
      '$baseUrl/api/AuthDoctorRegistration/register-doctor';
  static const String adminLoginUrl = "$baseUrl/api/Auth/admin/login";
  static const String ratingUrl = "$baseUrl/api/Ratings/UserRating/{doctorId}";
  static String getCommentsByBlog(String blogId) =>
      "$baseUrl/api/BlogComments/ByBlog/$blogId";

  static String get addCommentUrl => "$baseUrl/api/BlogComments/Add";

  static String get updateCommentUrl => "$baseUrl/api/BlogComments/Update";

  static String deleteCommentUrl(String id) =>
      "$baseUrl/api/BlogComments/Delete/$id";
}
