
import 'package:ag_broker/core/utils/constants.dart';
import 'package:ag_broker/core/utils/navigation_service.dart';
import 'package:ag_broker/core/utils/shared_preferences_service.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DioClient {
  static const String baseUrl =
      Constants.testApiBaseUrl; // Replace with your actual API base URL

  late Dio _dio;
  final Locale _locale;

  DioClient(this._locale) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      _LoggingInterceptor(),
      _LoadingInterceptor(),
      _AuthInterceptor(_locale),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ),
    ]);
  }

  Dio get dio => _dio;
}

class _LoadingInterceptor extends Interceptor {
  int _activeRequests = 0;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _activeRequests++;
    if (_activeRequests == 1) {
      // NavigationService.showLoading();
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _activeRequests--;
    if (_activeRequests == 0) {
      // NavigationService.hideLoading();
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _activeRequests--;
    if (_activeRequests == 0) {
      //NavigationService.hideLoading();
    }
    super.onError(err, handler);
  }
}

class _AuthInterceptor extends Interceptor {
  final Locale _locale;

  _AuthInterceptor(this._locale);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token if available
    final token = SharedPreferencesService.token;
    if (token != null) {
      options.headers['Authorization'] = token;
    }

    // Add language header
    options.headers['language'] = _locale.languageCode;
    options.headers['lang'] = _locale.languageCode;
    for (var entries in options.headers.entries) {
      debugPrint("Header=>$entries");
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle token expiration

    switch (err.response?.statusCode) {
      case 500:
        NavigationService.showDialogGlobal(
          dismissLoadingFirst: true,
          builder: (dialogContext) {
            final localizations = AppLocalizations.of(dialogContext)!;
            return AlertDialog(
              title: Text(
                "${localizations.errorOccurred} in Api -${err.requestOptions.path}",
              ),
              content: Text(
                "Server error in Api -${err.requestOptions.path}. Please try again later.",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(localizations.ok),
                ),
              ],
            );
          },
        );

      default:
        super.onError(err, handler);
    }
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print(options.baseUrl + options.path);
    for (var entries in options.headers.entries) {
      debugPrint("Header=>$entries");
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!response.requestOptions.path.contains('apna_send_otp')) {
      if ((response.data['message'].toString().contains('User not found!') ||
          response.data['message'].toString().contains(
            'उपयोगकर्ता नहीं मिला!',
          ) ||
          response.data['message'].toString().contains(
            'The authorization field is required',
          ))) {
        NavigationService.showDialogGlobal(
          dismissLoadingFirst: true,
          builder: (dialogContext) {
            final localizations = AppLocalizations.of(dialogContext)!;
            return AlertDialog(
              title: Text(localizations.errorOccurred),
              content: Text(
                response.data['message'] ?? localizations.errorOccurred,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if ((response.data['message'].toString().contains(
                          'User not found!',
                        ) ||
                        response.data['message'].toString().contains(
                          'उपयोगकर्ता नहीं मिला!',
                        ) ||
                        response.data['message'].toString().contains(
                          'The authorization field is required',
                        ))) {
                      SharedPreferencesService.clearAuthData();
                      NavigationService.context!.go('/login');
                    } else {
                      Navigator.of(dialogContext).pop();
                    }
                  },
                  child: Text(localizations.ok),
                ),
              ],
            );
          },
        );
      }

      // Check if dialog is not already open before showing error dialog
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    print('ERROR MESSAGE: ${err.message}');
    super.onError(err, handler);
  }
}
