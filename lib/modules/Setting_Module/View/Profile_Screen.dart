import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auratech_academy/utils/storageservice.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/controllers/localization_controller.dart';
import '../../../constant/constant_colors.dart';
import '../Controller/Order_History_Controller.dart';
import '../Model/Order_History_Model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final OrderHistoryController orderHistoryController = Get.find();

  final userPhoto = StorageService.getData("photo");
  final userName = StorageService.getData("name");
  final userNumber = StorageService.getData("number");
  final userEmail = StorageService.getData("email");
  final userId = StorageService.getData("User_id");

  double get totalOrderAmount {
    return orderHistoryController.orderHistoryList
        .fold(0.0, (sum, item) => sum + (item.totalPrice ?? 0));
  }

  void checkAndRefreshData() {
    Future.delayed(Duration.zero, () async {
      final shouldRefresh = StorageService.getData("refresh_profile") ?? false;
      if (shouldRefresh) {
        await orderHistoryController.fetchOrderHistory(
          userId: StorageService.getData("User_id"),
        );
        StorageService.saveData("refresh_profile", false);
      }
    });
  }

  Future<void> Getuserhistory() async {
    final userId = await StorageService.getData("User_id");

    if (userId != null && userId.toString().isNotEmpty) {
      await orderHistoryController.fetchOrderHistory(userId: userId);
    } else {
      debugPrint("⚠️ User ID is null or empty. Skipping history fetch.");
      orderHistoryController.errorMessage.value = "User not logged in.";
    }
  }

  @override
  void initState() {
    Getuserhistory();
    checkAndRefreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loc = Get.find<LocalizationController>(); // ← controller

    return Obx((){

      final size = MediaQuery.of(context).size;
      final isTablet = size.width > 600;
      final _ = loc.locale;
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: Text(
            'profile_title'.tr,
            style: GoogleFonts.roboto(
              fontSize: isTablet ? 24 : 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.background,
              size: isTablet ? 28 : 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 32 : 20,
            vertical: isTablet ? 40 : 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Avatar
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: isTablet ? 60 : 50,
                    backgroundImage: NetworkImage(
                      userPhoto ?? "https://i.pravatar.cc/300",
                    ),
                    backgroundColor: Colors.grey.shade200,
                    onBackgroundImageError: (_, __) => const AssetImage(
                        'assets/images/placeholder.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: Container(
                      padding: EdgeInsets.all(isTablet ? 8 : 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: Icon(
                        Icons.edit,
                        size: isTablet ? 20 : 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 40 : 30),

              // Profile Fields
              _buildField(
                label: "name".tr,
                value: userName ?? userId.toString(),
                isTablet: isTablet,
              ),
              SizedBox(height: isTablet ? 20 : 16),
              _buildField(
                label: "phone".tr,
                value: userNumber ?? "0000000000",
                isTablet: isTablet,
              ),
              SizedBox(height: isTablet ? 20 : 16),
              _buildField(
                label: "email".tr,
                value: userEmail ?? "N/A",
                isTablet: isTablet,
              ),
              SizedBox(height: isTablet ? 40 : 32),

              // Order History Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "order_history".tr,
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(height: isTablet ? 20 : 16),

              Obx(() {
                if (orderHistoryController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (orderHistoryController.errorMessage.isNotEmpty) {
                  return Text(
                    orderHistoryController.errorMessage.value,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: AppColors.textSecondary,
                    ),
                  );
                } else if (orderHistoryController.orderHistoryList.isEmpty) {
                  return Text(
                    "No order history found.",
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: AppColors.textSecondary,
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => orderHistoryController.fetchOrderHistory(
                    userId: int.parse(StorageService.getData("User_id") ?? "0"),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orderHistoryController.orderHistoryList.length,
                    itemBuilder: (context, index) {
                      final order = orderHistoryController.orderHistoryList[index];
                      return GestureDetector(
                        onTap: () => _showOrderDetailsDialog(context, order, isTablet),
                        child: _buildOrderCard(order, isTablet),
                      );
                    },
                  ),
                );
              }),

              SizedBox(height: isTablet ? 40 : 32),
              Obx(() {
                return Container(
                  alignment: Alignment.center,
                  height: isTablet ? 70 : 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isTablet ? 10 : 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'total_amount'.tr,
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "₹${totalOrderAmount.toStringAsFixed(2)}",
                          style:  GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    });

  }

  Widget _buildField({
    required String label,
    required String value,
    required bool isTablet,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:  GoogleFonts.lato(
            fontSize: isTablet ? 16 : 14,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: isTablet ? 8 : 6),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 20 : 16,
            vertical: isTablet ? 16 : 14,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            value,
            style:  GoogleFonts.lato(
              fontSize: isTablet ? 17 : 15,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(OrderData order, bool isTablet) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
      padding: EdgeInsets.all(isTablet ? 16 : 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderRow('order_id'.tr, "${order.id}", isTablet),
          _buildOrderRow('order_name'.tr, "${order.courseName}", isTablet),
          _buildOrderRow(
            'order_date'.tr,
            order.orderId!.createDate.toString().split("T").first ?? "",
            isTablet,
          ),
          _buildOrderRow(
            'billing_name'.tr,
            order.orderId!.user?.firstName.toString() ?? "",
            isTablet,
          ),
          _buildOrderRow('total_qty'.tr, order.quantity.toString(), isTablet),
          _buildOrderRow('total_amount'.tr, "₹${order.totalPrice ?? "0"}", isTablet),
        ],
      ),
    );
  }

  Widget _buildOrderRow(String title, String value, bool isTablet) {
    return Padding(
      padding: EdgeInsets.only(bottom: isTablet ? 8 : 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:  GoogleFonts.lato(
              color: AppColors.textSecondary,
              fontSize: isTablet ? 16 : 14,
            ),
          ),
          SizedBox(width: isTablet ? 10 : 7),
          Flexible(
            child: Text(
              value,
              style:  GoogleFonts.lato(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: isTablet ? 16 : 14,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetailsDialog(BuildContext context, OrderData order, bool isTablet) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(
          "Order Details",
          style: TextStyle(
            fontSize: isTablet ? 20 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: isTablet ? 12 : 10),
              _cupertinoDetail("Order ID", "${order.id}", isTablet),
              _cupertinoDetail("Order Name", "${order.courseName}", isTablet),
              _cupertinoDetail(
                "Date",
                order.orderId!.createDate.toString().split("T").first ?? "",
                isTablet,
              ),
              _cupertinoDetail(
                "Billing Name",
                order.orderId?.user?.firstName.toString() ?? "",
                isTablet,
              ),
              _cupertinoDetail(
                "Email",
                order.orderId!.emailAddress.toString() ?? "",
                isTablet,
              ),
              _cupertinoDetail(
                "Mobile",
                order.orderId!.phoneNo.toString() ?? "",
                isTablet,
              ),
              _cupertinoDetail("Qty", order.quantity.toString(), isTablet),
              _cupertinoDetail("Amount", "₹${order.totalPrice ?? "0"}", isTablet),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              "Close",
              style:  GoogleFonts.lato(
                fontSize: isTablet ? 16 : 14,
                color: CupertinoColors.destructiveRed,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _cupertinoDetail(String title, String value, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 6 : 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}