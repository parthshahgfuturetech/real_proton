import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/modules/history/history_controller.dart';
import 'package:real_proton/modules/history/transfer_history/transfer_history_screen.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';
import 'package:real_proton/utils/theme.dart';
import 'package:real_proton/utils/widgets.dart';
class HistoryScreen extends StatefulWidget {
  final String firstName;

  HistoryScreen(this.firstName);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  final HistoryController controller = Get.put(HistoryController());
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.themeMode.value == ThemeMode.dark ||
        (themeController.themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Obx(
      () => SafeArea(
        top: false,
        child: Scaffold(
          appBar: buildAppBar(isDarkMode),
          backgroundColor:
              isDarkMode ? Colors.black : ColorUtils.scaffoldBackGroundLight,
          body: Stack(
            children: [
              if(controller.isLoading.value)...[
                Container(
                  color: Colors.black.withValues(alpha: 0.7),
                  child: CustomWidgets.buildLoader(),
                ),
              ]else if(controller.transactions.isEmpty)...[
                const Center(
                  child: Text("No Data Found",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Switzer",
                    ),
                  ),
                ),
              ]else...[
                Column(
                  children: [
                    buildAllTransactions(isDarkMode),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(bool isDarkMode) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor:
          isDarkMode ? ColorUtils.appbarBackgroundDark : Colors.white,
      title: buildAppBarTitle("Transaction History", isDarkMode),
      centerTitle: true,
      actions: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            filterBottomSheet(isDarkMode);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Image.asset(
              "assets/images/settings-sliders.png",
              height: 30,
              width: 30,
            ),
          ),
        ),
      ],
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: isDarkMode ? Colors.white : ColorUtils.appbarBackgroundDark,
          size: 15,
        ),
        onPressed: () {
          Get.back(); // Navigate back
        },
      ),
    );
  }

  Widget buildAppBarTitle(String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
        color: isDarkMode
            ? ColorUtils.indicaterGreyLight
            : ColorUtils.appbarHorizontalLineDark,
        fontWeight: FontWeight.w600,
        fontFamily: "Switzer",
        fontSize: 22,
      ),
    );
  }

  filterBottomSheet(bool isDarkMode) {
    return showModalBottomSheet(
      context: Get.context!,
      isDismissible: false,
      backgroundColor: ColorUtils.appbarBackgroundDark,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: Get.height - 150,
            child: buildFilterData(isDarkMode));
      },
    );
  }

  Widget buildFilterData(bool isDarkMode) {
    return Obx(
      () => SafeArea(
        bottom: true,
        minimum: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Filter",
                            style: TextStyle(
                              color: ColorUtils.whiteColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Switzer",
                              fontSize: 20,
                            ),
                          ),
                          Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                            decoration: BoxDecoration(
                            color: ColorUtils.transactionHistoryColor,
                            borderRadius: BorderRadius.circular(0),
                            ),
                            child: const Text("clear all"),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    buildTabBar(isDarkMode),
                    if (controller.activeTab.value == 0) ...[
                      buildCrypto()
                    ] else ...[
                      buildFlat()
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomWidgets.buildGetStartedButton(
                onPressed: (){
                  if(controller.activeTab.value == 0){
                  controller.fetchTransactionData();
                  }else{
                  controller.fetchFiatData();
                  }
                  Get.back();
                },
                text: "Apply",),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabBar(bool isDarkMode) {
    return Row(
      children: [
        buildTab(
          label: "Crypto",
          isSelected: controller.activeTab.value == 0,
          onTap: () => controller.activeTab.value = 0,
          isDarkMode: isDarkMode,
        ),
        buildTab(
          label: "Fiat",
          isSelected: controller.activeTab.value == 1,
          onTap: () => controller.activeTab.value = 1,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget buildTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromRGBO(249, 86, 22, 0.09)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? (isDarkMode
                        ? ColorUtils.loginButton
                        : ColorUtils.whiteColor)
                    : ColorUtils.textFieldBorderColorDark,
                width: 2, // Border thickness
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? (isDarkMode
                        ? ColorUtils.loginButton
                        : ColorUtils.whiteColor)
                    : (isDarkMode
                        ? ColorUtils.indicaterGreyLight
                        : ColorUtils.appbarHorizontalLineDark),
                fontWeight: FontWeight.w500,
                fontSize: 13,
                fontFamily: "Switzer",
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCrypto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20,),
        buildTitleText("Transaction Type"),
        buildFilterSection( controller.transactionType,
            ["All", "Incoming", "Outgoing"]),
        const SizedBox(height: 15,),
        Container(height: 2,color: ColorUtils.appbarHorizontalLineDark,),
        const SizedBox(height: 15,),
        buildTitleText("Method"),
        buildFilterSection( controller.method, ["USDC", "USDT","CELO","RP"]),
        const SizedBox(height: 15,),
        Container(height: 2,color: ColorUtils.appbarHorizontalLineDark,),
        const SizedBox(height: 15,),
        buildTitleText("Status"),
        buildFilterSection(
             controller.status, ["Completed", "Failed"]),
        const SizedBox(height: 15,),
        Container(height: 2,color: ColorUtils.appbarHorizontalLineDark,),
        const SizedBox(height: 15,),
        buildTitleText("BlockChain"),
        buildFilterSection(controller.blockchain,
            ["celo", "eth", "bsc", "matic"]),
      ],
    );
  }

  Widget buildFlat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20,),
        buildTitleText("Payment Status"),
        buildFilterSection(controller.paymentStatus,["Paid","Unpaid"]),
      ],
    );
  }

  Widget buildTitleText(String titleText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        titleText,
        style: const TextStyle(
          color: ColorUtils.darkModeGrey2,
          fontWeight: FontWeight.w500,
          fontSize: 18,
          fontFamily: "Switzer",
        ),
      ),
    );
  }

  Widget buildFilterSection(RxList<String> selectedList, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            children: options.map((option) {
              bool isSelected = selectedList.contains(option);
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => controller.toggleSelection(selectedList, option),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height:20,
                        width: 20,
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (_) =>
                              controller.toggleSelection(selectedList, option),
                          activeColor: ColorUtils.loginButton,
                          checkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                            visualDensity: VisualDensity.compact,
                        ),
                      ),
                      const SizedBox(width: 15,),
                      Text(
                        option,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildAllTransactions(bool isDarkMode) {
    return Expanded(
      child: ListView.builder(
        itemCount: controller.transactions.length,
        itemBuilder: (context, index) {
          final item = controller.transactions[index];
          // double rpAmount = CustomWidgets.weiToRP(item['amount'].toString());
          // String usdAmount = CustomWidgets.rpToUSD(rpAmount);
          int timestamp =
          // controller.activeTab.value == 0 ? item['createdAt'] ?? "":
          item['updatedAt'] ?? "";
          DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

          String formattedDate =
              "${date.day} ${CustomWidgets.getMonthName(date.month)} ${date.year}, "
              "${CustomWidgets.formatHour(date.hour)}:${CustomWidgets.formatMinute(date.minute)} ${CustomWidgets.getPeriod(date.hour)}";
          return GestureDetector(
            onTap: () {
              if(item['status'] == 'complete'){
                controller.fetchFiatDetailData(item['paymentId'], widget.firstName);
              }
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1),
              ),
              color: isDarkMode
                  ? ColorUtils.appbarBackgroundDark
                  : ColorUtils.bottomBarLight,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDarkMode
                        ? ColorUtils.appbarHorizontalLineDark
                        : ColorUtils.appbarHorizontalLineLight,
                  ),
                ),
                child: ListTile(
                  horizontalTitleGap: 10,
                  leading: Image.asset(
                    item['direction'] == "up"
                        ? isDarkMode
                            ? ImageUtils.arrowSellUpDark
                            : ImageUtils.arrowSellUpLight
                        : isDarkMode
                            ? ImageUtils.arrowSellDownDark
                            : ImageUtils.arrowSellDownLight,
                    height: 35,
                    width: 35,
                    fit: BoxFit.fill,
                  ),
                  title: Row(
                    children: [
                      Text(
                        // controller.activeTab.value == 0
                        //     ? item['type'] ?? "Buy"
                             item['payment_status'] ?? "Buy",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Switzer",
                          color: isDarkMode
                              ? ColorUtils.indicaterGreyLight
                              : ColorUtils.appbarHorizontalLineDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 6),
                        decoration: BoxDecoration(
                          color:
                          // controller.activeTab.value == 0
                              // ? item['status'] == 'COMPLETED'
                              // ? ColorUtils.statusCompletedColor
                              // :ColorUtils.statusFailColor
                              // :
                          item['status'] == 'complete'
                              ? ColorUtils.statusCompletedColor
                              : ColorUtils.statusFailColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          // controller.activeTab.value == 0
                          //     ? item['status']
                          // :
                          item['status'] == 'complete' ? 'COMPLETE' : 'PENDING',
                          style: TextStyle(
                            color:
                            // controller.activeTab.value == 0
                            //     ? item['status'] == 'COMPLETED'
                            //     ? ColorUtils.indicaterColor1
                            //     : ColorUtils.failSellColor
                            //     :
                            item['status'] == 'complete'
                                ? ColorUtils.indicaterColor1
                                : ColorUtils.failSellColor ,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Switzer",
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    formattedDate,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      fontFamily: "Switzer",
                      color:
                          isDarkMode ? Colors.grey : ColorUtils.darkModeGrey2,
                    ),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        // controller.activeTab.value == 0 ?
                        // "${item['amount'].toStringAsFixed(2)}"
                        //     :
                        "${item['amount_total'].toStringAsFixed(2)}",
                        style: TextStyle(
                          fontFamily: "Switzer",
                          fontSize: 14,
                          color: isDarkMode
                              ? ColorUtils.indicaterGreyLight
                              : ColorUtils.appbarHorizontalLineDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "",
                        style: TextStyle(
                          color: isDarkMode
                              ? ColorUtils.textFieldBorderColorDark
                              : ColorUtils.darkModeGrey2,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          fontFamily: "Switzer",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
