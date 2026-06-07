import 'package:e_commerance/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //From Controllers and State
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _fromKet = GlobalKey<FormState>();
  bool_isLoggingIn = false;

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  //Handle user login 
  Future<void> _loginUser() async{
    // Check if form is valid first
    if (!_formKey.currentState!.validate()) {
      return;
    }
// Show loading state
setState(() {
  _isLoggingIn = true;
});

try {
  //Attempt to sign in with firebase 
  final userCredential = await FirebaseAuth.instance.signInwithEmailAndPassword(
    email:_emailController.text.trim(),
    password: _passwordController.text.trim(),
  );
  // Get user's name for welcome email
  final userName = await AuthService.getCurrentUserNmae();

  // Send welcome email (don't wait for it to complete)
      EmailService.sendWelcomeEmail(
        toEmail: _emailController.text.trim(),
        toName: userName,
      );
       // Show success message if screen is still mounted
      if (!mounted) return;
      
      _showSnackBar(
        'Welcome back! Login successful ✨',
        Colors.green,
      );
      // Navigate to min screen
      Navigator.pushReplacement(
        context,
       MaterialPageRoute(builder: (_) => const MainScreen()),
       );
} on FirebaseAuthException catch (error){
  // Handle any other unexpected errors
  _showSnackBar('Something went wrong. Please try again.', Colors.red);
} finally {
  //  // Hide loading state if screen is still mounted
      if (mounted) {
        setState(() {
          _isLoggingIn = false;
        });
    }
  }
}
// Get user-friendly error message from Firebase error
  String _getFirebaseErrorMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return 'No account found with this email address';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'user-disabled':
        return 'This account has been disabled. Contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Login failed. Please check your credentials.';
    }
  }
   // Helper method to show snackbar messages
  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Navigate to signup screen
  void _goToSignup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Signup()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: const Text('login'),
      backgroundColor: Colors.red,
      foregroundColor: Color.white,
      automaticallyImplyLeading: false,
      elevation:0,
    ),
    body: SingleChildScrollView(
      padding:const EdgeInsets.symmetric(horizontal: 24,vertical:20),
      child:Form(key: _fromKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height:30),

            // App Logo and Title Section
              _buildHeaderSection(),
              const SizedBox(height: 40),

               // Email Input Field
              CustomTextField(
                hintText: 'Email address',
                icon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,,
              ),
              
              const SizedBox(height: 16),
              
              // Password Input Field
              CustomTextField(
                hintText: 'Password',
                icon: Icons.lock_outline,
                controller: _passwordController,
                obscureText: true,
                validator: _validatePassword,
              ),
               const SizedBox(height: 32),
              
              // Login Button
              _buildLoginButton(),
              
              const SizedBox(height: 20),
              
              // Sign Up Link
              _buildSignupLink(),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
// Build header section with app logo and title
  Widget _buildHeaderSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.shopping_bag,
            size: 60,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'ShopNepal',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.red,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sign in to continue shopping',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  } 
   // Build login button with loading state
  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoggingIn ? null : _loginUser,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: _isLoggingIn
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
             : const Text(
              'Login',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  // Build signup navigation link
  Widget _buildSignupLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(fontSize: 14),
        ),
        GestureDetector(
          onTap: _goToSignup,
          child: const Text(
            'Create Account',
             style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  // Email validation
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }
      // Basic email format validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  // Password validation
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }
}  



        
      ),))
    )

    ));
  }
}