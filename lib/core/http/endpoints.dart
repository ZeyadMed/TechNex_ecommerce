part of 'http.dart';

abstract interface class Endpoints {
  static const String baseUrl = 'https://zego.premiumasp.net';
  static const String signalRUrl = 'https://zego.premiumasp.net/hubs/trip';
  static const String forgetPassword = "/api/Auth/forgot-password/send-otp";
  static const String resetPassword = "/api/Auth/forget-password/reset";
  static const String login = "/api/Auth/login/client";
  static const String refreshToken = "/api/Auth/refresh-token";
  static const String register = "/api/Auth/register/client";
  static const String logout = "/api/Auth/logout";
  static const String verifyOtp = "/api/Auth/verify";
  static const String resendOtp = "/api/Auth/resend-otp";

  //home
  static const String chooseSourceDestination =
      "/api/Client/calculate-min-price";
  static const String confirmTripProposal = "/api/Client/createTrip-v2";
  static String editSuggestedPrice(int id) => "/api/Client/updateTripPrice/$id";
  static String cancelTrip(int id) => "/api/Client/cancel/$id";

  static String approveDriverProposal({required int orderId}) =>
      "/api/Client/accept-offer/$orderId";
  static const String rateDriver = "/api/Client/rate-driver";
  static const String getPlacesAutoComplete =
      "/api/Client/places-autocomplete-limited";
  static const String getPlaces = "/api/Client/place-details";
  static const String getOrderStatus = "/api/Client/lastTrip";
  static String tripOffers(int id) => "/api/Client/trip-offers/$id";
  static const String getProfile = "/api/Client/profile";
  static const String contactUs = "/api/Client/contact";
  static const String deleteAccount = "/api/Client/deleteMyAccount";
}
