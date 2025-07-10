import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Canteen',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(), // Start with login screen
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

//LOGIN SCREEN
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  // Canteen color scheme
  final Color primaryOrange = const Color(0xFFFF6B35);
  final Color secondaryOrange = const Color(0xFFFF8C42);
  final Color accentYellow = const Color(0xFFFFC947);
  final Color darkGreen = const Color(0xFF2D5016);
  final Color lightGreen = const Color(0xFF8BC34A);
  final Color backgroundColor = const Color(0xFFFFF8E1);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
            );
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 1),

                    // Logo Section
                    _buildCompactLogo(),
                    const SizedBox(height: 20),

                    // Welcome Text
                    _buildCompactWelcomeText(),
                    const SizedBox(height: 30),

                    // Login Form
                    _buildLoginForm(),
                    const SizedBox(height: 20),

                    // Login Button
                    _buildLoginButton(),
                    const SizedBox(height: 15),

                    // Forgot Password & Sign Up in one row
                    _buildBottomActions(),

                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactLogo() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [primaryOrange, secondaryOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryOrange.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.restaurant,
        size: 45,
        color: Colors.white,
      ),
    );
  }

  Widget _buildCompactWelcomeText() {
    return Column(
      children: [
        Text(
          'E-Canteen',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Delicious food at your fingertips',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w400,
            shadows: [
              Shadow(
                blurRadius: 8.0,
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        // Email Field
        _buildCustomTextField(
          controller: _emailController,
          hintText: 'Enter your email',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Password Field
        _buildCustomTextField(
          controller: _passwordController,
          hintText: 'Enter your password',
          prefixIcon: Icons.lock_outline,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: darkGreen.withOpacity(0.6),
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        style: TextStyle(
          color: darkGreen,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: darkGreen.withOpacity(0.5),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: primaryOrange,
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: primaryOrange,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [primaryOrange, secondaryOrange],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryOrange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              )
            : const Text(
                'Login',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            // Handle forgot password
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Forgot password feature coming soon!'),
                backgroundColor: primaryOrange,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // Navigate to sign up screen
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Sign up feature coming soon!'),
                backgroundColor: lightGreen,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: accentYellow,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// YOUR ORIGINAL HOME SCREEN WITH NAVIGATION
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _cartItemCount = 3; // Dummy cart item count for badge

  final List<Widget> _screens = [
    MenuScreen(),
    CartScreen(),
    OrderHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Canteen'),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
              ),
              if (_cartItemCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '$_cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                // Navigate back to login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}

// YOUR ORIGINAL SCREEN CLASSES
class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Menu Screen'),
    );
  }
}

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Cart Screen'),
    );
  }
}

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Order History Screen'),
    );
  }
}
