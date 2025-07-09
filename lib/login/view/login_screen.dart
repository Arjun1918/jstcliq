import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kods/login/provider/auth_provider.dart';
import 'package:kods/utils/theme.dart';
import 'package:kods/common/widgets/textfield.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _floatingController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatingAnimation;

  // Add initialization flag
  bool _animationsInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Initialize controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.bounceOut,
    ));
    
    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 15.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
    
    // Mark animations as initialized
    _animationsInitialized = true;
    
    // Start animations with delays
    _startAnimations();
  }

  void _startAnimations() {
    _fadeController.forward();
    
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _scaleController.forward();
    });
    
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _slideController.forward();
    });
    
    // Start the floating animation
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _floatingController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final success = await context.read<AuthProvider>().login(
        _mobileController.text.trim(),
        '',
      );

      if (success) {
        if (mounted) context.go('/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Return a loading indicator if animations aren't initialized yet
    if (!_animationsInitialized) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return SafeArea(
            child: Column(
              children: [
                // Animated Logo Section
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: AnimatedBuilder(
                    animation: _floatingAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, -_floatingAnimation.value),
                        child: Container(
                          width: double.infinity,
                          height: size.height * 0.2,
                          color: AppTheme.backgroundColor,
                          child: Stack(
                            children: [
                              // Decorative circles
                              Positioned(
                                top: -50,
                                right: -50,
                                child: ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.primaryColor.withOpacity(0.1),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 20,
                                left: -30,
                                child: ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.secondaryColor.withOpacity(0.1),
                                    ),
                                  ),
                                ),
                              ),
                              // Logo
                              Center(
                                child: ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.primaryColor.withOpacity(0.2),
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      height: 80,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Animated Form Section
                Expanded(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(45),
                          topRight: Radius.circular(45),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 30,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Animated Welcome Title
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: Column(
                                  children: [
                                    Text(
                                      'Welcome Back',
                                      style: Theme.of(context).textTheme.headlineSmall
                                          ?.copyWith(
                                            color: Colors.white.withOpacity(0.8),
                                            fontWeight: FontWeight.w300,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Login',
                                      style: Theme.of(context).textTheme.headlineMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Container(
                                      width: 60,
                                      height: 4,
                                      margin: const EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 35),

                              // Animated Input Field
                              ScaleTransition(
                                scale: _scaleAnimation,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: CustomTextField(
                                    controller: _mobileController,
                                    hint: 'Enter your mobile number',
                                    prefixIcon: Icons.phone_outlined,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your mobile number';
                                      }
                                      if (value.length < 10) {
                                        return 'Please enter a valid mobile number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(height: 30),

                              // Animated Login Button
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primaryColor.withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: authProvider.isLoading
                                        ? null
                                        : _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      child: authProvider.isLoading
                                          ? const SizedBox(
                                              key: ValueKey('loading'),
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<Color>(
                                                      Colors.white,
                                                    ),
                                              ),
                                            )
                                          : const Text(
                                              key: ValueKey('text'),
                                              'Login',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 25),

                              // Animated Error Message
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: authProvider.errorMessage.isNotEmpty ? null : 0,
                                child: authProvider.errorMessage.isNotEmpty
                                    ? Container(
                                        margin: const EdgeInsets.only(bottom: 20),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppTheme.errorColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: AppTheme.errorColor.withOpacity(0.3),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.error_outline,
                                              color: AppTheme.errorColor,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                authProvider.errorMessage,
                                                style: TextStyle(
                                                  color: AppTheme.errorColor,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),

                              // Animated Register Prompt
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Don't have an Account? ",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => context.go('/register'),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: const Text(
                                            "Register",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 25),
                          
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}