import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {

  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();

  bool loading = false;

  bool obscure1 = true;
  bool obscure2 = true;

  late AnimationController animationController;

  late Animation<double> fadeAnimation;

  /// ================= PASSWORD FORMAT =================
  final passwordFormatter =
  FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9@]'),
  );

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    animationController.forward();
  }

  @override
  void dispose() {

    email.dispose();
    password.dispose();
    confirm.dispose();

    animationController.dispose();

    super.dispose();
  }

  /// ================= SHOW MESSAGE =================
  void showMsg(String msg, {Color? color}) {

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(
        backgroundColor: color,

        behavior: SnackBarBehavior.floating,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),

        content: Text(
          msg,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// ================= REGISTER =================
  Future<void> register() async {

    FocusScope.of(context).unfocus();

    final userEmail = email.text.trim();

    final pass = password.text.trim();

    final confirmPass = confirm.text.trim();

    /// EMPTY
    if (userEmail.isEmpty ||
        pass.isEmpty ||
        confirmPass.isEmpty) {

      showMsg(
        "Vui lòng nhập đầy đủ thông tin",
        color: Colors.red,
      );

      return;
    }

    /// EMAIL INVALID
    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(userEmail)) {

      showMsg(
        "Email không hợp lệ",
        color: Colors.red,
      );

      return;
    }

    /// LENGTH
    if (pass.length < 6) {

      showMsg(
        "Mật khẩu phải từ 6 ký tự",
        color: Colors.red,
      );

      return;
    }

    /// SPECIAL VALIDATION
    if (!RegExp(
      r'^(?=.*[A-Z])(?=.*[0-9])[a-zA-Z0-9@]+$',
    ).hasMatch(pass)) {

      showMsg(
        "Mật khẩu cần có chữ HOA và số",
        color: Colors.red,
      );

      return;
    }

    /// MATCH
    if (pass != confirmPass) {

      showMsg(
        "Mật khẩu xác nhận không khớp",
        color: Colors.red,
      );

      return;
    }

    setState(() {
      loading = true;
    });

    try {

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: userEmail,
        password: pass,
      );

      if (!mounted) return;

      showMsg(
        "Đăng ký thành công 🎉",
        color: Colors.green,
      );

      Future.delayed(
        const Duration(milliseconds: 1200),
            () {

          Navigator.pop(context);
        },
      );

    } on FirebaseAuthException catch (e) {

      String msg = "Đăng ký thất bại";

      if (e.code == 'email-already-in-use') {
        msg = "Email đã tồn tại";
      }

      if (e.code == 'invalid-email') {
        msg = "Email không hợp lệ";
      }

      if (e.code == 'weak-password') {
        msg = "Mật khẩu quá yếu";
      }

      showMsg(
        msg,
        color: Colors.red,
      );

    } catch (e) {

      showMsg(
        "Lỗi: $e",
        color: Colors.red,
      );
    }

    if (mounted) {

      setState(() {
        loading = false;
      });
    }
  }

  /// ================= PASSWORD CHECK =================
  Widget passwordRule(
      String text,
      bool valid,
      ) {

    return Row(
      children: [

        Icon(
          valid
              ? Icons.check_circle
              : Icons.cancel,

          size: 18,

          color:
          valid
              ? Colors.green
              : Colors.red,
        ),

        const SizedBox(width: 8),

        Text(
          text,

          style: TextStyle(
            color:
            valid
                ? Colors.green
                : Colors.red,

            fontSize: 13,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final hasUpper =
    RegExp(r'[A-Z]').hasMatch(password.text);

    final hasNumber =
    RegExp(r'[0-9]').hasMatch(password.text);

    final hasLength =
        password.text.length >= 6;

    return Scaffold(

      body: Container(

        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(

          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              Color(0xFF11998e),
              Color(0xFF38ef7d),
            ],
          ),
        ),

        child: SafeArea(

          child: FadeTransition(

            opacity: fadeAnimation,

            child: Center(

              child: SingleChildScrollView(

                padding: const EdgeInsets.all(20),

                child: ConstrainedBox(

                  constraints: const BoxConstraints(
                    maxWidth: 420,
                  ),

                  child: Container(

                    padding: const EdgeInsets.all(26),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(32),

                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                        ),
                      ],
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [

                        /// ================= TOP ICON =================
                        Container(

                          padding: const EdgeInsets.all(22),

                          decoration: BoxDecoration(
                            color:
                            Colors.green.withOpacity(0.12),

                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.favorite,
                            size: 60,
                            color: Colors.red,
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// ================= TITLE =================
                        const Text(
                          "Tạo tài khoản",

                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Đăng ký để bắt đầu theo dõi sức khỏe",

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            color: Colors.grey,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 28),

                        /// ================= EMAIL =================
                        TextField(

                          controller: email,

                          keyboardType:
                          TextInputType.emailAddress,

                          decoration: InputDecoration(

                            labelText: "Email",

                            prefixIcon: const Icon(
                              Icons.email_outlined,
                            ),

                            filled: true,

                            fillColor:
                            const Color(0xFFF5F7FB),

                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(18),

                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// ================= PASSWORD =================
                        TextField(

                          controller: password,

                          obscureText: obscure1,

                          inputFormatters: [
                            passwordFormatter,
                          ],

                          onChanged: (_) {
                            setState(() {});
                          },

                          decoration: InputDecoration(

                            labelText: "Mật khẩu",

                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),

                            suffixIcon: IconButton(

                              icon: Icon(
                                obscure1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),

                              onPressed: () {

                                setState(() {
                                  obscure1 = !obscure1;
                                });
                              },
                            ),

                            filled: true,

                            fillColor:
                            const Color(0xFFF5F7FB),

                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(18),

                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        /// ================= PASSWORD RULE =================
                        Container(

                          width: double.infinity,

                          padding: const EdgeInsets.all(14),

                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,

                            borderRadius:
                            BorderRadius.circular(16),
                          ),

                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              const Text(
                                "Yêu cầu mật khẩu",

                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              passwordRule(
                                "Ít nhất 6 ký tự",
                                hasLength,
                              ),

                              const SizedBox(height: 6),

                              passwordRule(
                                "Có ít nhất 1 chữ HOA",
                                hasUpper,
                              ),

                              const SizedBox(height: 6),

                              passwordRule(
                                "Có ít nhất 1 số",
                                hasNumber,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// ================= CONFIRM =================
                        TextField(

                          controller: confirm,

                          obscureText: obscure2,

                          inputFormatters: [
                            passwordFormatter,
                          ],

                          onSubmitted: (_) {
                            if (!loading) {
                              register();
                            }
                          },

                          decoration: InputDecoration(

                            labelText:
                            "Xác nhận mật khẩu",

                            prefixIcon: const Icon(
                              Icons.lock_reset,
                            ),

                            suffixIcon: IconButton(

                              icon: Icon(
                                obscure2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),

                              onPressed: () {

                                setState(() {
                                  obscure2 = !obscure2;
                                });
                              },
                            ),

                            filled: true,

                            fillColor:
                            const Color(0xFFF5F7FB),

                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(18),

                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// ================= BUTTON =================
                        SizedBox(

                          width: double.infinity,

                          child: ElevatedButton(

                            onPressed:
                            loading
                                ? null
                                : register,

                            style: ElevatedButton.styleFrom(

                              backgroundColor:
                              Colors.green,

                              foregroundColor:
                              Colors.white,

                              elevation: 0,

                              padding:
                              const EdgeInsets.symmetric(
                                vertical: 17,
                              ),

                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(18),
                              ),
                            ),

                            child:
                            loading

                                ? const SizedBox(
                              width: 25,
                              height: 25,

                              child:
                              CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )

                                : const Text(
                              "Đăng ký",

                              style: TextStyle(
                                fontSize: 17,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// ================= LOGIN =================
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,

                          children: [

                            const Text(
                              "Đã có tài khoản?",
                            ),

                            TextButton(

                              onPressed: () {
                                Navigator.pop(context);
                              },

                              child: const Text(
                                "Đăng nhập",
                                style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
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
        ),
      ),
    );
  }
}