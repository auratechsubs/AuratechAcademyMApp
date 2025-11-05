import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../utils/storageservice.dart';
import '../../../widget/CongratulationWidget.dart';
import '../../Setting_Module/Controller/Order_History_Controller.dart';

class GoogleSigninController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final OrderHistoryController orderHistoryController = Get.find();

  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhoto = ''.obs;
  var idToken = ''.obs;
  var userPhone = ''.obs;
  var userId = ''.obs;

  Future<User?> googleLogin() async {
    print("🔁 Google Sign-In started...");

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        Get.snackbar("Cancelled", "Google Sign-In was cancelled.");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        // Set values to observable variables
        userName.value = user.displayName ?? '';
        userEmail.value = user.email ?? '';
        userPhoto.value = user.photoURL ?? '';
        idToken.value = googleAuth.idToken ?? '';
        userPhone.value = user.phoneNumber ?? "000000000";
        userPhone.value = user.phoneNumber ?? "000000000";
        userId.value = user.uid ?? "0000000";
        print("📩 Email: $userEmail");
        print("🪪 Token: $idToken");

        // Save data locally
        await StorageService.saveData('name', userName.value);
        await StorageService.saveData('email', userEmail.value);
        await StorageService.saveData('photo', userPhoto.value);
        await StorageService.saveData('Access_Token', idToken.value);
        await StorageService.saveData('number', userPhone.value);
        await StorageService.saveData('User_id', userId.value);

        Get.snackbar("Login Successful", "Welcome:-- ${userName.value}");
        print("✅ Logged in as ${userEmail.value}");

        Get.offAll(() => CongratulationsScreen(
              imagePath: 'assets/images/congratulationpic.png',
              title: 'Congratulations',
              subtitle: 'Your account is ready to use.\nRedirecting to home...',
              delaySeconds: 3,
            ));
        return user;
      } else {
        Get.snackbar("Error", "Firebase user is null.");
        return null;
      }
    } catch (error) {
      print("❌ Google Sign-In error: $error");
      Get.snackbar("Sign-In Failed", error.toString());
      return null;
    }
  }

  /// 🔓 Sign out user
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await StorageService.removeData("name");
      await StorageService.removeData("email");
      await StorageService.removeData("photo");

      Get.snackbar("Signed Out", "You have successfully signed out.");
    } catch (e) {
      print("❌ Sign-Out Error: $e");
      Get.snackbar("Sign-Out Failed", e.toString());
    }
  }
}
