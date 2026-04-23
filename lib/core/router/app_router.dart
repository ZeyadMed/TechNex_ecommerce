import 'package:e_commerce/features/auth/register/presentation/register_screen.dart';
import 'package:e_commerce/features/auth/forget_password/presentation/forget_password_screen.dart';
import 'package:e_commerce/features/auth/verify_otp/presentation/otp_screen.dart';
import 'package:e_commerce/features/auth/change_password/presentation/change_password_screen.dart';
import 'package:e_commerce/features/address/presentation/address_screen.dart';
import 'package:e_commerce/features/cart/presentation/checkout_flow_screen.dart';
import 'package:e_commerce/features/profile/presentation/help_support_screen.dart';
import 'package:e_commerce/features/profile/presentation/models/track_order_models.dart';
import 'package:e_commerce/features/profile/presentation/my_orders_screen.dart';
import 'package:e_commerce/features/profile/presentation/notification_screen.dart';
import 'package:e_commerce/features/profile/presentation/track_order_screen.dart';
import 'package:e_commerce/features/profile/presentation/widgets/order_status_chip.dart';
import 'package:e_commerce/features/profile/presentation/privacy_security_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:e_commerce/core/router/bottom_nav_app.dart';
import 'package:e_commerce/features/auth/login/presentation/login_screen.dart';
import 'package:e_commerce/features/on_boarding/presentation/views/on_boarding_screen.dart';
import 'package:e_commerce/features/splash/presentation/view/splash_screen.dart';
import 'package:e_commerce/main.dart';

abstract class AppRouter {
  static const String root = '/';
  static const String webViewContainer = '/webViewContainer';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String forgetPassword = '/forgetPassword';
  static const String verifyOtp = '/verifyOtp';
  static const String resetPasswordScreen = '/resetPasswordScreen';
  static const String successScreen = '/successScreen';
  // ************* HOME *************
  static const String initialRoot = '/initialRoot';
  static const String homeScreen = '/HomeScreen';

  // ************* PROFILE *************
  static const String profileScreen = '/profileScreen';
  static const String contactUsScreen = '/contactUsScreen';
  static const String notificationScreen = '/notificationScreen';
  static const String myOrdersScreen = '/myOrdersScreen';
  static const String trackOrderScreen = '/trackOrderScreen';
  static const String customerServiceScreen = '/customerServiceScreen';
  static const String aboutUs = '/aboutUs';
  static const String updateProfileScreen = '/updateProfileScreen';
  static const String privacyPolicy = '/privacyPolicy';
  static const String privacyAndSecurityScreen = '/privacyAndSecurityScreen';
  static const String addressesScreen = '/addressesScreen';
  static const String checkoutFlowScreen = '/checkoutFlowScreen';

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    routes: [
      // -----------------------------------Splash Screen and OnBoarding--------------------------------
      GoRoute(
        path: root,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnBoardingScreen(),
      ),
      //---------------------- BottomNavApp -------------------------
      GoRoute(
        path: initialRoot,
        builder: (context, state) => const BottomNavApp(),
      ),
      // GoRoute(
      //   path: homeScreen,
      //   builder: (context, state) => const HomeScreen(),
      // ),
      //---------------------- Auth -------------------------
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: signUp,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: forgetPassword,
        builder: (context, state) => const ForgetPasswordScreen(),
      ),
      GoRoute(
        path: verifyOtp,
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: resetPasswordScreen,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: addressesScreen,
        builder: (context, state) => const AddressScreen(),
      ),
      GoRoute(
        path: checkoutFlowScreen,
        builder: (context, state) => CheckoutFlowScreen(
          cartItems: (state.extra as List<Map<String, dynamic>>?) ?? const [],
        ),
      ),
      GoRoute(
        path: customerServiceScreen,
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: notificationScreen,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: myOrdersScreen,
        builder: (context, state) => const MyOrdersScreen(),
      ),
      GoRoute(
        path: trackOrderScreen,
        builder: (context, state) => TrackOrderScreen(
          args: (state.extra as TrackOrderArgs?) ?? TrackOrderArgs.sample(
            orderId: 'ORD123456',
            amount: r'$527.04',
            imageAsset: 'assets/images/guest.png',
            status: OrderStatus.inTransit,
          ),
        ),
      ),
      GoRoute(
        path: privacyAndSecurityScreen,
        builder: (context, state) => const PrivacySecurityScreen(),
      ),
    ],
  );
}
