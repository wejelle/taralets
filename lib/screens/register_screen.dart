import 'package:flutter/material.dart';
import '../constants/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── GLOBAL THEME BACKGROUND ──
          Positioned.fill(
            child: Container(
                decoration: const BoxDecoration(
                    gradient: AppColors.globalThemeGradient)),
          ),
          Positioned(
            top: -50,
            right: -30,
            child: CircleAvatar(
                radius: 130,
                backgroundColor: Colors.white.withOpacity(
                    0.35)), // 👈 'backgroundColor' imbes na 'color'
          ),
          Positioned(
            bottom: 100,
            left: -60,
            child: CircleAvatar(
                radius: 110,
                backgroundColor: AppColors.primaryLight.withOpacity(
                    0.25)), // 👈 'backgroundColor' imbes na 'color'
          ),

          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: AppColors.charcoal, size: 18),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(28, 20, 28, 36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Create Account',
                          style: TextStyle(
                              color: AppColors.charcoal,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Join Taralets and sync your group trips!',
                          style: TextStyle(
                              color: AppColors.bodyText,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 32),
                        _buildSectionLabel('Personal Details'),
                        const SizedBox(height: 12),
                        _buildTextField('Full Name', Icons.badge_outlined),
                        const SizedBox(height: 12),
                        _buildTextField('Contact Info (Phone / Email)',
                            Icons.contact_phone_outlined),
                        const SizedBox(height: 12),
                        _buildTextField('Home Address', Icons.home_outlined),
                        const SizedBox(height: 24),
                        Divider(
                            color: AppColors.charcoal.withOpacity(0.1),
                            thickness: 1),
                        const SizedBox(height: 24),
                        _buildSectionLabel('Account Credentials'),
                        const SizedBox(height: 12),
                        _buildTextField(
                            'Username', Icons.person_outline_rounded),
                        const SizedBox(height: 12),
                        _buildTextField(
                          'Password',
                          Icons.lock_outline_rounded,
                          isPassword: true,
                          obscureText: _obscurePassword,
                          onTogglePassword: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          'Confirm Password',
                          Icons.lock_outline_rounded,
                          isPassword: true,
                          obscureText: _obscureConfirm,
                          onTogglePassword: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 22,
                              width: 22,
                              child: Checkbox(
                                value: _agreedToTerms,
                                activeColor: AppColors.primary,
                                side: const BorderSide(
                                    color: AppColors.captionText, width: 1.5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                onChanged: (val) =>
                                    setState(() => _agreedToTerms = val!),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                      color: AppColors.charcoal,
                                      fontSize: 13,
                                      height: 1.5,
                                      fontWeight: FontWeight.w500),
                                  children: [
                                    TextSpan(text: 'I agree to the '),
                                    TextSpan(
                                        text: 'Terms of Service',
                                        style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w800)),
                                    TextSpan(text: ' and '),
                                    TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w800)),
                                    TextSpan(text: '.'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: _agreedToTerms
                              ? () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Registration successful!'),
                                        backgroundColor: AppColors.teal),
                                  );
                                  Navigator.pop(context);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            disabledBackgroundColor: Colors.black12,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
              color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                color: AppColors.charcoal,
                fontSize: 14,
                fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _buildTextField(
    String hint,
    IconData icon, {
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
  }) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(
          color: AppColors.charcoal, fontSize: 14, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            color: AppColors.captionText.withOpacity(0.8), fontSize: 14),
        filled: true,
        fillColor: Colors.white.withOpacity(0.6),
        prefixIcon:
            Icon(icon, color: AppColors.primary.withOpacity(0.7), size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.captionText,
                    size: 20),
                onPressed: onTogglePassword,
              )
            : null,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                BorderSide(color: Colors.white.withOpacity(0.5), width: 1)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                BorderSide(color: Colors.white.withOpacity(0.8), width: 1.5)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}
