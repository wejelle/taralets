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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.divider, width: 1),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.charcoal,
                size: 16,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 4, 28, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ───────────────────────────────────────────
            const Text(
              'Create Account',
              style: TextStyle(
                color: AppColors.charcoal,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Join Taralets and sync your group trips!',
              style: TextStyle(color: AppColors.captionText, fontSize: 13),
            ),
            const SizedBox(height: 28),

            // ── Section: Personal Details ─────────────────────
            _buildSectionLabel('Personal Details'),
            const SizedBox(height: 12),
            _buildTextField('Full Name', Icons.badge_outlined),
            const SizedBox(height: 12),
            _buildTextField(
              'Contact Info (Phone / Email)',
              Icons.contact_phone_outlined,
            ),
            const SizedBox(height: 12),
            _buildTextField('Home Address', Icons.home_outlined),

            const SizedBox(height: 24),
            const Divider(color: AppColors.divider, thickness: 1),
            const SizedBox(height: 20),

            // ── Section: Account Credentials ──────────────────
            _buildSectionLabel('Account Credentials'),
            const SizedBox(height: 12),
            _buildTextField('Username', Icons.person_outline_rounded),
            const SizedBox(height: 12),
            _buildTextField(
              'Password',
              Icons.lock_outline_rounded,
              isPassword: true,
              obscureText: _obscurePassword,
              onTogglePassword: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            const SizedBox(height: 12),
            _buildTextField(
              'Confirm Password',
              Icons.lock_outline_rounded,
              isPassword: true,
              obscureText: _obscureConfirm,
              onTogglePassword: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            const SizedBox(height: 22),

            // ── Terms Checkbox ────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 22,
                  width: 22,
                  child: Checkbox(
                    value: _agreedToTerms,
                    activeColor: AppColors.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: const BorderSide(
                      color: AppColors.captionText,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (val) =>
                        setState(() => _agreedToTerms = val!),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: AppColors.bodyText,
                        fontSize: 12,
                        height: 1.6,
                      ),
                      children: [
                        TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // ── Register Button ───────────────────────────────
            ElevatedButton(
              onPressed: _agreedToTerms
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registration successful!'),
                          backgroundColor: AppColors.teal,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.cardBorder,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 9),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.charcoal,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
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
      style: const TextStyle(color: AppColors.charcoal, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.captionText, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: AppColors.captionText, size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.captionText,
                  size: 19,
                ),
                onPressed: onTogglePassword,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}