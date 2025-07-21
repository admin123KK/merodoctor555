class Doctor {
  final String userId;
  final int doctorId;
  final String fullName;
  final String registrationId;
  final String? profilePictureUrl;
  final String email;
  final String phoneNumber;
  final String status;
  final String degree;
  final double experience;
  final String clinicAddress;
  final String specializationName;
  final double latitude;
  final double longitude;
  final double averageRating;

  Doctor({
    required this.userId,
    required this.doctorId,
    required this.fullName,
    required this.registrationId,
    this.profilePictureUrl,
    required this.email,
    required this.phoneNumber,
    required this.status,
    required this.degree,
    required this.experience,
    required this.clinicAddress,
    required this.specializationName,
    required this.latitude,
    required this.longitude,
    this.averageRating = 0.0,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      userId: json['userId'] ?? '',
      doctorId: json['doctorId'] ?? 0,
      fullName: json['fullName'] ?? '',
      registrationId: json['registrationId'] ?? '',
      profilePictureUrl: json['profilePictureUrl'],
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      status: json['status'] ?? '',
      degree: json['degree'] ?? '',
      experience: (json['experience'] is num)
          ? (json['experience'] as num).toDouble()
          : 0,
      clinicAddress: json['clinicAddress'] ?? '',
      specializationName: json['specializationName'] ?? '',
      latitude:
          (json['latitude'] is num) ? (json['latitude'] as num).toDouble() : 0,
      longitude: (json['longitude'] is num)
          ? (json['longitude'] as num).toDouble()
          : 0,
      averageRating: (json['averageRating'] is num)
          ? (json['averageRating'] as num).toDouble()
          : 0,
    );
  }
}
