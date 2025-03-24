import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:real_proton/main.dart';
import 'package:real_proton/utils/colors.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class CustomWidgets {
  static final rpToUsdRate = weiToRP(blockChainController.tokenPrice.value);
  static RxBool isConnected = false.obs;

  static void monitorNetwork() {
    _checkConnectivity();
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _updateConnectivity(results);
    });
  }

  static Future<void> _checkConnectivity() async {
    var results = await Connectivity().checkConnectivity();
    _updateConnectivity(results);
  }

  static void _updateConnectivity(List<ConnectivityResult> results) {
    var result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    isConnected.value = result != ConnectivityResult.none;
  }

  static Widget showNetworkStatus(bool isDarkMode) {
    return Obx(() {
      return isConnected.value
          ? const SizedBox.shrink()
          : Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Text(
                  "Network Issue! Please check your connection.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontFamily: "Switzer",
                      fontWeight: FontWeight.bold),
                ),
              ),
            );
    });
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: Colors.green,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    Icon? icon,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: Colors.red,
      icon: icon ?? const Icon(Icons.warning, color: Colors.white),
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: Colors.blue,
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: Colors.orange,
      icon: const Icon(Icons.warning, color: Colors.white),
    );
  }

  /// General snackbar method
  static void _showSnackbar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required Icon icon,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Widget buildGetStartedButton({
    required void Function()? onPressed,
    String text = "",
    Color backgroundColor = ColorUtils.loginButton,
    double borderRadius = 1.0,
    TextStyle textStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontFamily: "Switzer",
      color: Colors.white,
    ),
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }

  static Widget customTextField({
    required TextEditingController controller,
    String hintText = '',
    String hintText2 = '',
    required bool isDarkMode,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool readOnly = false,
    Widget? suffixIcon,
    TextStyle? style,
    RxBool? isPasswordVisible,
    Function()? onTogglePassword,
    void Function(String)? onChangeValue,
    BoxConstraints? boxDecoration,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hintText == '')
          const SizedBox.shrink()
        else
          Text(
            hintText,
            style: style ??
                TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  fontFamily: "Switzer",
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
          ),
        SizedBox(height: hintText == ''  ? 0 : 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChangeValue,
          obscureText: isPassword ? !isPasswordVisible!.value : false,
          readOnly: readOnly,
          textInputAction: textInputAction,
          cursorColor:
              isDarkMode ? ColorUtils.whiteColor : ColorUtils.blackColor,
          style: TextStyle(
            fontFamily: "Switzer",
            color: isDarkMode ? ColorUtils.whiteColor : ColorUtils.blackColor,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            suffixIcon: isPassword
                ? GestureDetector(
                    onTap: onTogglePassword,
                    child: Icon(
                      isPasswordVisible!.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: isDarkMode
                          ? Colors.white
                          : Colors.black.withOpacity(0.5),
                    ),
                  )
                : suffixIcon,
            suffixIconConstraints: boxDecoration,
            hintText: hintText2,
            hintStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: isDarkMode
                  ? ColorUtils.textFieldBorderColorDark
                  : ColorUtils.darkModeGrey2,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(1),
              borderSide: const BorderSide(
                color: ColorUtils.loginButton,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(1),
              borderSide: BorderSide(
                color: isDarkMode
                    ? ColorUtils.textFieldBorderColorDark
                    : ColorUtils.textFieldBorderColorLight,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(1),
              borderSide: BorderSide(
                color: isDarkMode
                    ? ColorUtils.textFieldBorderColorDark
                    : ColorUtils.textFieldBorderColorLight,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static String formatTimestamp(String timestamp) {
    try {
      int ts = int.tryParse(timestamp) ?? 0;
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
      return DateFormat("dd MMM yyyy, h:mm a").format(dateTime);
    } catch (e) {
      return "Invalid Date";
    }
  }

  ///Convert To RP
  static double weiToRP(String weiAmount) {
    try {
      BigInt wei = BigInt.parse(weiAmount);
      double rp = (wei / BigInt.from(10).pow(18));
      return rp;
    } catch (e) {
      return 0.00;
    }
  }

  /// Convert RP to USD
  static String rpToUSD(double rpAmount) {
    double usd = rpAmount * weiToRP(blockChainController.tokenPrice.value);
    return "\$${usd.toStringAsFixed(2)}";
  }

  static String formatAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 5)}.......${address.substring(address.length - 5)}';
  }

  static String getMonthName(int month) {
    const monthNames = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return monthNames[month - 1];
  }

  static String formatHour(int hour) {
    int formattedHour = hour % 12;
    return formattedHour == 0 ? "12" : formattedHour.toString();
  }

  static  String formatMinute(int minute) {
    return minute.toString().padLeft(2, '0');
  }

  static String getPeriod(int hour) {
    return hour < 12 ? "AM" : "PM";
  }

  static Uint8List deriveKeyAndIV(String password, Uint8List salt, int keyLength, int ivLength) {
    var passwordBytes = utf8.encode(password);
    var concatenatedHashes = <int>[];
    Uint8List currentHash = Uint8List(0);
    var requiredLength = keyLength + ivLength;

    while (concatenatedHashes.length < requiredLength) {
      var hasher = md5.convert([...currentHash, ...passwordBytes, ...salt]);
      currentHash = Uint8List.fromList(hasher.bytes);
      concatenatedHashes.addAll(currentHash);
    }

    return Uint8List.fromList(concatenatedHashes.sublist(0, requiredLength));
  }

  static String decryptOpenSSL(String encryptedBase64, String password) {
    try {
      Uint8List encryptedBytes = Uint8List.fromList(base64.decode(encryptedBase64));

      if (utf8.decode(encryptedBytes.sublist(0, 8)) != "Salted__") {
        throw ArgumentError("Invalid OpenSSL encrypted data.");
      }

      var salt = encryptedBytes.sublist(8, 16);
      var encrypted = encryptedBytes.sublist(16);

      var keyIv = deriveKeyAndIV(password, Uint8List.fromList(salt), 32, 16);
      final key = encrypt.Key(Uint8List.fromList(keyIv.sublist(0, 32)));
      final iv = encrypt.IV(Uint8List.fromList(keyIv.sublist(32, 48)));

      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
      final decrypted = encrypter.decryptBytes(encrypt.Encrypted(encrypted), iv: iv);

      return utf8.decode(decrypted, allowMalformed: true);
    } catch (e) {
      return "Error decrypting: $e";
    }
  }

  static Widget buildLoader(){
    return Center(
      child: Lottie.asset(
        'assets/jsonFile/RP Loader3.json',
        width: 200,
        height: 200,
        fit: BoxFit.contain,
      ),
    );
  }


}
