import 'dart:convert';
import 'dart:math';

import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merodoctor/api.dart';
import 'package:merodoctor/homepage.dart';

class Doctordetailspage extends StatefulWidget {
  const Doctordetailspage({super.key});

  @override
  State<Doctordetailspage> createState() => _DoctordetailspageState();
}

class _DoctordetailspageState extends State<Doctordetailspage> {
  int selectedDayIndex = -1;
  int selectedTimeIndex = -1;
  double rating = 0;
  final TextEditingController reviewController = TextEditingController();
  bool isLoading = false;

  Future<void> submitRatingReview() async {
    setState(() => isLoading = true);
    final response = await http.post(
      Uri.parse(ApiConfig.ratingUrl), // Replace with your real endpoint
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "doctorId": "73f759aec02d", // Replace with actual doctor ID
        "userId": "c9aad3b2673e", // Replace with current user ID
        "rating": rating,
        "review": reviewController.text.trim(),
      }),
    );

    setState(() => isLoading = false);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response.statusCode == 200
              ? 'Thank you for your feedback!'
              : 'Something went wrong.$e ',
        ),
        backgroundColor: response.statusCode == 200 ? Colors.green : Colors.red,
      ),
    );
  }

  final List<Map<String, String>> days = [
    {'day': 'Sun', 'date': '10'},
    {'day': 'Mon', 'date': '13'},
    {'day': 'Tue', 'date': '12'},
    {'day': 'Wed', 'date': '13'},
    {'day': 'Thu', 'date': '14'},
    {'day': 'Fri', 'date': '15'},
    {'day': 'Sat', 'date': '16'},
  ];

  final List<String> times = [
    '5:00 PM',
    '5:30 PM',
    '6:00 AM',
    '6:30 AM',
    '7:00 AM',
    '7:30 AM',
    '8:00 AM',
    '8:30 AM',
    '9:00 AM',
    '9:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '1:00  PM',
    '1:30  PM',
    '2:00  PM',
    '2:30  PM',
  ];
  void verifyTransactionStatus(EsewaPaymentSuccessResult result) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Homepage()));
                      },
                      child: const Icon(Icons.arrow_back_ios, size: 30)),
                  const SizedBox(
                    width: 20,
                  ),
                  const Expanded(
                    child: const Text(
                      'Doctor Details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
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
                    ),
                    child: Image.asset('assets/image/startpage2.png'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text('Dr. Sky Karki',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        const Text('Orthopedist',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        const Text('Active',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green)),
                        const Text('5 Year Experience'),
                        const Row(
                          children: [
                            Text(
                              'Rs.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '1000/',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: const Text("Rate & Review"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                              "How was your experience?"),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: List.generate(5, (index) {
                                              return IconButton(
                                                icon: Icon(
                                                  Icons.star,
                                                  color: index < rating
                                                      ? Colors.amber
                                                      : Colors.grey,
                                                ),
                                                onPressed: () => setState(
                                                    () => rating = index + 1.0),
                                              );
                                            }),
                                          ),
                                          TextField(
                                            controller: reviewController,
                                            maxLines: 3,
                                            decoration: const InputDecoration(
                                              hintText: "Write your review...",
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        if (isLoading)
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: CircularProgressIndicator(),
                                          )
                                        else ...[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("Cancel"),
                                          ),
                                          ElevatedButton(
                                            onPressed: submitRatingReview,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF1CA4AC),
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text("Submit"),
                                          ),
                                        ]
                                      ]);
                                });
                          },
                          child: Container(
                            height: 30,
                            width: 90,
                            decoration: BoxDecoration(
                              color: Color(0xFF1CA4AC),
                              borderRadius: BorderRadius.circular(27),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Rate',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow[700],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
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
                  'About',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(
                'An Orthopedist is a medical doctor who specializes in diagnosing, treating, and preventing conditions related \nto the bones, joints, muscles, ligaments, and tendons.\nThey help manage injuries, fractures, and musculoske-\nletal issues.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Schedule for Appointment',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Days section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(days.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDayIndex = index;
                      });
                    },
                    child: Container(
                      height: 60,
                      width: 50,
                      decoration: BoxDecoration(
                        color: selectedDayIndex == index
                            ? const Color(0xFF1CA4AC)
                            : Colors.white,
                        border: Border.all(color: const Color(0xFF1CA4AC)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              days[index]['day']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selectedDayIndex == index
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              days[index]['date']!,
                              style: TextStyle(
                                color: selectedDayIndex == index
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Divider(color: Color(0xFF1CA4AC)),
            ),

            // Times section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(times.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTimeIndex = index;
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                        color: selectedTimeIndex == index
                            ? const Color(0xFF1CA4AC)
                            : Colors.white,
                        border: Border.all(color: const Color(0xFF1CA4AC)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          times[index],
                          style: TextStyle(
                            color: selectedTimeIndex == index
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 35),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 45,
                    width: 50,
                    decoration: BoxDecoration(
                        color: const Color(0xFF1CA4AC),
                        borderRadius: BorderRadius.circular(17)),
                    child: const Icon(
                      Icons.message_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      final String dayText = selectedDayIndex != -1
                          ? '${days[selectedDayIndex]['day']}  ${days[selectedDayIndex]['date']}'
                          : '— no date selected —';

                      final String timeText = selectedTimeIndex != -1
                          ? times[selectedTimeIndex]
                          : '— no time selected —';

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            icon: const Icon(
                              Icons.edit_calendar_outlined,
                              color: Color(0xFF1CA4AC),
                              size: 50,
                            ),
                            title: const Text(
                              'Book appointment?',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date :  $dayText',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Time :  $timeText',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'Cost : Rs.1000',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Divider(),
                                Center(child: Text('Payement with')),
                                const SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(27),
                                    ),
                                    child:
                                        Image.asset('assets/image/esewa.png'),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.pop(context),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1CA4AC)),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (_) => const Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF1CA4AC),
                                            ),
                                          ),
                                        );
                                        await Future.delayed(
                                            const Duration(seconds: 2));
                                        try {
                                          EsewaFlutterSdk.initPayment(
                                            esewaConfig: EsewaConfig(
                                              environment: Environment
                                                  .test, // Change to Environment.live for production
                                              clientId:
                                                  'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R ',
                                              secretId:
                                                  'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==',
                                            ),
                                            esewaPayment: EsewaPayment(
                                              productId:
                                                  "APPT123", // You can customize this
                                              productName: "Doctor Appointment",
                                              productPrice: "20",
                                              callbackUrl:
                                                  '', // Set your price here
                                            ),
                                            onPaymentSuccess:
                                                (EsewaPaymentSuccessResult
                                                    data) {
                                              debugPrint(
                                                  ":::SUCCESS::: => $data");
                                              verifyTransactionStatus(data);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      backgroundColor:
                                                          Colors.green,
                                                      content: Text(
                                                          'Successfully Booked')));
                                            },
                                            onPaymentFailure: (data) {
                                              debugPrint(
                                                  ":::FAILURE::: => $data");
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                        'Payment failed.')),
                                              );
                                            },
                                            onPaymentCancellation: (data) {
                                              debugPrint(
                                                  ":::CANCELLATION::: => $data");
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                        'Payment cancelled.')),
                                              );
                                            },
                                          );
                                        } on Exception catch (e) {
                                          debugPrint(
                                              "EXCEPTION : ${e.toString()}");
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Exception: ${e.toString()}')),
                                          );
                                        }

                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(); // loader
                                        Navigator.of(context).pop(); // alert
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1CA4AC),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Confirm',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 170,
                      decoration: BoxDecoration(
                          color: const Color(0xFF1CA4AC),
                          borderRadius: BorderRadius.circular(18)),
                      child: const Center(
                        child: Text(
                          'Book Appointment',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
