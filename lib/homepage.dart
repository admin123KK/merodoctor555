import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:merodoctor/api.dart';
import 'package:merodoctor/blogpage.dart';
import 'package:merodoctor/doctordetailspage.dart';
import 'package:merodoctor/profilepage.dart';
import 'package:merodoctor/reportcheck.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Doctor {
  final String userId;
  final String fullName;
  final String specializationName;
  final double rating;

  Doctor({
    required this.userId,
    required this.fullName,
    required this.specializationName,
    this.rating = 4.5,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      specializationName: json['specializationName'] ?? '',
      rating:
          json.containsKey('rating') ? (json['rating'] as num).toDouble() : 4.5,
    );
  }
}

class Blog {
  final int blogId;
  final String title;
  final String? profilePicture;
  final String content;
  final String createdDate;
  final String categoryName;
  final String doctorName;
  final String blogPictureUrl;
  final int totalLikes;

  Blog({
    required this.blogId,
    required this.title,
    this.profilePicture,
    required this.content,
    required this.createdDate,
    required this.categoryName,
    required this.doctorName,
    required this.blogPictureUrl,
    required this.totalLikes,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      blogId: json['blogId'],
      title: json['title'],
      profilePicture: json['profilePicture'],
      content: json['content'],
      createdDate: json['createdDate'],
      categoryName: json['categoryName'],
      doctorName: json['doctorName'],
      blogPictureUrl: json['blogPictureUrl'],
      totalLikes: json['totalLikes'],
    );
  }
}

class Specialization {
  final int id;
  final String name;

  Specialization({required this.id, required this.name});

  factory Specialization.fromJson(Map<String, dynamic> json) {
    return Specialization(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String greeting = "";
  String patientName = "Sky";

  List<Specialization> specializations = [
    Specialization(id: 0, name: 'Select specialization'),
  ];
  Specialization? selectedSpecialization;

  List<Doctor> doctors = [];
  List<Blog> blogs = [];

  TextEditingController _searchController = TextEditingController();

  bool isLoadingDoctors = false;

  @override
  void initState() {
    super.initState();
    updateGreeting();
    fetchPatientDetails();
    fetchSpecializations();
    fetchBlogs();

    _searchController.addListener(() {
      _fetchDoctorsFiltered();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting = "Good morning";
    } else if (hour < 17) {
      greeting = "Good afternoon";
    } else {
      greeting = "Good evening";
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchPatientDetails() async {
    try {
      final token = await _getToken();
      if (token == null) return;
      final url = Uri.parse(ApiConfig.fetchPatientOwnDetails);
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'];
          setState(() {
            patientName = data['fullName'] ?? 'Sky';
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching patient details: $e');
    }
  }

  Future<void> fetchSpecializations() async {
    try {
      final response =
          await http.get(Uri.parse(ApiConfig.getAllSpecialization));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final List<dynamic> data = jsonResponse['data'];
          setState(() {
            specializations = [
              Specialization(id: 0, name: 'Specialization'),
              ...data.map((e) => Specialization.fromJson(e)).toList(),
            ];
            selectedSpecialization = specializations[0];
            _fetchDoctorsFiltered();
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching specializations: $e');
    }
  }

  Future<void> _fetchDoctorsFiltered() async {
    final searchText = _searchController.text.trim();
    if ((selectedSpecialization == null || selectedSpecialization!.id == 0) &&
        searchText.isEmpty) {
      // No specialization selected and search text empty: clear doctors and return
      if (doctors.isNotEmpty) {
        setState(() {
          doctors = [];
          isLoadingDoctors = false;
        });
      }
      return;
    }

    setState(() {
      isLoadingDoctors = true;
    });

    final token = await _getToken();
    if (token == null) {
      setState(() {
        isLoadingDoctors = false;
      });
      return;
    }

    try {
      Map<String, String> params = {};
      if (selectedSpecialization != null && selectedSpecialization!.id != 0) {
        params['specializationId'] = selectedSpecialization!.id.toString();
      }
      if (searchText.isNotEmpty) {
        params['doctorName'] = searchText;
      }

      final uri =
          Uri.parse(ApiConfig.doctorFilter).replace(queryParameters: params);

      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];
          setState(() {
            doctors = data.map((d) => Doctor.fromJson(d)).toList();
          });
        }
      } else if (response.statusCode == 404) {
        setState(() {
          doctors = [];
        });
      }
    } catch (e) {
      debugPrint('Error fetching filtered doctors: $e');
      setState(() {
        doctors = [];
      });
    } finally {
      setState(() {
        isLoadingDoctors = false;
      });
    }
  }

  Future<void> fetchBlogs() async {
    final token = await _getToken();
    if (token == null) return;

    final url = Uri.parse(ApiConfig.blogGetAll);
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final blogsJson = jsonResponse['data']['blogs'] as List<dynamic>;
          final fetchedBlogs = blogsJson.map((b) => Blog.fromJson(b)).toList();

          setState(() {
            blogs = fetchedBlogs;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching blogs: $e');
    }
  }

  bool _shouldShowDoctors() {
    final searchText = _searchController.text.trim();
    return (selectedSpecialization != null &&
            selectedSpecialization!.id != 0) ||
        searchText.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 65),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find your desire \nhealth Solution',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text('$greeting, $patientName',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<Specialization>(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    value: selectedSpecialization,
                    items: specializations
                        .map((spec) => DropdownMenuItem(
                              value: spec,
                              child: Text(spec.name),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedSpecialization = val;
                      });
                      _fetchDoctorsFiltered();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.black),
                      hintText: 'Search doctors...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            if (!_shouldShowDoctors())
              const SizedBox.shrink() // Show nothing initially
            else if (isLoadingDoctors)
              const Center(child: CircularProgressIndicator())
            else if (doctors.isEmpty)
              const Center(child: Text('No doctors found'))
            else
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(doctor.fullName),
                    subtitle: Text(doctor.specializationName),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Doctordetailspage()),
                      );
                    },
                  );
                },
              ),
            const SizedBox(height: 30),
            Container(
              height: 120,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: _AutoSlidingAdBanner(),
            ),
            const SizedBox(height: 30),
            _buildPromoCard(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('See all',
                      style: TextStyle(color: Color(0xFF1CA4AC))),
                ),
              ],
            ),
            const Text(
              'Top Doctor',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: doctors
                      .map((doctor) => _buildDoctorCard(
                          'assets/image/startpage3.png',
                          doctor.fullName,
                          doctor.specializationName,
                          doctor.rating))
                      .toList()),
            ),
            const SizedBox(height: 30),
            const Text(
              'Doctor Blogs',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            blogs.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: blogs.map((blog) {
                      String imageUrl = blog.blogPictureUrl.isNotEmpty
                          ? (blog.blogPictureUrl.startsWith('http')
                              ? blog.blogPictureUrl
                              : ApiConfig.baseUrl + blog.blogPictureUrl)
                          : 'assets/image/startpage1.png';

                      DateTime createdDateTime =
                          DateTime.tryParse(blog.createdDate) ?? DateTime.now();
                      String formattedTime =
                          DateFormat('MMM d, h:mm a').format(createdDateTime);

                      return _buildBlogCard(
                        imagePath: imageUrl,
                        title: blog.title,
                        description: blog.content,
                        doctorName: blog.doctorName,
                        category: '\n${blog.categoryName}',
                        time: formattedTime,
                        blogId: blog.blogId,
                        totalLikes: blog.totalLikes,
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildDoctorCard(
      String imagePath, String name, String speciality, double rating) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Doctordetailspage()),
            );
          },
          child: Container(
            width: 160,
            height: 220,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(93, 28, 165, 172),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 60,
                  backgroundImage: AssetImage(imagePath),
                ),
                const SizedBox(height: 8),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(speciality, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlogCard({
    required String imagePath,
    required String title,
    required String description,
    required String doctorName,
    required String time,
    required String category,
    required int blogId,
    required int totalLikes,
  }) {
    return Card(
      color: const Color.fromARGB(93, 28, 165, 172),
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imagePath.startsWith('http')
                  ? Image.network(imagePath,
                      height: 80, width: 80, fit: BoxFit.cover)
                  : Image.asset(imagePath,
                      height: 80, width: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlogDetailsPage(
                                blogId: blogId,
                                imagePath: imagePath,
                                title: title,
                                description: description,
                                doctorName: doctorName,
                                time: time,
                                category: category,
                                totalLikes: totalLikes,
                              )));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(description,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 5),
                    Text('$doctorName • $category • $time',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCard() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(90, 28, 165, 172),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Early Protection for \n your family',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Container(
                  height: 25,
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1CA4AC),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text('Learn more',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(70),
              ),
              child:
                  Image.asset('assets/image/startpage3.png', fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.home_outlined, size: 30, color: Color(0xFF1CA4AC)),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Reportcheck()),
                );
              },
              child: const Icon(Icons.qr_code_outlined, size: 30),
            ),
            const Icon(Icons.calendar_month_outlined, size: 30),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profilepage()),
                );
              },
              child: const Icon(Icons.person_outline_rounded, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}

class _AutoSlidingAdBanner extends StatefulWidget {
  @override
  State<_AutoSlidingAdBanner> createState() => _AutoSlidingAdBannerState();
}

class _AutoSlidingAdBannerState extends State<_AutoSlidingAdBanner> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  final List<String> _ads = [
    'assets/image/condom.png',
    'assets/image/operation.png',
    'assets/image/hospital.png',
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _ads.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (mounted) {
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      itemCount: _ads.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(_ads[index], fit: BoxFit.cover),
        );
      },
    );
  }
}
