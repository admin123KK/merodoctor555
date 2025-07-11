class ApiConfig {
  static const String baseUrl = "https://3e5048ad5001.ngrok-free.app";

  static String get loginUrl => "$baseUrl/api/Auth/login";
  static String get registerPatientUrl =>
      "$baseUrl/api/AuthPatientRegistration/register-patient";
  static const String doctorLoginUrl =
      "$baseUrl/api/AuthDoctorRegistration/doctorLogin";
  static const String doctorRegisterUrl =
      '$baseUrl/api/AuthDoctorRegistration/register-doctor';
  static const String adminLoginUrl = "$baseUrl/api/Auth/login";
  static const String ratingUrl = "$baseUrl/api/Ratings/UserRating/{doctorId}";
  static String adminProfileUrl = "$baseUrl/api/Admin/profile";
  static String adminDashbordeUrl = "$baseUrl/api/Admin/dashboard";
  static String imagelUrl = "$baseUrl/api/Image/uploadOrReplaceProfilePicture";
  static String pendingDoctors = "$baseUrl/api/Admin/pending";
  static String updateDoctorStatusUrl(String id) =>
      "$baseUrl/api/Admin/verify/$id";
  static String getCommentsByBlog(String blogId) =>
      "$baseUrl/api/BlogComments/ByBlog/$blogId";

  static String get addCommentUrl => "$baseUrl/api/BlogComments/Add";

  static String get updateCommentUrl => "$baseUrl/api/BlogComments/Update";

  static String deleteCommentUrl(String id) =>
      "$baseUrl/api/BlogComments/Delete/$id";
}
