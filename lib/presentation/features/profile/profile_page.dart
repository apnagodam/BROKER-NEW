import 'package:ag_broker/core/utils/shared_preferences_service.dart';
import 'package:ag_broker/domain/entities/user_details_model.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/presentation/common/auth_providers.dart';
import 'package:ag_broker/presentation/common/widgets/gradient_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authStateProvider.notifier).getUserDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final loginResponse = SharedPreferencesService.completeLoginResponse;
    final userDetails = ref.watch(authStateProvider).userDetails;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.profile),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: loginResponse == null
          ? Center(child: Text(localizations.noDataAvailable))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(  
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [  
                  // Profile Header
                  Center(
                    child: Column( 
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.1),
                          child: Icon(   
                            Icons.person,
                            size: 50,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(  
                          loginResponse.userDetails?.name ?? "",
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(  
                          loginResponse.userDetails.phone,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),

                  // User Details Section
                  Text(  
                    localizations.personalInformation,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildPowerSection(    
                    userDetails!,
                    AppLocalizations.of(context)!,
                  ),

                  SizedBox(height: 16),
                  _buildInfoCard(  
                    context,
                    title: localizations.uniqueId,
                    value: loginResponse.userDetails.uniqueId,
                  ),
                  if (loginResponse.userDetails.email != null)
                    _buildInfoCard(  
                      context,
                      title: localizations.email,
                      value: loginResponse.userDetails.email!,
                    ),
                  if (loginResponse.userDetails.age != null)
                    _buildInfoCard(
                      context,
                      title: localizations.age,
                      value: loginResponse.userDetails.age.toString(),
                    ),
                  if (loginResponse.userDetails.fullAddress != null)
                    _buildInfoCard(  
                      context,
                      title: localizations.address,
                      value: loginResponse.userDetails.fullAddress!,
                    ),

                  SizedBox(height: 32),

                  // Bank Information Section
                  Text(  
                    localizations.bankInformation,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  if (loginResponse.userDetails.bankName != null)
                    _buildInfoCard(   
                      context,
                      title: localizations.bankName,
                      value: loginResponse.userDetails.bankName!,
                    ),
                  if (loginResponse.userDetails.bankIfscCode != null)
                    _buildInfoCard(    
                      context,
                      title: localizations.ifscCode,
                      value: loginResponse.userDetails.bankIfscCode!,
                    ),
                  if (loginResponse.userDetails.accountNo != null)
                    _buildInfoCard(     
                      context,
                      title: localizations.accountNumber,
                      value: loginResponse.userDetails.accountNo!,
                    ),

                  SizedBox(height: 32),

                  SizedBox(height: 32),

                  // Status Information
                  Text(   
                    localizations.statusInformation,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildInfoCard(     
                    context,
                    title: localizations.activeStatus,
                    value: loginResponse.active == 1
                        ? localizations.active
                        : localizations.inactive,
                  ),
                  _buildInfoCard(        
                    context, 
                    title: localizations.approvalStatus,
                    value: loginResponse.userDetails.approve == 1
                        ? localizations.approved
                        : localizations.pending,
                  ),
                  _buildInfoCard(  
                    context,
                    title: localizations.verificationStatus,
                    value: loginResponse.userDetails.verify == 1
                        ? localizations.verified
                        : localizations.unverified,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPowerSection(  
    UserDetailsModel userDetails,
    AppLocalizations localizations,
  ) {  
    final power = userDetails.userDetails?.power ?? 0;

    return GradientInfoCard(       
      margin: const EdgeInsets.all(0),
      gradientColors: [Colors.orange.shade700, Colors.orange.shade600],
      shadowColor: Colors.orange.withValues(alpha: 0.3),
      icon: Icons.flash_on,
      label: localizations.power,
      value: _formatAmount(power.toString()),
    );
  }

  String _formatAmount(String amount) {   
    try {    
      final double value = double.parse(amount);
      final formatter = NumberFormat('#,##,##0.00', 'en_IN');
      return formatter.format(value);
    } catch (e) {
      return amount;
    }
  }

  Widget _buildInfoCard(  
    BuildContext context, {    
    required String title,
    required String value,
  }) {
    return Card(   
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(  
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded( 
              child: Text(   
                title,
                style: Theme.of(   
                  context, 
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
              ),
            ),
            Expanded(   
              child: Text(     
                value,
                style: Theme.of(      
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
