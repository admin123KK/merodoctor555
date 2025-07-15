class ApiConfig {
  static const String baseUrl = "https://c2ae692395d1.ngrok-free.app";
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
  static String verifiedDoctors = "$baseUrl/api/Admin/verified";
  static String pendingDoctors = "$baseUrl/api/Admin/pending";
  static String rejectedDoctors = "$baseUrl/api/Admin/rejected";
  static String notification = "$baseUrl/api/Notification/notifications";
  static String feedbacks = "$baseUrl/api/Feedbacks/getAllFeedbacks";

  //specialization
  static String getAllSpecialization =
      "$baseUrl/api/Specializations/getAllSpecialization";

// pneumonia check
  static String detectPneumonia = "$baseUrl/api/XRayRecords/detect-pneumonia";
  static String xrayHistory = "$baseUrl/api/XRayRecords/xray-history";

  //Patients
  static String getAllPatients = "$baseUrl/api/Patients/getAllPatients";

  //specialilzation
  static String specializations =
      "$baseUrl/api/Specializations/getAllSpecialization";
  static String addSpecialization = "$baseUrl/api/Specializations/add";
  static String getSpecializations(String specializationId) =>
      "$baseUrl/api/Specializations/getById/$specializationId";
  static String updateSpecialization(String specializationId) =>
      "$baseUrl/api/Specializations/update/$specializationId";
  static String deleteSpecialization(String specializationId) =>
      "$baseUrl/api/Specializations/delete/$specializationId";

//blogcategories
  static String get categories =>
      '$baseUrl/api/BlogCategories/getAllCategories';
  static String get addCategory => '$baseUrl/api/BlogCategories/add';
  static String get updateCategory =>
      '$baseUrl/api/BlogCategories/update'; // PUT, no {id} in URL
  static String deleteCategory(String id) =>
      '$baseUrl/api/BlogCategories/delete/$id';

  static String updateDoctorStatusUrl(String id) =>
      "$baseUrl/api/Admin/verify/$id";
  static String getCommentsByBlog(String blogId) =>
      "$baseUrl/api/BlogComments/ByBlog/$blogId";

  static String get addCommentUrl => "$baseUrl/api/BlogComments/Add";

  static String get updateCommentUrl => "$baseUrl/api/BlogComments/Update";

  static String deleteCommentUrl(String id) =>
      "$baseUrl/api/BlogComments/Delete/$id";
}
