import 'package:flutter/material.dart';

class UsernameScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String city;
  final String country;
  final String additionalInfo;

  const UsernameScreen({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.city,
    required this.country,
    required this.additionalInfo,
  }) : super(key: key);

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? const Color(0xFFd32f2f)
            : const Color(0xFF6d4c7d),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            // Animated background circles
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF6d4c7d).withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -150,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF4a3456).withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 200,
              left: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF9d7fa8).withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      width: 500,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF6d4c7d).withOpacity(0.2),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6d4c7d).withOpacity(0.15),
                            blurRadius: 40,
                            spreadRadius: 0,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo section
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF6d4c7d), Color(0xFF9d7fa8)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF6d4c7d,
                                  ).withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.lock_outline,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Title
                          const Text(
                            'Set Up Credentials',
                            style: TextStyle(
                              color: Color(0xFF1a1a2e),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create your login credentials',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 15,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Form
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Username
                                _buildTextField(
                                  controller: _usernameController,
                                  hint: 'Username',
                                  icon: Icons.account_circle_outlined,
                                ),
                                const SizedBox(height: 16),

                                // Password
                                _buildPasswordField(
                                  controller: _passwordController,
                                  hint: 'Password',
                                  obscure: _obscurePassword,
                                  onToggle: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Confirm Password
                                _buildPasswordField(
                                  controller: _confirmPasswordController,
                                  hint: 'Confirm Password',
                                  obscure: _obscureConfirmPassword,
                                  onToggle: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                  isConfirm: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Complete Registration Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _showSnackBar(
                                    'Registration completed successfully!',
                                    isError: false,
                                  );
                                  // Navigate to home or login screen
                                }
                              },
                              style:
                                  ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6d4c7d),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    shadowColor: const Color(
                                      0xFF6d4c7d,
                                    ).withOpacity(0.5),
                                  ).copyWith(
                                    elevation:
                                        WidgetStateProperty.resolveWith<double>(
                                          (states) =>
                                              states.contains(
                                                WidgetState.hovered,
                                              )
                                              ? 8
                                              : 0,
                                        ),
                                  ),
                              child: const Text(
                                'Complete Registration',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Back to previous step
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Want to change details? ',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Go Back',
                                  style: TextStyle(
                                    color: Color(0xFF6d4c7d),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Back button
            Positioned(
              top: 40,
              left: 20,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6d4c7d).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xFF6d4c7d),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Color(0xFF1a1a2e), fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.4),
          fontSize: 15,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF6d4c7d), size: 22),
        filled: true,
        fillColor: const Color(0xFF6d4c7d).withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: const Color(0xFF6d4c7d).withOpacity(0.3),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: const Color(0xFF6d4c7d).withOpacity(0.3),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF6d4c7d), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFd32f2f), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        if (value.length < 4) {
          return 'Username must be at least 4 characters';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    bool isConfirm = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Color(0xFF1a1a2e), fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.4),
          fontSize: 15,
        ),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Color(0xFF6d4c7d),
          size: 22,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: const Color(0xFF6d4c7d),
            size: 22,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: const Color(0xFF6d4c7d).withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: const Color(0xFF6d4c7d).withOpacity(0.3),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: const Color(0xFF6d4c7d).withOpacity(0.3),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF6d4c7d), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFd32f2f), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        if (isConfirm && value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
