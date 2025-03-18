import 'package:flutter/material.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';

class InvestmentOpportunityCard extends StatelessWidget {
  final String title;
  final String location;
  final String marketPrice;
  final String purchasePrice;
  final String category;
  final String area;
  final String annualReturn;
  final String growth;
  final bool isDarkMode;
  final String image1;

  const InvestmentOpportunityCard({
    super.key,
    required this.title,
    required this.location,
    required this.marketPrice,
    required this.purchasePrice,
    required this.area,
    required this.isDarkMode,
    required this.annualReturn,
    required this.growth,
    required this.image1,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDarkMode ? ColorUtils.appbarBackgroundDark : Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isDarkMode
              ? ColorUtils.textFieldBorderColorDark
              : ColorUtils.textFieldBorderColorLight,
        ),
        borderRadius: BorderRadius.circular(1),
      ),
      child: SizedBox(
        height: 470,
        width: 310,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              image1,
              fit: BoxFit.fill,
              height: 180,
              width: double.infinity,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                      color: isDarkMode
                          ? ColorUtils.textFieldBorderColorDark
                          : ColorUtils.textFieldBorderColorLight,
                      width: 1,
                    )),
                color: isDarkMode
                    ? ColorUtils.appbarHorizontalLineDark
                    : ColorUtils.appbarHorizontalLineLight,
              ),
              child: Row(
                children: [
                  Image.asset(
                   ImageUtils.location,
                    height: 18,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(location,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: "Switzer",
                            color: Colors.grey,
                            fontSize: 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height:50,
                    child: Text(
                      title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "Switzer",
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildHotelAreaAndOther(
                          "assets/images/building.png", category),
                      const SizedBox(
                        width: 10,
                      ),
                      buildHotelAreaAndOther(
                          "assets/images/area.png", "$area SF Area"),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(child: buildPrices('\$${marketPrice}M', "Est.Market Price")),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(child: buildPrices('\$${purchasePrice}M', "Purchase Price"))
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  buildAnnual('Annual Return', '$annualReturn%'),
                  const SizedBox(
                    height: 10,
                  ),
                  buildAnnual('Growth', '$growth%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAnnual(String title, String returnPrice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: "Switzer",
              color: isDarkMode
                  ? ColorUtils.darkModeGrey2
                  : ColorUtils.textFieldBorderColorDark,
              fontSize: 14),
        ),
        Text(
          returnPrice,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: "Switzer",
              color:
              isDarkMode ? ColorUtils.whiteColor : ColorUtils.darkModeGrey2,
              fontSize: 16),
        ),
      ],
    );
  }

  Widget buildPrices(String price, String title) {
    return Container(
      height: 50,
      width: 130,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      color: isDarkMode
          ? ColorUtils.appbarHorizontalLineDark
          : ColorUtils.appbarHorizontalLineLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(price,
              style: TextStyle(
                  fontFamily: "Switzer",
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18)),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                  color: isDarkMode
                      ? ColorUtils.darkModeGrey2
                      : ColorUtils.textFieldBorderColorDark,
                  fontSize: 12,
                  fontFamily: "Switzer",
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w300),
            ),
          )
        ],
      ),
    );
  }

  Widget buildHotelAreaAndOther(String image, String title) {
    return Expanded(
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        color: isDarkMode
            ? ColorUtils.appbarHorizontalLineDark
            : ColorUtils.appbarHorizontalLineLight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              image,
              height: 20,
              width: 20,
            ),
            const SizedBox(
              width: 4,
            ),
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontFamily: "Switzer",
                    fontSize: 12, fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
      ),
    );
  }
}