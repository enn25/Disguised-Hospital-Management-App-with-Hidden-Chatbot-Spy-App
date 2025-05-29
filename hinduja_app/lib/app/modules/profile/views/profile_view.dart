// lib/app/modules/profile/views/profile_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/profile_controller.dart';
import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'images/logo.png', 
              height: 40,
            ),
            const SizedBox(width: 8)
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 10, 76, 133),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Notifications"),
                  content: const Text("You have new notifications."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Close"),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.amber,
                    backgroundImage: AssetImage('images/profile.jpg'),
                  ),
                ),
                Column(
                  children: [
                    Text('XYZ'),
                    Text('Nurse (Intern)',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: LayoutBuilder(
                builder: (context,constraint) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                      // flex: 1,
                      child: smallCard(
                          constraint.maxWidth,
                          'Patients',
                          '1057',
                          '4.5%',
                          'this month',
                          Icon(
                            size: constraint.maxWidth * 0.07,
                            Icons.person_2,
                            color: Colors.white,
                          ),
                          Colors.lightGreen)),
                  Expanded(
                      // flex: 1,
                      child: smallCard(
                          constraint.maxWidth,
                          'Cri. Cases',
                          '67',
                          '20%',
                          'this month',
                          Icon(
                            size: constraint.maxWidth * 0.07,
                            Icons.coronavirus_rounded,
                            color: Colors.white,
                          ),
                          Colors.pinkAccent)),
                  Expanded(
                    // flex: 1,
                    child: GestureDetector(
                      onLongPress: controller.handleSecretTap,
                      child: smallCard(
                          constraint.maxWidth,
                          'Vaccine',
                          '1057',
                          '36.5%',
                          'this month',
                          Icon(
                            size: constraint.maxWidth * 0.07,
                            Icons.vaccines_rounded,
                            color: Colors.white,
                          ),
                          Colors.blueAccent),
                    ),
                      ),
                    ],
                  );
                }
              ),
            ),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.names.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VitalSignsPage(
                            name: controller.names[index],
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage("images/avatar_${index % 5 + 1}.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(controller.names[index], style: const TextStyle(fontSize: 12))
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 4,
                child: TableCalendar(
                  focusedDay: DateTime.now(),
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Appointments",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.dailyAppointments.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: Text(controller.dailyAppointments[index]),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
            onDestinationSelected: controller.updateIndex,
            indicatorColor: const Color.fromARGB(255, 10, 76, 133),
            backgroundColor: const Color.fromARGB(255, 10, 76, 133),
            destinations: const [
              NavigationDestination(
                  label: 'Dashboard',
                  icon: Icon(color: Colors.white, Icons.home_rounded)),
              NavigationDestination(
                  label: 'Appoinments',
                  icon: Icon(color: Colors.white, Icons.bar_chart_rounded)),
              NavigationDestination(
                  label: 'Account',
                  icon: Icon(color: Colors.white, Icons.person)),
              NavigationDestination(
                  label: 'Settings',
                  icon: Icon(color: Colors.white, Icons.settings))
]),
  );
  }
}

Widget smallCard(double width, String title, String count, String growth,
    String timeline, Icon icon, Color clr) {
  return Card(
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.all(width * 0.02),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  radius: width * 0.05,
                  backgroundColor: clr,
                  child: icon,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: width * 0.035),
                    ),
                    Text(
                      count,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: width * 0.055),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  growth,
                  style: TextStyle(
                      fontSize: width * 0.035,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  timeline,
                  style: TextStyle(
                      fontSize: width * 0.03,
                      color: const Color.fromARGB(88, 0, 0, 0),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
  ));
}
class VitalSignsPage extends StatefulWidget {
  final String name;
  const VitalSignsPage({Key? key, required this.name}) : super(key: key);

  @override
  State<VitalSignsPage> createState() => _VitalSignsPageState();
}

class _VitalSignsPageState extends State<VitalSignsPage> {
  final int maxDataPoints = 100;
  final random = Random();
  
  // Data storage for vital signs
  List<double> heartRateData = [];
  List<double> bloodPressureData = [];
  List<double> spO2Data = [];
  
  // Current values
  double currentHeartRate = 75;
  double currentBP = 120;
  double currentSpO2 = 98;

  @override
  void initState() {
    super.initState();
    // Initialize with some data
    for (int i = 0; i < maxDataPoints; i++) {
      heartRateData.add(75 + random.nextDouble() * 10 - 5);
      bloodPressureData.add(120 + random.nextDouble() * 8 - 4);
      spO2Data.add(98 + random.nextDouble() * 2 - 1);
    }
    
    // Start periodic updates
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        updateData();
      }
    });
  }

  void updateData() {
    setState(() {
      // Update heart rate with realistic variations
      currentHeartRate += (random.nextDouble() * 2 - 1);
      currentHeartRate = currentHeartRate.clamp(60.0, 100.0);
      heartRateData.add(currentHeartRate);
      if (heartRateData.length > maxDataPoints) heartRateData.removeAt(0);

      // Update blood pressure
      currentBP += (random.nextDouble() * 1.5 - 0.75);
      currentBP = currentBP.clamp(110.0, 130.0);
      bloodPressureData.add(currentBP);
      if (bloodPressureData.length > maxDataPoints) bloodPressureData.removeAt(0);

      // Update SpO2
      currentSpO2 += (random.nextDouble() * 0.4 - 0.2);
      currentSpO2 = currentSpO2.clamp(95.0, 100.0);
      spO2Data.add(currentSpO2);
      if (spO2Data.length > maxDataPoints) spO2Data.removeAt(0);
    });
  }

  Widget buildVitalSignCard(String title, List<double> data, Color color, String unit, double currentValue) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  '${currentValue.toStringAsFixed(1)} $unit',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawHorizontalLine: true),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        data.length,
                        (index) => FlSpot(index.toDouble(), data[index]),
                      ),
                      isCurved: true,
                      color: color,
                      barWidth: 2,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: color.withOpacity(0.1),
                      ),
                    ),
                  ],
                  minX: 0,
                  maxX: maxDataPoints.toDouble(),
                  minY: data.reduce(min) - 5,
                  maxY: data.reduce(max) + 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Real-time Vital Signs",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  buildVitalSignCard("Heart Rate", heartRateData, Colors.red, "BPM", currentHeartRate),
                  buildVitalSignCard("Blood Pressure", bloodPressureData, Colors.blue, "mmHg", currentBP),
                  buildVitalSignCard("SpO2", spO2Data, Colors.green, "%", currentSpO2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final announcements = [
      {
        "title": "Medical Equipment Upgrade",
        "message": "Our Radiology Department has received new state-of-the-art MRI equipment. Improved scanning times starting next week.",
        "date": "2025-01-16",
        "priority": "high"
      },
      {
        "title": "Emergency Department Renovation",
        "message": "The East Wing Emergency Department will undergo renovation from Feb 1-15. Please use the West Wing entrance.",
        "date": "2025-01-16",
        "priority": "medium"
      },
      {
        "title": "New Specialist Joins Cardiology Team",
        "message": "We welcome Dr. Sarah Chen, renowned cardiologist, to our medical team. Appointments available starting February.",
        "date": "2025-01-15",
        "priority": "low"
      },
      {
        "title": "Hospital App Maintenance",
        "message": "System maintenance scheduled for Sunday, 2AM-4AM. Some services may be temporarily unavailable.",
        "date": "2025-01-15",
        "priority": "medium"
      },
      {
        "title": "Blood Donation Drive",
        "message": "Urgent need for blood donors. Join our donation drive this weekend. All blood types needed.",
        "date": "2025-01-14",
        "priority": "high"
      },
      {
        "title": "New Parking System",
        "message": "Digital parking payment system launching next week. Download the parking app for contactless payment.",
        "date": "2025-01-14",
        "priority": "low"
      },
      {
        "title": "Flu Season Alert",
        "message": "Increased flu cases reported. Free flu shots available at the Preventive Care Unit.",
        "date": "2025-01-13",
        "priority": "high"
      },
      {
        "title": "Extended Pharmacy Hours",
        "message": "Main pharmacy now open 24/7 to better serve our patients and staff.",
        "date": "2025-01-13",
        "priority": "medium"
      },
      {
        "title": "New Patient Portal Features",
        "message": "Access your lab results and schedule appointments through our updated patient portal.",
        "date": "2025-01-12",
        "priority": "low"
      },
      {
        "title": "Staff Training Day",
        "message": "Reduced outpatient services on Jan 20 due to annual staff training. Emergency services remain fully operational.",
        "date": "2025-01-12",
        "priority": "medium"
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Announcements"),
        backgroundColor: const Color.fromARGB(255, 10, 76, 133),
      ),
      body: ListView.builder(
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          final announcement = announcements[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(
                announcement["priority"] == "high"
                    ? Icons.warning
                    : announcement["priority"] == "medium"
                        ? Icons.info
                        : Icons.notifications,
                color: announcement["priority"] == "high"
                    ? Colors.red
                    : announcement["priority"] == "medium"
                        ? Colors.orange
                        : Colors.blue,
              ),
              title: Text(
                announcement["title"]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(announcement["message"]!),
                  const SizedBox(height: 4),
                  Text(
                    announcement["date"]!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color.fromARGB(255, 10, 76, 133),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                // Placeholder for backup chat functionality
                print("Chat backup initiated.");
              },
              child: const Text("Backup App"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: vibrateOtherPhone,
              child: const Text("Available"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Address: XXXX",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              "Contact: +1234567890",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void vibrateOtherPhone() {
    print("Vibration triggered on the other device.");
  }
}

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: const Color.fromARGB(255, 10, 76, 133),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('images/profile.jpg'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'XYZ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'xyz@*mail.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Account Details Section
              Text(
                'Account Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 4,
                child: ListTile(
                  leading: Icon(Icons.phone, color: Colors.blue),
                  title: Text('Phone Number'),
                  subtitle: Text('+00 12345 *****'),
                ),
              ),
              Card(
                elevation: 4,
                child: ListTile(
                  leading: Icon(Icons.location_city, color: Colors.blue),
                  title: Text('Address'),
                  subtitle: Text('XXX, XXX - XXXXX'),
                ),
              ),
              Card(
                elevation: 4,
                child: ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.blue),
                  title: Text('Date of Birth'),
                  subtitle: Text('JXYZ, 0000'),
                ),
              ),
              const SizedBox(height: 30),

              // Logout Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Currently, no action on click
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}