import 'package:ag_broker/presentation/common/auth_providers.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Text
            Text(
              localizations.login,
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              localizations.welcomeToBrokerApp,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              localizations.enterPhoneToContinue,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),

            // Phone Input
            TextField(
              controller: phoneController,
              maxLength: 10,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: localizations.enterPhone,

                prefixText: '+91 ',
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2.0,
                  ),
                ),
                counterText: '',
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 24),

            // Send OTP Button
            ElevatedButton(
              onPressed: authState.isLoading
                  ? null
                  : () async {
                      if (phoneController.text.length != 10) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              localizations.pleaseEnterValidPhoneNumber,
                            ),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }
                      await ref
                          .read(authStateProvider.notifier)
                          .sendOtp(phoneController.text)
                          .then((value) {
                            if (value['status'].toString() == "1") {
                              context.go(
                                '/otp-verification?phone=${phoneController.text}',
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    value['message'] ??
                                        localizations.errorOccurred,
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          });
                    },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: authState.isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(localizations.sendOtp),
            ),
          ],
        ),
      ),
    );
  }
}
