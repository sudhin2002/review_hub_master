import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:review_hub_admin/add.dart';
import 'package:review_hub_admin/babyproducts.dart';
import 'package:review_hub_admin/channels.dart';
import 'package:review_hub_admin/constants/color.dart';
import 'package:review_hub_admin/customWidgets/customText.dart';
import 'package:review_hub_admin/login.dart';
import 'package:review_hub_admin/movies.dart';
import 'package:review_hub_admin/restaurents.dart';
import 'package:review_hub_admin/services.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

   Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getData() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('reviews').get();
    return querySnapshot.docs;
  }

  void _showNotificationDialog() {
    final overlay = Overlay.of(context)!;
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        right: 10,
        child: Material(
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.white,
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextButton(
                  child: Text('Dismiss'),
                  onPressed: () => overlayEntry.remove(),
                ),
                FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: snapshot.data!.map((doc) => Card(
                      child: ListTile(
                        title: Text(doc['user'] ?? 'No Name'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc['item'] ?? 'No Category'),
                            Text(doc['review'] ?? 'No Category'),
                          ],
                        ),
                      ),
                    )).toList(),
                  );
                }  else {
                      return Text('No notifications');
                    }
                  },
                ),
                
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: maincolor, // Ensure this is the correct variable name
        title: AppText(
          size: 20,
          text: 'REVIEW HUB',
          weight: FontWeight.normal,
          textcolor: white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: _showNotificationDialog,
          ),
          const SizedBox(width: 20),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
      backgroundColor: grey,
      body: Stack(
        children: [
          const Positioned.fill(
            child: Image(
              image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Text(
              'A great mobile app is like a work of art; it captivates and inspires.',
              style: GoogleFonts.poppins(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: maincolor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      endDrawer: _buildDrawer(),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Add drawer header if needed
          _buildDrawerItem(icon: Icons.home, title: 'Home', onTap: () => Dashboard()),
          SizedBox(height: 15,),
          _buildDrawerItem(icon: Icons.movie, title: 'Movies', page: Movies()),
          SizedBox(height: 15,),
          _buildDrawerItem(icon: Icons.restaurant, title: 'Restaurants', page: Restaurants()),
          SizedBox(height: 15,),
          _buildDrawerItem(icon: Icons.tv, title: 'Channels', page: Channel()),
          SizedBox(height: 15,),
          _buildDrawerItem(icon: Icons.build, title: 'Services', page: Services()),
          SizedBox(height: 15,),
          _buildDrawerItem(icon: Icons.child_friendly, title: 'Baby Products', page: BabyProducts()),
          SizedBox(height: 15,),
          _buildDrawerItem(icon: Icons.add, title: 'Add', page: Add()),
          SizedBox(height: 15,),
          _buildDrawerItem(icon: Icons.exit_to_app, title: 'Logout', page: Login()),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem({required IconData icon, required String title, Widget? page, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: AppText(
        size: 25,
        text: title,
        textcolor: maincolor,
        weight: FontWeight.w600,
      ),
      onTap: () {
        Navigator.pop(context); // Always close the drawer
        if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        }
        onTap?.call();
      },
    );
  }
}
