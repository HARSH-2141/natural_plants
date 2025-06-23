import 'dart:convert';
import 'package:demo/CommonWidget/APIConst.dart';
import 'package:demo/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Slotbook extends StatefulWidget {
  final String? salonId;
  final String? totalPrice;
  final String? serviceId;
  final String? userId;

  const Slotbook({
    Key? key,
    required this.salonId,
    required this.serviceId,
    required this.totalPrice,
    this.userId = "1", // temporary static userId
  }) : super(key: key);

  @override
  _SlotbookState createState() => _SlotbookState();
}

class _SlotbookState extends State<Slotbook> {
  String? selectedStylist;
  String? selectedStylistId;
  
  bool isLoading = false;

  String? selectedSlot;
  String? selectedSlotId;

  List<Map<String, String>> stylists = [];
  List<Map<String, String>> slots = [];

  String? selectedPaymentMethod;

  final _formKey = GlobalKey<FormState>();
  String? cardNumber, expiryDate, cvv;

  @override
  void initState() {
    super.initState();
    fetchStylistsAndSlots();
  }

  Future<void> fetchStylistsAndSlots() async {
    await fetchStylists();
    await fetchSlots();
  }

  Future<void> fetchStylists() async {
    final url = Uri.parse("${ApiConst.base_url}user/user_fetch_stylist.php");
    final response = await http.post(url,
        headers: {'cookie': ApiConst.cookie, 'User-Agent': ApiConst.user_agent},
        body: {  'salon_id': widget.salonId ?? '',});

    final data = json.decode(response.body);
    print(response.body);
    if (!data['error']) {
      setState(() {
        stylists = List<Map<String, String>>.from(data['stylists'].map<Map<String, String>>((s) => {
          "stylist_id": s["stylist_id"].toString(),
          "name": s["name"].toString(),
        }));
      });
    }
  }

  Future<void> fetchSlots() async {
    final url = Uri.parse("${ApiConst.base_url}user/user_fetch_slot.php");
    final response = await http.post(url,
        headers: {'cookie': ApiConst.cookie, 'User-Agent': ApiConst.user_agent},
        body: {"salon_id": widget.salonId ?? ""});

    final data = json.decode(response.body);
    if (!data['error']) {
      setState(() {
        slots = List<Map<String, String>>.from(data['slots'].map<Map<String, String>>((slot) => {
          "id": slot["slot_id"].toString(),
          "display": "${slot["date"]} (${slot["start_time"]} - ${slot["end_time"]})",
        }));
      });
    }
  }

  void _validateAndProceed() {
    if (selectedStylistId == null ||
        selectedSlotId == null ||
        selectedPaymentMethod == null) {
      _showValidationPopup();
    } else if(selectedPaymentMethod == "Cash"){
      _submitBooking();
    } else if (selectedPaymentMethod == "Online" &&
        !_formKey.currentState!.validate()) {
      _showValidationPopup(message: "Please enter valid card details.");
    } else {
      _submitBooking();
    }
  }

  Future<void> _submitBooking() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse("${ApiConst.base_url}user/add_booking.php");

    final response = await http.post(url, headers: {
      'cookie': ApiConst.cookie,
      'User-Agent': ApiConst.user_agent
    }, body: {
      "user_id": widget.userId ?? "1",
      "salon_id": widget.salonId ?? '',
      "service_id": widget.serviceId ?? "",
      "stylist_id": selectedStylistId ?? "",
      "slot_id": selectedSlotId ?? "",
      "totalamount": widget.totalPrice ?? "",
      "status": "Pending",
    });
print(response.body);
    final data = json.decode(response.body);
    if (!data["error"]) {
      setState(() {
        isLoading = true;
      });
      _submitPayment(data["booking_id"].toString());
    } else {
      _showValidationPopup(message: data["message"] ?? "Booking failed");
    }
  }

  Future<void> _submitPayment(String bookingId) async {
    final url = Uri.parse("${ApiConst.base_url}user/add_payment.php");

    final response = await http.post(url, headers: {
      'cookie': ApiConst.cookie,
      'User-Agent': ApiConst.user_agent
    }, body: {
      "user_id": widget.userId ?? "1",
      "booking_id":bookingId,
      "amount":  widget.totalPrice ?? "",
      "method": selectedPaymentMethod == "Cash" ? "Cash": "Online",
      "transaction_id": selectedPaymentMethod == "Cash" ? "1" : "2",
      "status": "Completed",
    });
    print(response.body);
    final data = json.decode(response.body);
    if (!data["error"]) {
      _showConfirmationPopup();
    } else {
      _showValidationPopup(message: data["message"] ?? "Booking failed");
    }
  }

  void _showValidationPopup(
      {String message = "Please select all required details to proceed."}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Incomplete Information"),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("OK")),
        ],
      ),
    );
  }

  void _showConfirmationPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Booking Confirmed!"),
        content: Text("Your appointment has been successfully booked."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => DashboardPage()),
                      (Route<dynamic> route) => false);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  SizedBox(height: 20),
                  _buildSelectionCard(
                    title: "Select Stylist",
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text("Choose a stylist"),
                        value: selectedStylistId,
                        items: stylists.map((stylist) {
                          return DropdownMenuItem(
                            value: stylist["id"],
                            child: Text(stylist["name"]!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedStylistId = value;
                          });
                        },
                      ),
                    ),
                  ),
                  _buildSelectionCard(
                    title: "Select Slot",
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text("Choose a slot"),
                        value: selectedSlotId,
                        items: slots.map((slot) {
                          return DropdownMenuItem(
                            value: slot["id"],
                            child: Text(slot["display"]!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSlotId = value;
                          });
                        },
                      ),
                    ),
                  ),
                  _buildSelectionCard(
                    title: "Select Payment Method",
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: Text("Cash"),
                          value: "Cash",
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) =>
                              setState(() => selectedPaymentMethod = value),
                        ),
                        RadioListTile<String>(
                          title: Text("Online Payment"),
                          value: "Online",
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) =>
                              setState(() => selectedPaymentMethod = value),
                        ),
                      ],
                    ),
                  ),
                  if (selectedPaymentMethod == "Online")
                    _buildCardDetailsForm(),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: _submitBooking,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "Confirm Booking",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.deepPurple, Colors.white]),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Text(
          "Book Your Slot",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSelectionCard({required String title, required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              spreadRadius: 2,
              offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.purple)),
          SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildCardDetailsForm() {
    return Form(
      key: _formKey,
      child: _buildSelectionCard(
        title: "Enter Card Details",
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Card Number", border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              maxLength: 16,
              validator: (value) =>
                  value!.length != 16 ? "Enter a valid card number" : null,
              onSaved: (value) => cardNumber = value,
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Expiry Date (MM/YY)",
                  border: OutlineInputBorder()),
              keyboardType: TextInputType.datetime,
              validator: (value) => value!.isEmpty ? "Enter expiry date" : null,
              onSaved: (value) => expiryDate = value,
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "CVV", border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              maxLength: 3,
              validator: (value) =>
                  value!.length != 3 ? "Enter valid CVV" : null,
              onSaved: (value) => cvv = value,
            ),
          ],
        ),
      ),
    );
  }
}
