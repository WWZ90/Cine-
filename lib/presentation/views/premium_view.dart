import 'package:flutter/material.dart';

class PremiumView extends StatelessWidget {
  static const name = 'premium-view';
  const PremiumView({super.key});

  // Helper widget to build benefit list items consistently
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

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(
          'assets/images/premium_back.jpg', // Ensure this path is correct
          fit: BoxFit.cover,
        ),
        // Gradient overlay for better text readability (optional)
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.3),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.center,
            ),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            // Makes content scrollable if it overflows
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
                        fontSize: 32, // Slightly larger
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black.withOpacity(0.7),
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Go ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'PREMIUM',
                          style: TextStyle(color: Colors.yellow),
                        ),
                        TextSpan(
                          text: ' now!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),

                  Text(
                    "Enjoy full coverage of the Academy Awards with exclusive access to:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Oscar Benefits List
                  _buildBenefitItem(context, "Best Picture"),
                  _buildBenefitItem(context, "Animated Feature Film"),
                  _buildBenefitItem(context, "Best Visual Effects"),
                  _buildBenefitItem(context, "Best Director"),
                  _buildBenefitItem(context, "Actor in a Leading and Supporting Role"),
                  _buildBenefitItem(context, "Actress in a Leading and Supporting Role"),
                  SizedBox(height: 15),
                  Text(
                    "✨ We're working hard to add many more categories!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  SizedBox(height: 35),

                  Text(
                    "🧭 What's Coming Next?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Soon, you'll also be able to explore:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Future Awards List
                  _buildBenefitItem(
                    context,
                    "Golden Globes",
                    icon: Icons.star_outline,
                    iconColor: Colors.amber,
                    textColor: Colors.white70,
                  ),
                  _buildBenefitItem(
                    context,
                    "BAFTA Awards",
                    icon: Icons.star_outline,
                    iconColor: Colors.amber,
                    textColor: Colors.white70,
                  ),
                  _buildBenefitItem(
                    context,
                    "Cannes Film Festival",
                    icon: Icons.star_outline,
                    iconColor: Colors.amber,
                    textColor: Colors.white70,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "And many other major film awards!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "The Premium experience keeps growing!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 30), // Space before the button

                  // --- Pricing Information ---
                  Text(
                    "Just \$9.99 per year", // Or "Just $9.99 per year"
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Make price prominent
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "Auto-renewable. Cancel anytime.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54, // Slightly less emphasis
                      fontSize: 13,
                    ),
                  ),
                  // --- End Pricing Information ---
                  SizedBox(height: 6),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                    ), // Responsive horizontal padding
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
                          'Subscribe Today', // Changed from "Subscribe today" for consistency
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10), // Bottom padding
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
