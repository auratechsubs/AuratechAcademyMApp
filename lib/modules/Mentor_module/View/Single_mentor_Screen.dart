import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Course_module/Model/Course_Master_Model.dart';

class MentorDetailScreen extends StatelessWidget {
  final CourseInstructor mentor;
  MentorDetailScreen({super.key, required this.mentor});

  final List<Map<String, dynamic>> dummyReviews = [
    {
      "avatarUrl":
      "https://images.pexels.com/photos/4144221/pexels-photo-4144221.jpeg",
      "name": "Mary",
      "review":
      "This course has been very useful. Mentor was well spoken totally loved it.",
      "rating": "4.2",
      "likes": "760",
      "liked": true,
      "timeAgo": "2 Weeks Ago",
    },
    {
      "avatarUrl":
      "https://images.pexels.com/photos/4144221/pexels-photo-4144221.jpeg",
      "name": "Natasha B. Lambert",
      "review":
      "This course has been very useful. Mentor was well spoken totally loved it.",
      "rating": "4.8",
      "likes": "918",
      "liked": false,
      "timeAgo": "2 Weeks Ago",
    }
  ];


  String _generateEmail(String name) {
    final cleanedName = name.trim().toLowerCase().replaceAll(' ', '.');
    return '$cleanedName@auratechacademy.com';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    final imageUrl = mentor.image.isNotEmpty
        ? "https://api.auratechacademy.com/${mentor.image}"
        : "https://images.pexels.com/photos/4144221/pexels-photo-4144221.jpeg";
    final email = mentor.email.isNotEmpty ? mentor.email : _generateEmail(mentor.name.toString());

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: isTablet ? 28 : 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
        child: Column(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: isTablet ? 60 : 50,
              backgroundImage: NetworkImage(imageUrl),
              onBackgroundImageError: (_, __) => const AssetImage(
                  'assets/images/placeholder.png'),
            ),
            SizedBox(height: isTablet ? 16 : 12),

            // Name & Designation
            Text(
              mentor.name,
              style: GoogleFonts.lato(
                fontSize: isTablet ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              mentor.desig,
              style: GoogleFonts.lato(
                fontSize: isTablet ? 16 : 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),

            // Email
            Text(
              email,
              style: GoogleFonts.lato(
                fontSize: isTablet ? 14 : 12,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: isTablet ? 20 : 16),

            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat('Courses', mentor.email.toString(), isTablet),
                _buildStat('Experience', mentor.experience.toString(), isTablet),
                _buildStat('Ratings', mentor.rating.toString(), isTablet),
              ],
            ),
            SizedBox(height: isTablet ? 24 : 20),


            // Quote
            Container(
              padding: EdgeInsets.all(isTablet ? 18 : 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '"But can one now do so much as they did in the past?"',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: isTablet ? 16 : 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: isTablet ? 24 : 20),

            // Tab-like heading
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 15),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0A84FF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Courses",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isTablet ? 12 : 10),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Ratings",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 30 : 25),

            // Reviews
            ListView.builder(
              shrinkWrap: true,
              itemCount: dummyReviews.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final review = dummyReviews[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: isTablet ? 10 : 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isTablet ? 16 : 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(review["avatarUrl"]),
                          radius: isTablet ? 24 : 20,
                          onBackgroundImageError: (_, __) => const AssetImage(
                              'assets/images/placeholder.png'),
                        ),
                        SizedBox(width: isTablet ? 16 : 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    review["name"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: isTablet ? 16 : 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isTablet ? 10 : 8,
                                      vertical: isTablet ? 6 : 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.yellow[700],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.white,
                                          size: isTablet ? 16 : 14,
                                        ),
                                        SizedBox(width: isTablet ? 6 : 4),
                                        Text(
                                          review["rating"],
                                          style: TextStyle(
                                            fontSize: isTablet ? 14 : 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: isTablet ? 6 : 4),
                              Text(
                                review["review"],
                                style: TextStyle(
                                  fontSize: isTablet ? 14 : 12,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: isTablet ? 10 : 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.red[400],
                                    size: isTablet ? 20 : 18,
                                  ),
                                  SizedBox(width: isTablet ? 8 : 6),
                                  Text(
                                    review["likes"],
                                    style: TextStyle(
                                      fontSize: isTablet ? 14 : 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(width: isTablet ? 16 : 12),
                                  Text(
                                    review["timeAgo"],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: isTablet ? 14 : 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, bool isTablet) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 18 : 16,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: isTablet ? 14 : 12,
          ),
        ),
      ],
    );
  }
}