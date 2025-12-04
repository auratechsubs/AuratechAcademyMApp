import 'package:auratech_academy/utils/storageservice.dart';
import 'package:auratech_academy/widget/custombottombar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/constant_colors.dart';
import '../../../utils/logx.dart';
import '../../../utils/util_klass.dart';
import '../../Payment_module/View/Chekout_Screen.dart';
import '../Controller/Get_To_Cart.dart';
import '../Controller/Update_to_Cart.dart';
import '../Controller/delete_cart_item.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({super.key});

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  final GetCartItem getCartItem = Get.find();
  final DeleteCartItemController deleteCartItemController = Get.find();
  final IncreamentAndDecreamentController QuantityUpdateController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCartItem.fetchCartItems(StorageService.getData("User_id"));
    });
    LogX.printLog("User ID: ${StorageService.getData("User_id")}");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "my_courses_cart".tr,
          style: TextStyle(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (getCartItem.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (getCartItem.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              getCartItem.errorMessage.value,
              style: TextStyle(fontSize: isTablet ? 16 : 14),
            ),
          );
        }

        if (getCartItem.coursecartList.isEmpty) {
          return Center(
              child: TextButton(
                  onPressed: () {
                    Get.offAll(BottomnavBar());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "continue_shopping".tr,
                        style: TextStyle(color: AppColors.primary),
                      ),
                      SizedBox(width: 2,),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Icon(
                          Icons.arrow_forward,
                          color: AppColors.primary,
                          size: 12,
                        ),
                      )
                    ],
                  )));
        }

        return Padding(
          padding: EdgeInsets.only(
            left: isTablet ? 24 : 16,
            right: isTablet ? 24 : 16,
            top: isTablet ? 24 : 20,
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              await getCartItem
                  .fetchCartItems(StorageService.getData("User_id"));
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: getCartItem.coursecartList.length,
              itemBuilder: (context, index) {
                final item = getCartItem.coursecartList[index];

                return Container(
                  margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
                  padding: EdgeInsets.all(isTablet ? 12 : 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course Image
                      SizedBox(
                        width: isTablet ? 100 : 80,
                        height: isTablet ? 100 : 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            (item.courseImg ?? "").isNotEmpty
                                ? "https://api.auratechacademy.com/${item.courseImg}"
                                : 'https://api.auratechacademy.com/media/testimonial/testi_2_1_jrHSv5h.jpg',
                            height: isTablet ? 100 : 80,
                            width: isTablet ? 100 : 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                              size: isTablet ? 40 : 30,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isTablet ? 16 : 12),

                      // Course Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category
                            Text(
                              item.id?.toString() ?? "Category",
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: isTablet ? 14 : 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: isTablet ? 6 : 4),

                            // Title
                            Text(
                              item.courseName ?? "Title",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: isTablet ? 16 : 14,
                              ),
                            ),
                            SizedBox(height: isTablet ? 10 : 8),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await QuantityUpdateController
                                        .decrementQuantity(
                                      item.id!.toInt(),
                                      item.quantity!.toInt(),
                                    );
                                  },
                                  child: Icon(
                                    Icons.remove,
                                    size: isTablet ? 24 : 20,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(width: isTablet ? 12 : 10),
                                Obx(() {
                                  if (QuantityUpdateController.loadingItems
                                      .contains(item.id)) {
                                    return SizedBox(
                                      width: isTablet ? 24 : 20,
                                      height: isTablet ? 24 : 20,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      item.quantity?.toString() ?? '0',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: isTablet ? 14 : 12,
                                      ),
                                    );
                                  }
                                }),
                                SizedBox(width: isTablet ? 12 : 10),
                                GestureDetector(
                                  onTap: () async {
                                    await QuantityUpdateController
                                        .incrementQuantity(
                                      item.id!.toInt(),
                                      item.quantity!.toInt(),
                                    );
                                  },
                                  child: Icon(
                                    Icons.add,
                                    size: isTablet ? 24 : 20,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Price and Bookmark
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item.totalPrice?.toString() ?? '₹0',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isTablet ? 16 : 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: isTablet ? 20 : 15),
                          InkWell(
                            onTap: () => deleteCartItemController
                                .deleteCartItem(item.id!.toInt()),
                            child: Icon(
                              Icons.delete_outline,
                              size: isTablet ? 30 : 25,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        margin: EdgeInsets.only(bottom: isTablet ? 120 : 100),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () {
            if (getCartItem.coursecartList.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CheckoutScreen(
                    cartItems: getCartItem.coursecartList.toList(),
                  ),
                ),
              );
            } else {
              UtilKlass.showToastMsg("your_cart_is_empty".tr, context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: EdgeInsets.symmetric(vertical: isTablet ? 20 : 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "proceed_to_checkout".tr,
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: isTablet ? 18 : 16,
              )
            ],
          ),
        ),
      ),
    );
  }
}
