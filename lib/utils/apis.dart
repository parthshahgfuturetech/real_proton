
class ApiUtils {


  /// Base URL
  static const BASE_URL = "https://api.realproton.com";
  // static const BASE_URL = "http://192.168.1.9:3000";

  static const loginAPi = "$BASE_URL/v1/user-auth/login";
  static const signUpAPi = "$BASE_URL/v1/user-auth/signup";
  static const forgotPasswordAPi = "$BASE_URL/v1/user-auth/forgot-password";
  static const propertyList = "$BASE_URL/v1/property/";
  static const userDetails = "$BASE_URL/v1/user/user-details/profile";
  static const resendEmail = "$BASE_URL/v1/user-auth/resend-verification-email";
  static const updateUser = "$BASE_URL/v1/user/";
  static const changePassword = "$BASE_URL/v1/user/change-password";
  static const sumsubToken = "$BASE_URL/v1/sumsub/generate-token";
  static const logout = "$BASE_URL/v1/user-auth/logout";
  static const createWallet = "$BASE_URL/v1/fireblocks/genrate-fireblock-user-wallet";
  static const walletAssetsData = "$BASE_URL/v1/fireblocks/user-assets";
  static const fiatData = "$BASE_URL/v1/fiat/user-fiat-transaction";
  static const chainId = "$BASE_URL/v1/chain/";
  static const stripeAPi = "$BASE_URL/v1/stripe/payment_intents";
  static const stripeSuccessAPi = "$BASE_URL/v1/stripe/payment_intents/confirm";
  static const fiatDetailApi = "$BASE_URL/v1/fiat/user-fiat-transaction-detail";
  ///Graphql Apis.
  static const transactionHistory = "https://api.studio.thegraph.com/query/89202/proton-token-3643-celo/version/latest";


}