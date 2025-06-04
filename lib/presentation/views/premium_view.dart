import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PremiumView extends ConsumerWidget {
  static const name = 'premium-view';
  const PremiumView({super.key});

  Widget _buildBenefitItem(
    BuildContext context,
    String text, {
    IconData icon = Icons.check_circle_outline,
    Color iconColor = Colors.yellow,
    Color textColor = Colors.white,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: 16, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;

    final isUserPremium = ref.watch(premiumStatusProvider);
    final premiumNotifier = ref.read(premiumStatusProvider.notifier);

    final offeringsAsync = ref.watch(offeringsProvider);
    Package annual;
    Package monthly;
    Package? selectedPackage;

    bool isRestoring = false;

    final l10n = AppLocalizations.of(context)!;

    String buttonText;
    bool showLoadingIndicatorInButton = false;

    buttonText = l10n.premiumView_subscribeButtonText;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset('assets/images/premium_back.jpg', fit: BoxFit.cover),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(153, 0, 0, 0),
                const Color.fromARGB(77, 0, 0, 0),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.center,
            ),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 30.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: const Color.fromARGB(179, 0, 0, 0),
                            offset: const Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              !isUserPremium
                                  ? l10n.premiumView_title_go
                                  : l10n.premiumView_title_go_2,
                          style: const TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: l10n.premiumView_title_premium,
                          style: const TextStyle(color: Colors.yellow),
                        ),
                        !isUserPremium
                            ? TextSpan(
                              text: l10n.premiumView_title_now,
                              style: const TextStyle(color: Colors.white),
                            )
                            : const TextSpan(text: ''),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    l10n.premiumView_oscarsAccessDescription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildBenefitItem(
                    context,
                    l10n.premiumView_benefit_bestPicture,
                  ),
                  _buildBenefitItem(
                    context,
                    l10n.premiumView_benefit_animatedFeature,
                  ),
                  _buildBenefitItem(
                    context,
                    l10n.premiumView_benefit_visualEffects,
                  ),
                  _buildBenefitItem(context, l10n.premiumView_benefit_director),
                  _buildBenefitItem(
                    context,
                    l10n.premiumView_benefit_actorLeadingSupporting,
                  ),
                  _buildBenefitItem(
                    context,
                    l10n.premiumView_benefit_actressLeadingSupporting,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    l10n.premiumView_workingHardMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    // Asumiendo que tienes este string
                    l10n.premiumView_allNomineesMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    l10n.premiumView_comingNextTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.premiumView_comingNextDescription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildBenefitItem(
                    context,
                    l10n.premiumView_benefit_goldenGlobes,
                    icon: Icons.star_outline,
                    iconColor: Colors.amber,
                    textColor: Colors.white70,
                  ),
                  _buildBenefitItem(
                    context,
                    l10n.premiumView_benefit_baftaAwards,
                    icon: Icons.star_outline,
                    iconColor: Colors.amber,
                    textColor: Colors.white70,
                  ),
                  _buildBenefitItem(
                    context,
                    l10n.premiumView_benefit_cannesFestival,
                    icon: Icons.star_outline,
                    iconColor: Colors.amber,
                    textColor: Colors.white70,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    l10n.premiumView_manyMoreAwardsMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.premiumView_experienceGrowingMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (isUserPremium) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 30.0,
                        horizontal: 12,
                      ),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 32, 34, 40),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.yellow, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.premiumView_youArePremiumTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.premiumView_thankYouMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    offeringsAsync.when(
                      data: (offerings) {
                        final currentOffering = offerings.current;
                        if (currentOffering == null) {
                          return const SizedBox.shrink();
                        }

                        // Buscamos el plan anual y mensual por identificadores comunes
                        annual = currentOffering.availablePackages.firstWhere(
                          (p) => p.packageType == PackageType.annual,
                          orElse: () => currentOffering.availablePackages.first,
                        );

                        monthly = currentOffering.availablePackages.firstWhere(
                          (p) => p.packageType == PackageType.monthly,
                          orElse: () => currentOffering.availablePackages.last,
                        );

                        final monthlyPrice = monthly.storeProduct.price;
                        final annualPrice = annual.storeProduct.price;

                        final monthlyTotal = monthlyPrice * 12;
                        final savingsPercent =
                            ((monthlyTotal - annualPrice) / monthlyTotal * 100)
                                .round();

                        selectedPackage = ref.watch(selectedPackageProvider);
                        final selectedPackageNotifier = ref.read(
                          selectedPackageProvider.notifier,
                        );

                        if (selectedPackage == null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            selectedPackageNotifier.state = annual;
                          });
                        }

                        return Column(
                          children: [
                            _buildSelectablePlanTile(
                              ref,
                              package: annual,
                              isSelected:
                                  selectedPackage?.identifier ==
                                  annual.identifier,
                              isRecommended: true,
                              savingsPercent: savingsPercent,
                            ),
                            _buildSelectablePlanTile(
                              ref,
                              package: monthly,
                              isSelected:
                                  selectedPackage?.identifier ==
                                  monthly.identifier,
                            ),
                          ],
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (error, _) => Text('Error loading plans: $error'),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            return ElevatedButton(
                              onPressed:
                                  selectedPackage == null
                                      ? null
                                      : () async {
                                        try {
                                          setState(() => showLoadingIndicatorInButton = true);
                                          final result =
                                              await Purchases.purchasePackage(
                                                selectedPackage!,
                                              );
                                          await premiumNotifier.refreshStatus();
                                          print(
                                            'Purchase Completed: ${result.entitlements.active}',
                                          );
                                        } catch (e) {
                                          print('Error: $e');
                                        }
                                        setState(() => showLoadingIndicatorInButton = false);
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                                disabledBackgroundColor: Colors.grey.shade700,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child:
                                  showLoadingIndicatorInButton
                                      ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1,
                                          color: Colors.black,
                                        ),
                                      )
                                      : Text(
                                        buttonText,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return TextButton(
                            onPressed: () async {
                              if (isRestoring) {
                                return;
                              }
                              setState(() => isRestoring = true);
                              try {
                                final customerInfo =
                                    await Purchases.restorePurchases();
                                final isPro = customerInfo.entitlements.active
                                    .containsKey('Pro');

                                if (isPro) {
                                  await premiumNotifier.refreshStatus();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.premiumView_restoreSuccessMessage,
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.premiumView_noPurchasesFoundMessage,
                                        ),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                print('Error restoring purchases: $e');
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.premiumView_restoreErrorMessage,
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } finally {
                                if (context.mounted) {
                                  setState(() => isRestoring = false);
                                }
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 10,
                              ),
                            ),
                            child:
                                isRestoring
                                    ? const AnimatedDots(
                                      color: Colors.white,
                                      fontSize: 20,
                                    )
                                    : Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.premiumView_restorePurchasesButtonText,
                                      style: const TextStyle(
                                        color: Color.fromARGB(
                                          217,
                                          255,
                                          255,
                                          255,
                                        ),
                                        decoration: TextDecoration.underline,
                                        decorationColor: Color.fromARGB(
                                          217,
                                          255,
                                          255,
                                          255,
                                        ),
                                        fontSize: 16,
                                      ),
                                    ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildSelectablePlanTile(
  WidgetRef ref, {
  required Package package,
  required bool isSelected,
  bool isRecommended = false,
  int? savingsPercent,
}) {
  final product = package.storeProduct;
  final context = ref.context;
  final l10n = AppLocalizations.of(context)!;

  final bool isAnnual = package.packageType == PackageType.annual;
  final String localizedTitle =
      isAnnual
          ? l10n.premiumView_annualPlanTitle
          : l10n.premiumView_monthlyPlanTitle;

  final String localizedDescription =
      isAnnual
          ? l10n.premiumView_annualPlanDescription
          : l10n.premiumView_monthlyPlanDescription;

  return InkWell(
    onTap: () => ref.read(selectedPackageProvider.notifier).state = package,
    borderRadius: BorderRadius.circular(12),
    child: Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 32, 34, 40),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.yellow : Colors.grey.shade700,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Radio<Package>(
                  value: package,
                  groupValue: ref.watch(selectedPackageProvider),
                  onChanged:
                      (value) =>
                          ref.read(selectedPackageProvider.notifier).state =
                              value,
                  activeColor: Colors.yellow,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizedTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.priceString,
                        style: const TextStyle(
                          color: Colors.yellow,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        localizedDescription,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isRecommended)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Text(
                '-$savingsPercent%',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
