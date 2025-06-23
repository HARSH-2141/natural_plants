import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About "),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/image/logo.jpeg', // Update with your logo path
                height: 100,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Welcome to Hair Heaven!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Your go-to app for effortless salon bookings! We believe that self-care should be simple, stress-free, and accessible to everyone. Our platform connects you with the best salons and beauty professionals in your area, making it easier than ever to book your next appointment.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "Why Choose Hair Heaven?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildFeature("Instant Bookings", "Find and book salon services in just a few taps."),
            _buildFeature("Wide Selection", "Explore top-rated salons offering haircuts, spa treatments, facials, and more."),
            _buildFeature("Verified Reviews", "Read real customer reviews to choose the best salon for you."),
            _buildFeature("Exclusive Offers", "Get special discounts and deals on your favorite beauty services."),
            _buildFeature("Convenient Payments", "Pay securely through the app or at the salon."),
            SizedBox(height: 20),
            Text(
              "Our Mission",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Our mission is to bring beauty and wellness closer to you by providing a seamless booking experience. Whether you need a quick trim, a full makeover, or a relaxing spa session, Hair Heaven is here to make it happen.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "📍 Available in multiple cities\n📅 Book anytime, anywhere",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),


          ],
        ),
      ),
    );
  }

  Widget _buildFeature(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.blueGrey),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
