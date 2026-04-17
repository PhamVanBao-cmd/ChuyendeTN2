import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();

  bool loading = false;
  bool obscure1 = true;
  bool obscure2 = true;

  /// 🔥 CHẶN KÝ TỰ (chỉ cho chữ + số + @)
  final passwordFormatter =
  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@]'));

  Future<void> register() async {
    String pass = password.text;

    /// ❌ rỗng
    if (email.text.isEmpty || pass.isEmpty) {
      showMsg("❌ Nhập đầy đủ thông tin");
      return;
    }

    /// ❌ độ dài
    if (pass.length < 6) {
      showMsg("❌ Mật khẩu ≥ 6 ký tự");
      return;
    }

    /// ❌ ký tự sai
    if (!RegExp(r'^[a-zA-Z0-9@]+$').hasMatch(pass)) {
      showMsg("❌ Chỉ dùng chữ, số và @");
      return;
    }

    /// ❌ chưa có chữ hoa + số
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9])').hasMatch(pass)) {
      showMsg("❌ Phải có chữ HOA và số");
      return;
    }

    /// ❌ không khớp
    if (pass != confirm.text) {
      showMsg("❌ Mật khẩu không khớp");
      return;
    }

    setState(() => loading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: pass,
      );

      Navigator.pop(context);

      showMsg("✅ Đăng ký thành công");
    } catch (e) {
      showMsg("❌ Lỗi: $e");
    }

    setState(() => loading = false);
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        /// 🌈 BACKGROUND
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        /// 🔥 CENTER FIX
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      /// ❤️ ICON
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 50,
                          color: Colors.red,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        "Đăng ký",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// EMAIL
                      TextField(
                        controller: email,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// PASSWORD
                      TextField(
                        controller: password,
                        obscureText: obscure1,
                        inputFormatters: [passwordFormatter], // 🔥 CHẶN
                        decoration: InputDecoration(
                          labelText: "Mật khẩu",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscure1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() => obscure1 = !obscure1);
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// CONFIRM
                      TextField(
                        controller: confirm,
                        obscureText: obscure2,
                        inputFormatters: [passwordFormatter], // 🔥 CHẶN
                        decoration: InputDecoration(
                          labelText: "Xác nhận mật khẩu",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscure2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() => obscure2 = !obscure2);
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loading ? null : register,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: loading
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : const Text("Đăng ký"),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// BACK LOGIN
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Đã có tài khoản? Đăng nhập"),
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