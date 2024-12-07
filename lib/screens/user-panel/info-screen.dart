// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Developer Team',
          style: TextStyle(
            color: Color(0xFF516B8C),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF516B8C)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Meet Our Team',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF516B8C),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'The awesome people behind this application',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            SizedBox(height: 30),

            // Developer 1
            DeveloperCard(
              name: 'Risnawati',
              role: 'Frontend Developer',
              imageUrl: 'assets/images/dev1baru.jpg',
              description:
                  'Passionate about creating beautiful and user-friendly interfaces',
              skills: ['Flutter', 'UI/UX', 'Firebase'],
              github: 'https://github.com/risnawatii',
            ),

            SizedBox(height: 20),

            // Developer 2
            DeveloperCard(
              name: 'Rizqi Satya H',
              role: 'Backend Developer',
              imageUrl: 'assets/images/dev2baru.jpg',
              description:
                  'Specialized in building robust and scalable backend systems',
              skills: ['Firebase', 'API', 'Database'],
              github: 'https://github.com/haprabb',
            ),
          ],
        ),
      ),
    );
  }
}

class DeveloperCard extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;
  final String description;
  final List<String> skills;
  final String github;

  const DeveloperCard({
    Key? key,
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.description,
    required this.skills,
    required this.github,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              gradient: LinearGradient(
                colors: [Color(0xFF516B8C), Color(0xFF7B8FB2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(imageUrl),
                backgroundColor: Colors.white,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Name and Role
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF516B8C),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  role,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 15),

                // Description
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 15),

                // Skills
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: skills
                      .map((skill) => Chip(
                            label: Text(
                              skill,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: Color(0xFF516B8C),
                          ))
                      .toList(),
                ),
                SizedBox(height: 20),

                // Social Links
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.link),
                      onPressed: () => launchUrl(Uri.parse(github)),
                      color: Color(0xFF516B8C),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
