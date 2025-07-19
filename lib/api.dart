class ApiConfig {
  static const String baseUrl = "https://5c7630f1f57f.ngrok-free.app";
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
  static String createFeedback = "$baseUrl/api/Feedbacks/Create";

//doctor page
  static const String doctorAppointments =
      "$baseUrl/api/Appointments/doctorAppointments";
  static const String fetchDoctorOwnDetails =
      "$baseUrl/api/Doctor/fetchDoctorOwnDetails";
  static String setAvailability = "$baseUrl/api/Doctor/SetAvailability";
  static String getAvailability(String doctorId) =>
      "$baseUrl/api/Doctor/GetAvailability/$doctorId";
  static String deleteDaySchedule = "$baseUrl/api/Doctor/delete-day-Schedule";
  static String deleteTimeRange = "$baseUrl/api/Doctor/delete-time-range";
  static String doctorFilter = "$baseUrl/api/Doctor/filter";

  //patient
  static const String fetchPatientOwnDetails =
      "$baseUrl/api/Patients/getPatientById";
//blogs
  static const String toggleLike = "$baseUrl/api/BlogLikes/ToggleLike";
  static const String blogAdd = "$baseUrl/api/Blogs/Add"; // POST [FromForm]
  static const String blogUpdate =
      "$baseUrl/api/Blogs/Update"; // PUT [FromForm]
  static String blogDelete(String blogId) =>
      "$baseUrl/api/Blogs/Delete/$blogId"; // DELETE

  static String blogGet(int id) =>
      "$baseUrl/api/Blogs/Get/$id"; // GET single blog by id
  static const String blogGetAll = "$baseUrl/api/Blogs/GetAll"; // GET all blogs
  static const String doctorBlogs =
      "$baseUrl/api/Blogs/GetByDoctor"; // GET all blogs by logged in doctor (Authorization required)

  // Categories
  static const String categoryGetAll =
      "$baseUrl/api/BlogCategories/getAllCategories"; // GET all categories

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
  static String get myComments => "$baseUrl/api/BlogComments/MyComments";
  static String get updateCommentUrl => "$baseUrl/api/BlogComments/Update";

  static String deleteCommentUrl(String id) =>
      "$baseUrl/api/BlogComments/Delete/$id";
}
