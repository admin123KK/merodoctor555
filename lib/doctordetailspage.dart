import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:merodoctor/homepage.dart';

class Doctordetailspage extends StatefulWidget {
  const Doctordetailspage({super.key});

  @override
  State<Doctordetailspage> createState() => _DoctordetailspageState();
}

class _DoctordetailspageState extends State<Doctordetailspage> {
  int selectedDayIndex = -1;
  int selectedTimeIndex = -1;

  final List<Map<String, String>> days = [
    {'day': 'Sun', 'date': '10'},
    {'day': 'Mon', 'date': '11'},
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
                  const Text(
                    'Doctor Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text('Dr. Sky Karki',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        Text('Orthopedist',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        Text('Active',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green)),
                        Text('5 Year Experience'),
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
                                              productPrice:
                                                  "20", // Set your price here
                                            ),
                                            onPaymentSuccess:
                                                (EsewaPaymentSuccessResult
                                                    data) {
                                              debugPrint(
                                                  ":::SUCCESS::: => $data");
                                              verifyTransactionStatus(data);
                                            },
                                            onPaymentFailure: (data) {
                                              debugPrint(
                                                  ":::FAILURE::: => $data");
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Payment failed.')),
                                              );
                                            },
                                            onPaymentCancellation: (data) {
                                              debugPrint(
                                                  ":::CANCELLATION::: => $data");
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
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
                                        await Future.delayed(
                                            const Duration(seconds: 2));

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
