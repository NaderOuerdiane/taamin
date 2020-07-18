import 'package:sailor/sailor.dart';
import 'package:taamin/repository/info_repository.dart';
import 'package:taamin/screens/onboarding_screen.dart';
import 'package:taamin/screens/pages/offer.dart';
import 'package:taamin/screens/splash_screen.dart';
import 'models/offer.dart';

class Routes {
  static final sailor = Sailor();

  static void createRoutes() {
    sailor.addRoutes([
      SailorRoute(
          name: '/',
          builder: (context, args, params) {
            return SplashScreen();
          }),
      SailorRoute(
          name: 'boarding',
          builder: (context, args, params) {
            return OnboardingScreen();
          }),
      SailorRoute(
          name: '/offer',
          params: [
            SailorParam<Offer>(
              name: 'offer',
              defaultValue: Offer(),
            ),
            SailorParam<String>(
              name: 'uid',
            ),
            SailorParam<InfoRepository>(
              name: 'info',
            ),
          ],
          builder: (context, args, params) {
            return OfferPage();
          }),
    ]);
  }
}
