import 'package:flutter/material.dart';

/// Global navigation service that provides access to the navigator
/// from anywhere in the app without requiring BuildContext
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static bool _isLoadingShown = false;
  static bool _isDialogShown = false;

  /// Get the current BuildContext if available
  static BuildContext? get context => navigatorKey.currentContext;

  /// Check if any dialog is currently shown
  static bool get isDialogShown => _isDialogShown || _isLoadingShown;

  /// Show loading overlay
  static void showLoading({String? message}) {
    final ctx = context;
    if (ctx == null || _isLoadingShown) return;

    _isLoadingShown = true;
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    if (message != null) ...[
                      SizedBox(height: 16),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Hide loading overlay
  static void hideLoading() {  
    if (!_isLoadingShown) return;
    _isLoadingShown = false;
    navigatorKey.currentState?.pop();
  }

  /// Navigate to a named route
  static Future<dynamic>? navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState?.pushNamed(  
      routeName,
      arguments: arguments,
    );
  }

  /// Replace current route with a named route
  static Future<dynamic>? navigateReplacementTo(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState?.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  /// Pop the current route
  static void goBack() {
    return navigatorKey.currentState?.pop();
  }

  /// Pop until a specific route
  static void popUntil(String routeName) {
    return navigatorKey.currentState?.popUntil(ModalRoute.withName(routeName));
  }

  /// Show a dialog using the global context
  static Future<T?> showDialogGlobal<T>({
    required Widget Function(BuildContext) builder,
    bool barrierDismissible = true,
    bool dismissLoadingFirst = false,
  }) async {  
    final ctx = context;
    if (ctx == null) {
      throw Exception('NavigationService: Context is not available');
    }

    // Optionally dismiss loading first
    if (dismissLoadingFirst && _isLoadingShown) {
      hideLoading();
      // Wait a frame for the loading dialog to fully dismiss
      await Future.delayed(Duration(milliseconds: 100));
    }

    // Don't show if another dialog is already shown
    if (_isDialogShown) {
      return Future.value(null);
    }

    _isDialogShown = true;

    return showDialog<T>(  
      context: ctx,  
      barrierDismissible: barrierDismissible,
      builder: builder,
    ).then((value) { 
       
      _isDialogShown = false;
      return value;
    });
  }

  /// Show a snackbar using the global context
  static void showSnackBar(String message, {Duration? duration}) { 

    final ctx = context;
    if (ctx == null) return;

    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  static void successSnackbar(String message, {Duration? duration}) {
    final ctx = context;
    if (ctx == null) return;

    ScaffoldMessenger.of(ctx).showSnackBar(    
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).primaryColor,
        duration: duration ?? const Duration(seconds: 5),
      ),
    );
  }
}
