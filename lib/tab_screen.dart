import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Setingan TabMenu
class TabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('SMK Negeri 4 '),
        ),
        body: TabBarView(
          children: [
            BerandaTab(),
            StudentDirectoryTab(),
            ProfilTab(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
            Tab(icon: Icon(Icons.group), text: 'Students'),
            Tab(icon: Icon(Icons.person), text: 'Profile'),
          ],
          labelColor: Color.fromARGB(255, 0, 0, 0), // Warna label aktif
          unselectedLabelColor: const Color.fromARGB(255, 0, 0, 0), // Warna label tidak aktif
          indicatorColor: const Color.fromARGB(255, 3, 0, 3), // Warna indikator
        ),
      ),
    );
  }
}

             
    // Layout untuk Tab Dashboard
class BerandaTab extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.calendar_month, 'label': 'Class Schedule'},
    {'icon': Icons.library_books, 'label': 'Materials'},
    {'icon': Icons.school, 'label': 'Activities Schedule'},
    {'icon': Icons.info, 'label': 'Information'},
    {'icon': Icons.assignment, 'label': 'Assignments'},
    {'icon': Icons.email, 'label': 'Email'},
    {'icon': Icons.list, 'label': 'Options'},
    {'icon': Icons.help_outline, 'label': 'Help'},
    {'icon': Icons.laptop, 'label': 'Courses'},
    {'icon': Icons.star, 'label': 'Achievements'},
    {'icon': Icons.phone_in_talk, 'label': 'Contact'},
    {'icon': Icons.flag, 'label': 'Mission & Vision'},
    {'icon': Icons.account_circle, 'label': 'About Us'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return GestureDetector(
            onTap: () {
              print('${item['label']} tapped');
            },
            child: Card(
              elevation: 5.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'], size: 50.0, color: Color.fromARGB(255, 250, 170, 207)), // Ubah warna ikon di sini
                  SizedBox(height: 8.0),
                  Text(
                    item['label'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
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


// Layout untuk Tab Student Directory
class StudentDirectoryTab extends StatelessWidget {
  Future<List<User>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Directory'),
      ),
      body: FutureBuilder<List<User>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(user.firstName[0]),
                  ),
                  title: Text(user.firstName),
                  subtitle: Text(user.email),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

// Layout untuk Tab My Profile
class ProfilTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/Hattori.jpg'),
              // Pastikan gambar profil sudah ada di folder assets
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'Hattori heiji',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              'Email: heijitori4@gmail.com',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
          SizedBox(height: 30),
          Text(
            '',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Nama Lengkap'),
            subtitle: Text('Heiji Hattori'),
          ),
          
          ListTile(
            leading: Icon(Icons.cake),
            title: Text('Tanggal Lahir'),
            subtitle: Text('4 April 2005'),
          ),

         

          
          
        ],
      ),
    );
  }
}

class User {
  final String firstName;
  final String email;
  User({required this.firstName, required this.email});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      email: json['email'],
    );
  }
}
