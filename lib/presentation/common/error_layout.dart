import 'package:flutter/material.dart';
import 'package:ag_broker/l10n/app_localizations.dart';

/// A custom error layout widget that displays error messages
/// in a user-friendly format with retry functionality
class ErrorLayout extends StatelessWidget {
  final String? title;
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final String? retryButtonText;

  const ErrorLayout({
    super.key,
    this.title,
    required this.message,
    this.onRetry,
    this.icon,
    this.retryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Error Icon
            Icon(
              icon ?? Icons.error_outline,
              size: 80,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 24),

            // Error Title
            if (title != null) ...[
              Text(  
                title!, 
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],

            // Error Message
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Retry Button
            if (onRetry != null)
              ElevatedButton.icon(  
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(
                  retryButtonText ?? AppLocalizations.of(context)!.retry,
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A compact error widget for inline errors
class CompactErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const CompactErrorWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {  
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: onRetry,
              color: theme.colorScheme.error,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error dialog for showing errors in a dialog
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String? closeButtonText;
  final String? retryButtonText;

  const ErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.closeButtonText,
    this.retryButtonText,
  });

  @override
  Widget build(BuildContext context) { 
    final theme = Theme.of(context);

    return AlertDialog(
      icon: Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
      title: Text(title, textAlign: TextAlign.center),
      content: Text(message, textAlign: TextAlign.center),
      actions: [
        if (onRetry != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry!();
            },
            child: Text(retryButtonText ?? AppLocalizations.of(context)!.retry),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(closeButtonText ?? AppLocalizations.of(context)!.close),
        ),
      ],
    );
  }

  /// Show error dialog helper
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onRetry,
    String? closeButtonText,
    String? retryButtonText,
  }) {
    return showDialog(  
      context: context,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        onRetry: onRetry,
        closeButtonText: closeButtonText,
        retryButtonText: retryButtonText,
      ),
    );
  }
}

/// Network error specific layout
class NetworkErrorLayout extends StatelessWidget { 
  final VoidCallback? onRetry;

  const NetworkErrorLayout({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) { 
    final localizations = AppLocalizations.of(context)!;
    return ErrorLayout(
      title: localizations.noInternetConnection,
      message: localizations.noInternetConnectionMessage,
      icon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }
}

/// Server error specific layout
class ServerErrorLayout extends StatelessWidget {
  final VoidCallback? onRetry;

  const ServerErrorLayout({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return ErrorLayout(  
      title: localizations.serverError,
      message: localizations.serverErrorMessage,
      icon: Icons.cloud_off,
      onRetry: onRetry,
    );
  }
}

/// Helper function to get user-friendly error messages from DioException
String getErrorMessage(dynamic error, BuildContext context) {  
  final localizations = AppLocalizations.of(context)!;

  if (error == null) return localizations.unexpectedError;

  final errorString = error.toString().toLowerCase();

  if (errorString.contains('socketexception') ||
      errorString.contains('network') ||
      errorString.contains('connection')) {
    return localizations.networkError;
  }

  if (errorString.contains('timeout')) { 
    return localizations.requestTimeout;
  }

  if (errorString.contains('500')) {    
    return localizations.serverErrorMessage;
  }

  if (errorString.contains('404')) {  
    return localizations.resourceNotFound;
  }

  if (errorString.contains('401') || errorString.contains('403')) {
    return localizations.authenticationFailed;
  }

  return localizations.errorGeneric;
}
