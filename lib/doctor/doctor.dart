class Doctor {
  final String name;
  final String speciality;
  final String about;
  final String experience;
  final String image; // asset path
  final bool isActive;

  const Doctor({
    required this.name,
    required this.speciality,
    required this.about,
    required this.experience,
    required this.image,
    this.isActive = true,
  });
}
