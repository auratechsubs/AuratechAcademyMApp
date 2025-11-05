import 'package:flutter/material.dart';
import '../../../constant/constant_colors.dart';
import '../../Course_module/Model/Course_Master_Model.dart';
import 'Single_mentor_Screen.dart';

class TopMentorsScreen extends StatelessWidget {
  final List<CourseInstructor> mentors;

  const TopMentorsScreen({super.key, required this.mentors});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Top Mentors",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        itemCount: mentors.length,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
          vertical: 16,
        ),
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final mentor = mentors[index];
          final imageUrl = (mentor.image.isNotEmpty)
              ? "https://api.auratechacademy.com/${mentor.image}"
              : "https://images.pexels.com/photos/256262/pexels-photo-256262.jpeg";

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MentorDetailScreen(mentor: mentor),
                ),
              );
            },
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  vertical: width * 0.02,
                  horizontal: width * 0.04,
                ),
                leading: CircleAvatar(
                  radius: width * 0.08,
                  backgroundImage: NetworkImage(imageUrl),
                  backgroundColor: Colors.black12,
                ),
                title: Text(
                  mentor.name ?? "No Name",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  mentor.desig ?? "No Designation",
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
