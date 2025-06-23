import 'package:flutter/material.dart';
class about extends StatefulWidget {
  const about({super.key});

  @override
  State<about> createState() => _aboutState();
}

class _aboutState extends State<about> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About us"),),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
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
              "Welcome to Hair Heaven Admin Panel",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "At HairHeaven, we are dedicated to connecting salons and customers for an effortless and enjoyable beauty experience. Our platform empowers salon owners and administrators by providing a seamless solution for managing appointments, services, and customer interactions.",
              style: TextStyle(fontSize: 15,),
            ),
            SizedBox(height: 20,),
            Text("What We Offer",
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            _buildFeature("Salon Management","Easily add, edit, or remove salon details."),
            _buildFeature("Booking Management", "View and manage customer appointments."),
            _buildFeature("Stylist Management", "Track stylist performance and assign tasks."),
            _buildFeature("Customer Support", "Handle feedback and complaints efficiently."),
            _buildFeature("Analytics Dashboard", "Access reports and gain insights into salon performance."),
            const SizedBox(height: 20),
            SizedBox(height: 20,),
            Text(
                "Our Mission",
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            Text(
              "We are committed to providing a seamless booking experience for both customers and salons. "
                  "From haircuts to spa treatments, HairHeaven ensures every user finds the perfect service.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20,),
            Center(
              child: Text("Thank you for being a part of HairHeaven. Together, let's create a delightful salon experience for everyone.",
              style: TextStyle(fontStyle: FontStyle.italic),),
            )

          ],

        ),

      ),
    );
  }
  Widget _buildFeature(String title, String description){
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.blueGrey),
          SizedBox(width: 8),
          Expanded(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                  ),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14),
                  ),

                ],
              ) )
        ],
      ),
    );

  }
}
