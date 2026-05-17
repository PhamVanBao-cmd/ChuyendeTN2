import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'register_screen.dart';
import 'welcome_after_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscure = true;
  bool isLoading = false;

  Future<void> login() async {

    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng nhập đầy đủ thông tin"),
        ),
      );

      return;
    }

    setState(() => isLoading = true);

    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const WelcomeAfterLoginScreen(),
        ),
      );

    } on FirebaseAuthException catch (e) {

      String msg = "Đăng nhập thất bại";

      if (e.code == 'user-not-found') {
        msg = "Không tìm thấy tài khoản";
      }

      if (e.code == 'wrong-password') {
        msg = "Sai mật khẩu";
      }

      if (e.code == 'invalid-email') {
        msg = "Email không hợp lệ";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
          ),
        ),

        child: SafeArea(

          child: Center(

            child: SingleChildScrollView(

              child: ConstrainedBox(

                constraints: const BoxConstraints(maxWidth: 420),

                child: Padding(

                  padding: const EdgeInsets.all(24),

                  child: Column(
                    children: [

                      /// TOP ICON
                      Container(
                        padding: const EdgeInsets.all(22),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        "Chào mừng trở lại",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Đăng nhập để tiếp tục",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 35),

                      /// CARD
                      Container(

                        padding: const EdgeInsets.all(24),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15,
                            ),
                          ],
                        ),

                        child: Column(
                          children: [

                            TextField(
                              controller: emailController,

                              decoration: InputDecoration(
                                labelText: "Email",

                                prefixIcon: const Icon(Icons.email),

                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(16),
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            TextField(
                              controller: passwordController,
                              obscureText: obscure,

                              decoration: InputDecoration(
                                labelText: "Mật khẩu",

                                prefixIcon: const Icon(Icons.lock),

                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscure
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),

                                  onPressed: () {
                                    setState(() {
                                      obscure = !obscure;
                                    });
                                  },
                                ),

                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(16),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,

                              child: ElevatedButton(
                                onPressed:
                                isLoading ? null : login,

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding:
                                  const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(16),
                                  ),
                                ),

                                child: isLoading
                                    ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    : const Text(
                                  "Đăng nhập",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                    const RegisterScreen(),
                                  ),
                                );
                              },

                              child: const Text(
                                "Chưa có tài khoản? Đăng ký",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}