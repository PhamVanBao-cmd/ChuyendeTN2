import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'register_screen.dart';
import 'welcome_after_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  bool obscure = true;

  bool isLoading = false;

  /// ================= LOGIN =================
  Future<void> login() async {

    if (emailController.text
        .trim()
        .isEmpty ||
        passwordController.text
            .trim()
            .isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Vui lòng nhập đầy đủ thông tin",
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email:
        emailController.text.trim(),

        password:
        passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,

        MaterialPageRoute(
          builder:
              (_) =>
          const WelcomeAfterLoginScreen(),
        ),
      );

    } on FirebaseAuthException catch (e) {

      String msg =
          "Đăng nhập thất bại";

      if (e.code ==
          'user-not-found') {

        msg =
        "Không tìm thấy tài khoản";
      }

      if (e.code ==
          'wrong-password') {

        msg = "Sai mật khẩu";
      }

      if (e.code ==
          'invalid-email') {

        msg =
        "Email không hợp lệ";
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(msg),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text("Lỗi: $e"),
        ),
      );
    }

    if (mounted) {

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {

    emailController.dispose();

    passwordController.dispose();

    super.dispose();
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
              Color(0xFF4A00E0),
              Color(0xFF8E2DE2),
            ],
          ),
        ),

        child: SafeArea(

          child: Center(

            child: SingleChildScrollView(

              child: Padding(
                padding:
                const EdgeInsets.all(24),

                child: Column(
                  children: [

                    /// ICON
                    Hero(
                      tag: "health_logo",

                      child: Container(
                        padding:
                        const EdgeInsets.all(24),

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          color:
                          Colors.white.withOpacity(
                            0.15,
                          ),
                        ),

                        child: const Icon(
                          Icons.favorite,
                          size: 75,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      "Xin chào 👋",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

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
                      width: double.infinity,

                      padding:
                      const EdgeInsets.all(24),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                        BorderRadius.circular(30),

                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15,
                          ),
                        ],
                      ),

                      child: Column(
                        children: [

                          /// EMAIL
                          TextField(
                            controller:
                            emailController,

                            keyboardType:
                            TextInputType
                                .emailAddress,

                            decoration:
                            InputDecoration(
                              labelText:
                              "Email",

                              prefixIcon:
                              const Icon(
                                Icons.email,
                              ),

                              filled: true,

                              fillColor:
                              const Color(
                                0xFFF5F7FB,
                              ),

                              border:
                              OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(
                                  18,
                                ),

                                borderSide:
                                BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          /// PASSWORD
                          TextField(
                            controller:
                            passwordController,

                            obscureText:
                            obscure,

                            onSubmitted:
                                (_) {

                              if (!isLoading) {
                                login();
                              }
                            },

                            decoration:
                            InputDecoration(
                              labelText:
                              "Mật khẩu",

                              prefixIcon:
                              const Icon(
                                Icons.lock,
                              ),

                              suffixIcon:
                              IconButton(
                                onPressed: () {

                                  setState(() {
                                    obscure =
                                    !obscure;
                                  });
                                },

                                icon: Icon(
                                  obscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),

                              filled: true,

                              fillColor:
                              const Color(
                                0xFFF5F7FB,
                              ),

                              border:
                              OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(
                                  18,
                                ),

                                borderSide:
                                BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 28,
                          ),

                          /// BUTTON
                          SizedBox(
                            width:
                            double.infinity,

                            child:
                            ElevatedButton(
                              onPressed:
                              isLoading
                                  ? null
                                  : login,

                              style:
                              ElevatedButton
                                  .styleFrom(
                                backgroundColor:
                                const Color(
                                  0xFF2575FC,
                                ),

                                foregroundColor:
                                Colors.white,

                                elevation: 6,

                                padding:
                                const EdgeInsets.symmetric(
                                  vertical:
                                  17,
                                ),

                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                    18,
                                  ),
                                ),
                              ),

                              child:
                              isLoading
                                  ? const SizedBox(
                                width:
                                24,

                                height:
                                24,

                                child:
                                CircularProgressIndicator(
                                  color:
                                  Colors.white,
                                  strokeWidth:
                                  2,
                                ),
                              )
                                  : const Text(
                                "Đăng nhập",

                                style:
                                TextStyle(
                                  fontSize:
                                  17,

                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 14,
                          ),

                          TextButton(
                            onPressed: () {

                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder:
                                      (_) =>
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
    );
  }
}