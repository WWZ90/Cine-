import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PremiumView extends StatelessWidget {
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
          SizedBox(width: 12),
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(
          'assets/images/premium_back.jpg',
          fit: BoxFit.cover,
        ),
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
                            color: const Color.fromARGB(179, 0, 0, 0), // Colors.black.withOpacity(0.7)
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: l10n.premiumView_title_go,
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: l10n.premiumView_title_premium,
                          style: TextStyle(color: Colors.yellow),
                        ),
                        TextSpan(
                          text: l10n.premiumView_title_now,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Text(
                    l10n.premiumView_oscarsAccessDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildBenefitItem(context, l10n.premiumView_benefit_bestPicture),
                  _buildBenefitItem(context, l10n.premiumView_benefit_animatedFeature),
                  _buildBenefitItem(context, l10n.premiumView_benefit_visualEffects),
                  _buildBenefitItem(context, l10n.premiumView_benefit_director),
                  _buildBenefitItem(context, l10n.premiumView_benefit_actorLeadingSupporting),
                  _buildBenefitItem(context, l10n.premiumView_benefit_actressLeadingSupporting),
                  SizedBox(height: 15),
                  Text(
                    l10n.premiumView_workingHardMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 35),
                  Text(
                    l10n.premiumView_comingNextTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    l10n.premiumView_comingNextDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 20),
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
                  SizedBox(height: 15),
                  Text(
                    l10n.premiumView_manyMoreAwardsMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    l10n.premiumView_experienceGrowingMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    l10n.premiumView_priceInfo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    l10n.premiumView_renewalInfo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 6),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          // Subscription logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text(
                          l10n.premiumView_subscribeButtonText,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Restore purchases logic
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16)
                    ),
                    child: Text(
                      l10n.premiumView_restorePurchasesButtonText,
                      style: TextStyle(
                        color: const Color.fromARGB(217, 255, 255, 255), // Colors.white.withOpacity(0.85)
                        decoration: TextDecoration.underline,
                        decorationColor: const Color.fromARGB(217, 255, 255, 255), // Colors.white.withOpacity(0.85)
                        fontSize: 16
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}