//
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'API Data Examples',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         appBarTheme: AppBarTheme(
//           color: Colors.blue.shade700,
//           foregroundColor: Colors.white,
//           elevation: 4,
//           titleTextStyle: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         cardTheme: CardTheme(
//           elevation: 5,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blue.shade600,
//             foregroundColor: Colors.white,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//           ),
//         ),
//       ),
//       home: HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('API Data Examples'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GridView.count(
//           crossAxisCount: 2,
//           crossAxisSpacing: 16.0,
//           mainAxisSpacing: 16.0,
//           children: <Widget>[
//             _buildApiCard(context, 'Joke API', Icons.sentiment_very_satisfied, jokeApidata()),
//             _buildApiCard(context, 'ISRO Data API', Icons.rocket_launch, IsroData()),
//             _buildApiCard(context, 'Population Data API', Icons.people, Population()),
//             _buildApiCard(context, 'COVID-19 Data API', Icons.local_hospital, CovidPage()),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildApiCard(BuildContext context, String title, IconData icon, Widget targetPage) {
//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => targetPage),
//           );
//         },
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Icon(icon, size: 50, color: Theme.of(context).primaryColor),
//             SizedBox(height: 10),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // --- Joke API Data Class ---
// class jokeApidata extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return jokeApidataState();
//   }
// }
//
// class jokeApidataState extends State<jokeApidata> {
//   String _jokeType = "";
//   String _jokeSetup = "";
//   String _jokePunchline = "";
//   String _jokeId = "";
//   bool _isLoading = false;
//   String _errorMessage = "";
//
//   Future<void> getData() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = "";
//       _jokeType = "";
//       _jokeSetup = "";
//       _jokePunchline = "";
//       _jokeId = "";
//     });
//
//     try {
//       final response = await http.get(Uri.parse("https://official-joke-api.appspot.com/random_joke"));
//       print("+++++ ${response.body}"); // Log the raw response body
//       if (response.statusCode == 200) {
//         Map<String, dynamic> mydata = json.decode(response.body);
//         setState(() {
//           _jokeType = mydata["type"] ?? "N/A";
//           _jokeSetup = mydata["setup"] ?? "N/A";
//           _jokePunchline = mydata["punchline"] ?? "N/A";
//           _jokeId = (mydata["id"] ?? "N/A").toString();
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _errorMessage = "Error: ${response.statusCode}. Could not load joke.";
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = "Failed to load data: $e. Check your internet connection.";
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Random Joke Generator")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ElevatedButton.icon(
//               onPressed: _isLoading ? null : getData, // Disable button while loading
//               icon: Icon(Icons.refresh),
//               label: Text(_isLoading ? "Loading Joke..." : "Load New Joke"),
//             ),
//             SizedBox(height: 20),
//             if (_isLoading)
//               Center(child: CircularProgressIndicator())
//             else if (_errorMessage.isNotEmpty)
//               _buildErrorCard(_errorMessage)
//             else if (_jokeSetup.isNotEmpty) // Check if joke data has been loaded
//                 Column(
//                   children: [
//                     _buildDetailedInfoCard("Joke Type", _jokeType, Icons.category),
//                     SizedBox(height: 10),
//                     _buildDetailedInfoCard("Setup", _jokeSetup, Icons.lightbulb_outline),
//                     SizedBox(height: 10),
//                     _buildDetailedInfoCard("Punchline", _jokePunchline, Icons.tag_faces),
//                     SizedBox(height: 10),
//                     _buildDetailedInfoCard("Joke ID", _jokeId, Icons.numbers),
//                   ],
//                 )
//               else
//                 _buildInitialMessageCard("Press 'Load New Joke' to fetch a random joke!")
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailedInfoCard(String title, String content, IconData icon) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: Theme.of(context).primaryColor, size: 24),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Text(
//               content,
//               style: TextStyle(fontSize: 16, color: Colors.black87),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorCard(String message) {
//     return Card(
//       elevation: 4,
//       color: Colors.red.shade100,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Icon(Icons.error_outline, color: Colors.red, size: 40),
//             SizedBox(height: 10),
//             Text(
//               "Error:",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.red,
//               ),
//             ),
//             SizedBox(height: 5),
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.red.shade800),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInitialMessageCard(String message) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Icon(Icons.lightbulb_outline, color: Colors.amber, size: 40),
//             SizedBox(height: 10),
//             Text(
//               "Welcome!",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//             SizedBox(height: 5),
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // --- ISRO Data Class ---
// class IsroData extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return IsroDataState();
//   }
// }
//
// class IsroDataState extends State<IsroData> {
//   List<String> _spacecraftNames = [];
//   bool _isLoading = false;
//   String _errorMessage = "";
//
//   Future<void> getRecord() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = "";
//       _spacecraftNames = [];
//     });
//
//     try {
//       final response = await http.get(Uri.parse("https://isro.vercel.app/api/spacecrafts"));
//       print("+++++ ${response.body}"); // Log the raw response body
//       if (response.statusCode == 200) {
//         Map<String, dynamic> mydata = json.decode(response.body);
//         List<dynamic> spacecrafts = mydata["spacecrafts"] ?? [];
//         setState(() {
//           _spacecraftNames = spacecrafts.map((e) => e["name"].toString()).toList();
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _errorMessage = "Error: ${response.statusCode}. Could not load ISRO data.";
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = "Failed to load data: $e. Check your internet connection.";
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("ISRO Spacecraft Data")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ElevatedButton.icon(
//               onPressed: _isLoading ? null : getRecord,
//               icon: Icon(Icons.download),
//               label: Text(_isLoading ? "Loading Data..." : "Load ISRO Spacecraft Data"),
//             ),
//             SizedBox(height: 20),
//             if (_isLoading)
//               Center(child: CircularProgressIndicator())
//             else if (_errorMessage.isNotEmpty)
//               _buildErrorCard(_errorMessage)
//             else if (_spacecraftNames.isNotEmpty)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildDetailedInfoCard("Total Spacecrafts", _spacecraftNames.length.toString(), Icons.numbers),
//                     SizedBox(height: 10),
//                     _buildDetailedInfoCard("First Spacecraft", _spacecraftNames.first, Icons.first_page),
//                     SizedBox(height: 10),
//                     _buildDetailedInfoCard("Latest Spacecraft", _spacecraftNames.last, Icons.last_page),
//                     SizedBox(height: 20),
//                     Text(
//                       "All Spacecrafts:",
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 10),
//                     Column(
//                       children: _spacecraftNames.map((name) =>
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 4.0),
//                             child: Text("- $name", style: TextStyle(fontSize: 15)),
//                           ),
//                       ).toList(),
//                     ),
//                   ],
//                 )
//               else
//                 _buildInitialMessageCard("Press 'Load ISRO Spacecraft Data' to fetch the list of spacecrafts.")
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailedInfoCard(String title, String content, IconData icon) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: Theme.of(context).primaryColor, size: 24),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Text(
//               content,
//               style: TextStyle(fontSize: 16, color: Colors.black87),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorCard(String message) {
//     return Card(
//       elevation: 4,
//       color: Colors.red.shade100,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Icon(Icons.error_outline, color: Colors.red, size: 40),
//             SizedBox(height: 10),
//             Text(
//               "Error:",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.red,
//               ),
//             ),
//             SizedBox(height: 5),
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.red.shade800),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInitialMessageCard(String message) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Icon(Icons.info_outline, color: Colors.blue, size: 40),
//             SizedBox(height: 10),
//             Text(
//               "Information:",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//             SizedBox(height: 5),
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // --- Population Data Class ---
// class Population extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return PopulationState();
//   }
// }
//
// class PopulationState extends State<Population> {
//   int _keysCount = 0;
//   String _firstYear = "";
//   String _sourceName = "";
//   int _yearsDataCount = 0;
//   bool _isLoading = false;
//   String _errorMessage = "";
//   List<dynamic> _populationData = [];
//
//   Future<void> getdata() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = "";
//       _keysCount = 0;
//       _firstYear = "";
//       _sourceName = "";
//       _yearsDataCount = 0;
//       _populationData = [];
//     });
//
//     try {
//       final response = await http.get(Uri.parse(
//           "https://datausa.io/api/data?drilldowns=Nation&measures=Population"));
//       print("+++++ ${response.body}"); // Log the raw response body
//       if (response.statusCode == 200) {
//         Map<String, dynamic> mydata = json.decode(response.body);
//         setState(() {
//           _keysCount = mydata.keys.length;
//           _firstYear = (mydata["data"] != null && mydata["data"].isNotEmpty
//               ? mydata["data"][0]["Year"]
//               : "N/A")
//               .toString();
//           _sourceName = (mydata["source"] != null &&
//               mydata["source"].isNotEmpty &&
//               mydata["source"][0]["annotations"] != null
//               ? mydata["source"][0]["annotations"]["source_name"]
//               : "N/A");
//           _yearsDataCount = (mydata["data"] != null ? mydata["data"].length : 0);
//           _populationData = mydata["data"] ?? [];
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _errorMessage = "Error: ${response.statusCode}. Could not load population data.";
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = "Failed to load data: $e. Check your internet connection.";
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Center(child: Text("U.S. Population Data"))),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: _isLoading ? null : getdata,
//                 icon: Icon(Icons.public),
//                 label: Text(_isLoading ? "Loading Data..." : "Load Population Data"),
//               ),
//               SizedBox(height: 20),
//               if (_isLoading)
//                 Center(child: CircularProgressIndicator())
//               else if (_errorMessage.isNotEmpty)
//                 _buildErrorCard(_errorMessage)
//               else if (_populationData.isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildDetailedInfoCard("Count of Main Keys", _keysCount.toString(), Icons.vpn_key),
//                       SizedBox(height: 10),
//                       _buildDetailedInfoCard("First Recorded Year", _firstYear, Icons.date_range),
//                       SizedBox(height: 10),
//                       _buildDetailedInfoCard("Source Name", _sourceName, Icons.source),
//                       SizedBox(height: 10),
//                       _buildDetailedInfoCard("Number of Years Data Available", _yearsDataCount.toString(), Icons.calendar_month),
//                       SizedBox(height: 20),
//                       Text(
//                         "Population by Year:",
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 10),
//                       Column(
//                         children: _populationData.map((data) =>
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 4.0),
//                               child: Text(
//                                 "${data["Year"]}: ${data["Population"].toStringAsFixed(0)}",
//                                 style: TextStyle(fontSize: 15),
//                               ),
//                             ),
//                         ).toList(),
//                       ),
//                     ],
//                   )
//                 else
//                   _buildInitialMessageCard("Press 'Load Population Data' to view U.S. population statistics.")
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailedInfoCard(String title, String content, IconData icon) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: Theme.of(context).primaryColor, size: 24),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Text(
//               content,
//               style: TextStyle(fontSize: 16, color: Colors.black87),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorCard(String message) {
//     return Card(
//       elevation: 4,
//       color: Colors.red.shade100,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Icon(Icons.error_outline, color: Colors.red, size: 40),
//             SizedBox(height: 10),
//             Text(
//               "Error:",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.red,
//               ),
//             ),
//             SizedBox(height: 5),
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.red.shade800),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInitialMessageCard(String message) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Icon(Icons.bar_chart, color: Colors.green, size: 40),
//             SizedBox(height: 10),
//             Text(
//               "Demographics:",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//             SizedBox(height: 5),
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // --- COVID-19 Data Class ---
// class CovidPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return CovidPageState();
//   }
// }
//
// class CovidPageState extends State<CovidPage> {
//   String _sourceUrl = "";
//   String _secondStateLoc = "";
//   int _regionalCount = 0;
//   bool _isLoading = false;
//   String _errorMessage = "";
//   List<dynamic> _regionalData = [];
//
//   Future<void> getval() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = "";
//       _sourceUrl = "";
//       _secondStateLoc = "";
//       _regionalCount = 0;
//       _regionalData = [];
//     });
//
//     try {
//       final response = await http.get(Uri.parse("https://api.rootnet.in/covid19-in/stats"));
//       print("+++++ ${response.body}"); // Log the raw response body
//       if (response.statusCode == 200) {
//         Map<String, dynamic> mydata = json.decode(response.body);
//         setState(() {
//           _sourceUrl = (mydata["data"] != null &&
//               mydata["data"]["unofficial-summary"] != null &&
//               mydata["data"]["unofficial-summary"].isNotEmpty
//               ? mydata["data"]["unofficial-summary"][0]["source"]
//               : "N/A");
//           _regionalData = mydata["data"]["regional"] ?? [];
//           _secondStateLoc = (_regionalData.length > 1
//               ? _regionalData[1]["loc"]
//               : "N/A");
//           _regionalCount = _regionalData.length;
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _errorMessage = "Error: ${response.statusCode}. Could not load COVID-19 data.";
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = "Failed to load data: $e. Check your internet connection.";
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Center(child: Text("COVID-19 Data (India)"))),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: _isLoading ? null : getval,
//                 icon: Icon(Icons.coronavirus),
//                 label: Text(_isLoading ? "Loading Data..." : "Load COVID-19 Data"),
//               ),
//               SizedBox(height: 20),
//               if (_isLoading)
//                 Center(child: CircularProgressIndicator())
//               else if (_errorMessage.isNotEmpty)
//                 _buildErrorCard(_errorMessage)
//               else if (_regionalData.isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildDetailedInfoCard("Source URL", _sourceUrl, Icons.link),
//                       SizedBox(height: 10),
//                       _buildDetailedInfoCard("Example State (Second Entry)", _secondStateLoc, Icons.location_on),
//                       SizedBox(height: 10),
//                       _buildDetailedInfoCard("Number of States/Regions", _regionalCount.toString(), Icons.map),
//                       SizedBox(height: 20),
//                       Text(
//                         "Regional Data:",
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 10),
//                       ListView.builder(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: _regionalData.length,
//                         itemBuilder: (context, index) {
//                           final region = _regionalData[index];
//                           return Card(
//                             margin: EdgeInsets.symmetric(vertical: 8),
//                             elevation: 3,
//                             child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     region["loc"] ?? "N/A",
//                                     style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
//                                   ),
//                                   SizedBox(height: 5),
//                                   Text("Confirmed Cases (Indian): ${region["confirmedCasesIndian"] ?? 0}"),
//                                   Text("Confirmed Cases (Foreign): ${region["confirmedCasesForeign"] ?? 0}"),
//                                   Text("Discharged: ${region["discharged"] ?? 0}"),
//                                   Text("Deaths: ${region["deaths"] ?? 0}"),
//                                   Text("Total Confirmed: ${region["totalConfirmed"] ?? 0}"),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   )
//                 else
//                   _buildInitialMessageCard("Press 'Load COVID-19 Data' to get the latest statistics for India.")
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailedInfoCard(String title, String content, IconData icon) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: Theme.of(context).primaryColor, size: 24),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Text(
//               content,
//               style: TextStyle(fontSize: 16, color: Colors.black87),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorCard(String message) {
//     return Card(
//       elevation: 4,
//       color: Colors.red.shade100,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Icon(Icons.error_outline, color: Colors.red, size: 40),
//             SizedBox(height: 10),
//             Text(
//               "Error:",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.red,
//               ),
//             ),
//             SizedBox(height: 5),
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.red.shade800),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInitialMessageCard(String message) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Icon(Icons.health_and_safety, color: Colors.green, size: 40),
//             SizedBox(height: 10),
//             Text(
//               "Health Update:",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//             SizedBox(height: 5),
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }