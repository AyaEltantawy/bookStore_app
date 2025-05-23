
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Route<dynamic>? onGenerateRoute(RouteSettings settings) => null;

class MagicRouter {
  static BuildContext? currentContext = navigatorKey.currentContext;

  static Future<dynamic>? namedNavigation(String pageName,
      {Object? arguments}) =>
      navigatorKey.currentState?.pushNamed(pageName, arguments: arguments);

  static Future<dynamic>? navigateTo(Widget page, {Object? arguments}) =>
      navigatorKey.currentState?.push(_materialPageRoute(page));

  static Future<dynamic>? navigateToWithSlideEffect(Widget page,
      {SlideDirection direction = SlideDirection.rtl,
        Cubic curve = Curves.easeIn}) async {
    Offset beginOffset = const Offset(1.0, 0.0);
    Offset endOffset = Offset.zero;
    switch (direction) {
      case SlideDirection.ltr:
        beginOffset = const Offset(-1.0, 0.0);
        break;
      case SlideDirection.btt:
        beginOffset = const Offset(0.0, 1.0);
        break;
      case SlideDirection.ttb:
        beginOffset = const Offset(0.0, -1.0);
        break;
      case SlideDirection.rtl:
      default:
        const Offset(1.0, 0.0);
    }
    return Navigator.push(
      MagicRouter.currentContext!,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: beginOffset, end: endOffset)
              .chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  static Future<dynamic>? navigateAndPopAll(Widget page) =>
      navigatorKey.currentState?.pushAndRemoveUntil(
        _materialPageRoute(page),
            (_) => false,
      );

  static Future<dynamic>? navigateAndPopUntilFirstPage(Widget page) =>
      navigatorKey.currentState?.pushAndRemoveUntil(
          _materialPageRoute(page), (route) => route.isFirst);

  static void pop() => navigatorKey.currentState?.pop();

  static void popWithResult(result) => navigatorKey.currentState?.pop(result);

  static Route<dynamic> _materialPageRoute(Widget page) =>
      MaterialPageRoute(builder: (_) => page);
}

enum SlideDirection { ltr, rtl, ttb, btt }
