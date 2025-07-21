import 'dart:convert';

import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/api.dart'; // Make sure ApiConfig is correctly imported
import 'package:merodoctor/models/doctor.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Models for Doctor Availability (Existing) ---
class DoctorAvailability {
  final List<AvailabilityDay> availabilities;

  DoctorAvailability({required this.availabilities});

  factory DoctorAvailability.fromJson(Map<String, dynamic> json) {
    var list = (json['availabilities'] as List)
        .map((e) => AvailabilityDay.fromJson(e))
        .toList();
    return DoctorAvailability(availabilities: list);
  }
}

class AvailabilityDay {
  final String dayOfWeek;
  final String availableDate;
  final List<TimeRange> timeRanges;

  AvailabilityDay({
    required this.dayOfWeek,
    required this.availableDate,
    required this.timeRanges,
  });

  factory AvailabilityDay.fromJson(Map<String, dynamic> json) {
    var list =
        (json['timeRanges'] as List).map((t) => TimeRange.fromJson(t)).toList();
    return AvailabilityDay(
      dayOfWeek: json['dayOfWeek'],
      availableDate: json['availableDate'],
      timeRanges: list,
    );
  }
}

class TimeRange {
  final String availableTime;
  final String isAvailable;

  TimeRange({required this.availableTime, required this.isAvailable});

  factory TimeRange.fromJson(Map<String, dynamic> json) {
    return TimeRange(
        availableTime: json['availableTime'], isAvailable: json['isAvailable']);
  }
}

// --- New Model for Reviews ---
class Review {
  final int ratingReviewId;
  final int doctorId;
  final String doctorName;
  final String userName;
  final int rating;
  final String review;
  final DateTime createdDate;

  Review({
    required this.ratingReviewId,
    required this.doctorId,
    required this.doctorName,
    required this.userName,
    required this.rating,
    required this.review,
    required this.createdDate,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      ratingReviewId: json['ratingReviewId'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'] ?? '',
      userName: json['userName'] ?? 'Anonymous Patient', // Default name
      rating: json['rating'],
      review: json['review'] ?? '',
      createdDate: DateTime.parse(json['createdDate']),
    );
  }
}

// --- Doctordetailspage Widget ---
class Doctordetailspage extends StatefulWidget {
  final Doctor doctor;

  const Doctordetailspage({super.key, required this.doctor});

  @override
  State<Doctordetailspage> createState() => _DoctordetailspageState();
}

class _DoctordetailspageState extends State<Doctordetailspage> {
  // Existing state for availability
  int selectedWeekdayIndex = 0;
  int? selectedDateIndex;
  int? selectedTimeIndex;
  bool isLoadingAvailability = false;
  DoctorAvailability? doctorAvailability;
  final List<String> weekDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  // New state for rating and reviews
  int _currentSelectedRating =
      0; // The star rating chosen by the current user in dialog
  TextEditingController _reviewController = TextEditingController();
  int? _userRatingReviewId; // ID of the user's existing review, if any
  bool _isSubmittingRating = false;

  double _displayedAverageRating = 0.0; // The doctor's overall average rating
  List<Review> _reviews = []; // List of all reviews for this doctor
  bool _isLoadingRatings = false;

  @override
  void initState() {
    super.initState();
    // Initialize _displayedAverageRating with the doctor's initial rating
    _displayedAverageRating = widget.doctor.averageRating;
    fetchAvailability();
    fetchDoctorRatings(); // Fetch all doctor ratings
    fetchUserRating(); // Fetch current user's rating for this doctor
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // --- Availability Fetching (Existing) ---
  Future<void> fetchAvailability() async {
    setState(() {
      isLoadingAvailability = true;
    });
    try {
      final token = await _getToken();
      if (token == null) {
        setState(() {
          isLoadingAvailability = false;
        });
        return;
      }
      final url = Uri.parse(ApiConfig.getAvailability(widget.doctor.userId));
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          setState(() {
            doctorAvailability =
                DoctorAvailability.fromJson(jsonResponse['data']);
            doctorAvailability!.availabilities
                .removeWhere((a) => a.availableDate == '0001-01-01');

            final availableWeekdays = doctorAvailability!.availabilities
                .map((a) => _weekdayStringToIndex(a.dayOfWeek))
                .toSet();

            if (!availableWeekdays.contains(selectedWeekdayIndex) &&
                availableWeekdays.isNotEmpty) {
              selectedWeekdayIndex = availableWeekdays.first;
            }
            selectedDateIndex = null;
            selectedTimeIndex = null;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching availability: $e');
    } finally {
      setState(() {
        isLoadingAvailability = false;
      });
    }
  }

  void _selectWeekday(int index) {
    setState(() {
      selectedWeekdayIndex = index;
      selectedDateIndex = null;
      selectedTimeIndex = null;
    });
  }

  int _weekdayStringToIndex(String day) {
    switch (day.toLowerCase().trim()) {
      case 'sunday':
        return 0;
      case 'monday':
        return 1;
      case 'tuesday':
        return 2;
      case 'wednesday':
        return 3;
      case 'thursday':
        return 4;
      case 'friday':
        return 5;
      case 'saturday':
        return 6;
      default:
        return -1;
    }
  }

  // --- Time Conversion (Existing) ---
  String convertToDotNetTimeOnlyString(String time12h) {
    try {
      // Assuming format "HH:MM AM/PM" or "H:MM AM/PM"
      final parts = time12h.split(' ');
      String timePart = parts[0]; // e.g., "04:33" or "4:33"
      String ampmPart = parts[1].toUpperCase(); // e.g., "PM" or "AM"

      List<String> hourMinute = timePart.split(':');
      int hour = int.parse(hourMinute[0]);
      int minute = int.parse(hourMinute[1]);

      if (ampmPart == 'PM' && hour < 12) {
        hour += 12;
      } else if (ampmPart == 'AM' && hour == 12) {
        hour = 0; // 12 AM (midnight)
      }

      String convertedTime = '${hour.toString().padLeft(2, '0')}:'
          '${minute.toString().padLeft(2, '0')}:00';

      return convertedTime +
          '.0000000'; // Append .0000000 for DateTime.ParseExact on backend
    } catch (e) {
      debugPrint('Time conversion error: $e');
      return '00:00:00.0000000';
    }
  }

  // --- Booking and Payment (Existing) ---
  Future<String?> bookAppointmentApi({
    required int doctorId,
    required String availableDate,
    required String availableTime12h,
    required double price,
    required BuildContext context,
  }) async {
    final token = await _getToken();
    if (token == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication token missing.')),
        );
      }
      return null;
    }

    final dotNetTime = convertToDotNetTimeOnlyString(availableTime12h);

    final url = Uri.parse(ApiConfig.bookAppointment);
    final requestBody = jsonEncode({
      "dto": {
        "DoctorId": doctorId,
        "AvailableDate": availableDate,
        "AvailableTime": dotNetTime,
        "Price": price,
      }
    });

    debugPrint('Booking request body: $requestBody');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      debugPrint('Booking response status: ${response.statusCode}');
      debugPrint('Booking response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['success'] == true) {
          return jsonBody['data'] as String;
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonBody['message'] ?? 'Booking failed')),
            );
          }
        }
      } else {
        if (context.mounted) {
          final jsonBody = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(jsonBody['message'] ??
                    'Booking failed with status: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error booking appointment: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
    return null;
  }

  Future<void> confirmPaymentApi(String transactionId) async {
    final token = await _getToken();
    if (token == null) return;
    final url = Uri.parse(ApiConfig.confirmPayment);
    await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"transactionId": transactionId}),
    );
  }

  Future<void> failPaymentApi(String transactionId) async {
    final token = await _getToken();
    if (token == null) return;
    final url = Uri.parse(ApiConfig.failPayment);
    await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"transactionId": transactionId}),
    );
  }

  Future<void> _processPayment() async {
    if (doctorAvailability == null ||
        selectedDateIndex == null ||
        selectedTimeIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    List<AvailabilityDay> availabilitiesForDay = doctorAvailability!
        .availabilities
        .where(
            (a) => _weekdayStringToIndex(a.dayOfWeek) == selectedWeekdayIndex)
        .toList();

    if (selectedDateIndex! >= availabilitiesForDay.length) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid date selection.')));
      return;
    }
    final availability = availabilitiesForDay[selectedDateIndex!];

    if (selectedTimeIndex! >= availability.timeRanges.length) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid time selection.')));
      return;
    }
    final timeRange = availability.timeRanges[selectedTimeIndex!];

    final date = availability.availableDate;
    final time12h = timeRange.availableTime;
    final price = 1000.00; // Fixed price for now

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF1CA4AC)),
      ),
    );

    try {
      final transactionId = await bookAppointmentApi(
        doctorId: widget.doctor.doctorId,
        availableDate: date,
        availableTime12h: time12h,
        price: price,
        context: context,
      );

      // Pop the loading dialog
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();

      if (transactionId == null) return;

      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: Environment.test, // Use .live for production
          clientId:
              'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R', // Replace with your actual client ID
          secretId:
              'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==', // Replace with your actual secret ID
        ),
        esewaPayment: EsewaPayment(
          productId: transactionId,
          productName: "Doctor Appointment",
          productPrice: price.toString(),
          callbackUrl:
              'https://merodoctor.com/esewa_callback', // Your callback URL
        ),
        onPaymentSuccess: (EsewaPaymentSuccessResult data) async {
          await confirmPaymentApi(data.productId);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Appointment booked successfully!'),
                backgroundColor: Colors.green),
          );
          // If you want to pop the confirmation dialog after success
          Navigator.of(context).pop();
        },
        onPaymentFailure: (data) async {
          await failPaymentApi(transactionId);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Payment failed.'), backgroundColor: Colors.red),
          );
        },
        onPaymentCancellation: (data) async {
          await failPaymentApi(transactionId);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Payment cancelled.'),
                backgroundColor: Colors.red),
          );
        },
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Pop loading dialog
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Payment error: $e')));
      }
    }
  }

  void _showBookingConfirmation() {
    if (doctorAvailability == null ||
        selectedDateIndex == null ||
        selectedTimeIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a date and time slot first.')),
      );
      return;
    }

    List<AvailabilityDay> availabilitiesForDay = doctorAvailability!
        .availabilities
        .where(
            (a) => _weekdayStringToIndex(a.dayOfWeek) == selectedWeekdayIndex)
        .toList();

    if (selectedDateIndex! >= availabilitiesForDay.length) return;
    final availability = availabilitiesForDay[selectedDateIndex!];
    if (selectedTimeIndex! >= availability.timeRanges.length) return;
    final timeRange = availability.timeRanges[selectedTimeIndex!];

    final day = availability.dayOfWeek;
    final date = availability.availableDate;
    final time = timeRange.availableTime;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.edit_calendar_outlined,
            color: Color(0xFF1CA4AC), size: 50),
        title: const Text(
          'Book Appointment?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date : $day $date',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Time : $time',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const Text('Cost : Rs.1000.00', // Hardcoded price
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Divider(),
            const Center(child: Text('Payment with')),
            const SizedBox(height: 20),
            Center(
              child: Container(
                height: 60,
                width: 60,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(27)),
                child: Image.asset('assets/image/esewa.png'),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Cancel',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1CA4AC)))),
                InkWell(
                  onTap: () async {
                    Navigator.of(context, rootNavigator: true)
                        .pop(); // Pop this dialog
                    await _processPayment();
                  },
                  child: Container(
                    height: 30,
                    width: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1CA4AC),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text('Confirm',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // --- New Rating/Review Methods ---

  Future<void> fetchUserRating() async {
    setState(() {
      _isLoadingRatings =
          true; // Use this to indicate loading user rating too if needed
    });
    try {
      final token = await _getToken();
      if (token == null) {
        setState(() {
          _isLoadingRatings = false;
        });
        return;
      }

      // Corrected: Pass doctorId as String
      final url =
          Uri.parse(ApiConfig.getUserRating(widget.doctor.doctorId.toString()));
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final data = jsonResponse['data'];
          setState(() {
            _userRatingReviewId = data['ratingReviewId'];
            _currentSelectedRating = data['rating'];
            _reviewController.text =
                data['review'] ?? ''; // Set initial text for controller
          });
        } else {
          // No existing rating for this user or data is null
          setState(() {
            _userRatingReviewId = null;
            _currentSelectedRating = 0;
            _reviewController.clear(); // Clear text if no review
          });
        }
      } else if (response.statusCode == 404) {
        // Not found, meaning no rating for this user/doctor
        setState(() {
          _userRatingReviewId = null;
          _currentSelectedRating = 0;
          _reviewController.clear();
        });
      }
    } catch (e) {
      debugPrint('Error fetching user rating: $e');
    } finally {
      setState(() {
        _isLoadingRatings = false;
      });
    }
  }

  Future<void> fetchDoctorRatings() async {
    setState(() {
      _isLoadingRatings = true;
    });
    try {
      // Corrected: Pass doctorId as String
      final url = Uri.parse(
          ApiConfig.getDoctorRatings(widget.doctor.doctorId.toString()));
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final data = jsonResponse['data'];
          List<dynamic> reviewsJson = data['reviews'] ?? [];
          setState(() {
            _displayedAverageRating = (data['averageRating'] ?? 0).toDouble();
            _reviews = reviewsJson.map((r) => Review.fromJson(r)).toList();
          });
        } else {
          setState(() {
            _displayedAverageRating = 0.0;
            _reviews = [];
          });
        }
      } else {
        setState(() {
          _displayedAverageRating = 0.0;
          _reviews = [];
        });
      }
    } catch (e) {
      debugPrint('Error fetching doctor ratings: $e');
    } finally {
      setState(() {
        _isLoadingRatings = false;
      });
    }
  }

  Future<void> submitRating() async {
    if (_currentSelectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please select a star rating before submitting')));
      return;
    }

    setState(() {
      _isSubmittingRating = true;
    });
    try {
      final token = await _getToken();
      if (token == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication token missing.')),
          );
        }
        return;
      }

      final isUpdate = _userRatingReviewId != null;
      final url =
          Uri.parse(isUpdate ? ApiConfig.updateRating : ApiConfig.createRating);

      final body = jsonEncode({
        if (isUpdate) 'ratingReviewId': _userRatingReviewId,
        if (!isUpdate) 'doctorId': widget.doctor.doctorId,
        'rating': _currentSelectedRating,
        'review': _reviewController.text.trim(),
      });

      late http.Response response;
      if (isUpdate) {
        // Use PUT for update!
        response = await http.put(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: body,
        );
      } else {
        // Use POST for create!
        response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: body,
        );
      }

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      jsonResponse['message'] ?? 'Rating saved successfully!')),
            );
            Navigator.of(context).pop(); // Close dialog
          }
          await fetchDoctorRatings();
          await fetchUserRating();
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      jsonResponse['message'] ?? 'Failed to save rating.')),
            );
          }
        }
      } else {
        if (mounted) {
          final jsonResponse = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(jsonResponse['message'] ??
                    'Failed to save rating with status: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error submitting rating: $e');
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() {
        _isSubmittingRating = false;
      });
    }
  }

  void showRatingDialog() {
    // We fetch user rating before showing dialog to ensure it's up-to-date
    // However, if the dialog is cancelled, we want to revert to the state before opening the dialog.
    // So, we store the current values and only update if the dialog is successfully submitted.
    final int initialRatingForDialog = _currentSelectedRating;
    final String initialReviewForDialog = _reviewController.text;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          Widget star(int index) {
            return IconButton(
              iconSize: 36,
              icon: Icon(
                Icons.star,
                color: index <= _currentSelectedRating
                    ? Colors.amber
                    : Colors.grey[400],
              ),
              onPressed: () {
                setStateDialog(() {
                  _currentSelectedRating = index;
                });
              },
            );
          }

          return AlertDialog(
            title: const Text('Rate the Doctor'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) => star(i + 1)),
                ),
                const SizedBox(height: 12),
                TextField(
                  maxLines: 3,
                  controller: _reviewController, // Use the controller
                  decoration: const InputDecoration(
                    hintText: 'Write your review here...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              if (_isSubmittingRating)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: CircularProgressIndicator(),
                )
              else ...[
                TextButton(
                  onPressed: () {
                    // Revert to the state before opening the dialog
                    setState(() {
                      _currentSelectedRating = initialRatingForDialog;
                      _reviewController.text = initialReviewForDialog;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // submitRating will handle closing dialog and updating state
                    await submitRating();
                  },
                  child: const Text('Submit'),
                ),
              ],
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.doctor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios, size: 30)),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Text(
                      'Doctor Details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Icon(Icons.more_vert, size: 30),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(90, 28, 165, 172),
                      borderRadius: BorderRadius.circular(20),
                      image: (doc.profilePictureUrl != null &&
                              doc.profilePictureUrl!.isNotEmpty)
                          ? DecorationImage(
                              image: doc.profilePictureUrl!.startsWith('http')
                                  ? NetworkImage(doc.profilePictureUrl!)
                                  : NetworkImage(ApiConfig.baseUrl +
                                      doc.profilePictureUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: (doc.profilePictureUrl == null ||
                            doc.profilePictureUrl!.isEmpty)
                        ? Image.asset('assets/image/startpage2.png')
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doc.fullName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        Text(doc.specializationName,
                            style: const TextStyle(
                                color: Color.fromRGBO(158, 158, 158, 1),
                                fontWeight: FontWeight.bold)),
                        Text(doc.status,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green)),
                        Text('${doc.experience.toInt()} Year Experience'),
                        // Modified: Tap to rate
                        InkWell(
                          onTap: showRatingDialog, // Call the rating dialog
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(_displayedAverageRating.toStringAsFixed(1),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Schedule for Appointment',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final isSelected = index == selectedWeekdayIndex;
                  return GestureDetector(
                    onTap: () => _selectWeekday(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFF1CA4AC) : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFF1CA4AC)),
                      ),
                      child: Text(
                        weekDays[index].substring(0, 3),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoadingAvailability)
              const Center(child: CircularProgressIndicator())
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: (doctorAvailability == null ||
                        doctorAvailability!.availabilities.isEmpty)
                    ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('No available schedule found'),
                      )
                    : Builder(
                        builder: (context) {
                          List<AvailabilityDay> availabilitiesForDay =
                              doctorAvailability!.availabilities
                                  .where((a) =>
                                      _weekdayStringToIndex(a.dayOfWeek) ==
                                      selectedWeekdayIndex)
                                  .toList();

                          if (availabilitiesForDay.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(20),
                              child: Text('No availability on selected day.'),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(availabilitiesForDay.length,
                                (dateIndex) {
                              final availability =
                                  availabilitiesForDay[dateIndex];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    availability.availableDate,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: List.generate(
                                        availability.timeRanges.length,
                                        (timeIndex) {
                                      final timeRange =
                                          availability.timeRanges[timeIndex];
                                      final isAvailable =
                                          timeRange.isAvailable.toLowerCase() ==
                                              'yes';
                                      final isSelected =
                                          selectedDateIndex == dateIndex &&
                                              selectedTimeIndex == timeIndex;
                                      return GestureDetector(
                                        onTap: isAvailable
                                            ? () => setState(() {
                                                  selectedDateIndex = dateIndex;
                                                  selectedTimeIndex = timeIndex;
                                                })
                                            : null,
                                        child: Container(
                                          height: 40,
                                          width: 90,
                                          decoration: BoxDecoration(
                                            color: isAvailable
                                                ? (isSelected
                                                    ? const Color(0xFF1CA4AC)
                                                    : Colors.white)
                                                : Colors.grey.shade300,
                                            border: Border.all(
                                                color: const Color(0xFF1CA4AC)),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Text(timeRange.availableTime,
                                                style: TextStyle(
                                                  color: isAvailable
                                                      ? (isSelected
                                                          ? Colors.white
                                                          : Colors.black)
                                                      : Colors.grey,
                                                )),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            }),
                          );
                        },
                      ),
              ),
            if (doctorAvailability != null &&
                selectedDateIndex != null &&
                selectedTimeIndex != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1CA4AC),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: () {
                      _showBookingConfirmation();
                    },
                    child: const Text(
                      'Book Appointment',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // --- Corrected: Patient Reviews Section ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Patient Reviews',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  if (_isLoadingRatings &&
                      _reviews
                          .isEmpty) // Show loader if initially loading and no data
                    const Center(child: CircularProgressIndicator())
                  else if (_reviews.isEmpty)
                    const Text(
                        'No reviews yet. Be the first to rate this doctor!'),
                  // else // This 'else' correctly applies to the ListView
                  ListView.separated(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Important for nested scroll views
                    itemCount: _reviews.length,
                    separatorBuilder: (_, __) => const Divider(height: 20),
                    itemBuilder: (context, index) {
                      final review = _reviews[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                review.userName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(width: 10),
                              // Display stars for each review
                              Row(
                                children: List.generate(
                                    5,
                                    (i) => Icon(
                                          Icons.star,
                                          size: 18,
                                          color: i < review.rating
                                              ? Colors.amber
                                              : Colors.grey[300],
                                        )),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          if (review.review.isNotEmpty)
                            Text(review.review,
                                style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 5),
                          Text(
                            '${review.createdDate.toLocal().day}/${review.createdDate.toLocal().month}/${review.createdDate.toLocal().year}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
