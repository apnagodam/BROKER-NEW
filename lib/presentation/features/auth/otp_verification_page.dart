import 'package:ag_broker/presentation/common/auth_providers.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationPage extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpVerificationPage({Key? key, required this.phoneNumber})
    : super(key: key);

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  final TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.enterOtp),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Back Button
            SizedBox(height: 20),

            // Title
            Text(
              localizations.enterOtp,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              '${localizations.enterOtpSentTo} ${widget.phoneNumber}',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),

            // OTP Input
            Pinput(
              length: 6,
              controller: otpController,
              defaultPinTheme: PinTheme(
                width: 45,
                height: 45,
                textStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 45,
                height: 45,
                textStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                // Auto-submit when 6 digits are entered
                if (value.length == 6) {
                  // Optional: Auto-verify on complete entry
                  _verifyAndSubmitOtp(localizations);
                }
              },
              keyboardType: TextInputType.number,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            SizedBox(height: 24),

            // Verify Button
            ElevatedButton(
              onPressed: authState.isLoading
                  ? null
                  : () async {
                      _verifyAndSubmitOtp(localizations);
                    },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: authState.isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(localizations.verify),
            ),

            SizedBox(height: 16),

            // Resend Button
            Center(
              child: TextButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final value = await ref
                      .read(authStateProvider.notifier)
                      .sendOtp(widget.phoneNumber);

                  otpController.clear();
                  if (!mounted) return;
                  if (value['status'].toString() == "1") {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(localizations.otpResentSuccessfully),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: Text(
                  localizations.resendOtp,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyAndSubmitOtp(AppLocalizations localizations) async {
    if (otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.pleaseEnterCompleteOtp),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final value = await ref
        .read(authStateProvider.notifier)
        .verifyOtp(widget.phoneNumber, otpController.text);
    if (!mounted) return;
    if (value['status'].toString() == "1") {
      context.go('/home');
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(value['message'] ?? localizations.errorOccurred),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
