import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun10/constant/style_guide.dart';
import 'package:ws54_flutter_speedrun10/page/home.dart';
import 'package:ws54_flutter_speedrun10/page/register.dart';
import 'package:ws54_flutter_speedrun10/service/auth.dart';
import 'package:ws54_flutter_speedrun10/service/shared_pref.dart';
import 'package:ws54_flutter_speedrun10/service/utilites.dart';
import 'package:ws54_flutter_speedrun10/widget/custom_button.dart';
import 'package:ws54_flutter_speedrun10/widget/fast_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController account_controller;
  late TextEditingController password_controller;
  bool isAccountValid = false;
  bool isPasswordValid = false;
  bool doAuthWarning = false;
  @override
  void initState() {
    super.initState();
    account_controller = TextEditingController();
    password_controller = TextEditingController();
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fast_text("登入介面", AppColor.black, 40, true),
            const SizedBox(height: 20),
            fast_text("帳號", AppColor.black, 30, true),
            const SizedBox(height: 20),
            accountTextForm(),
            const SizedBox(height: 20),
            fast_text("密碼", AppColor.black, 30, true),
            const SizedBox(height: 20),
            passwordTextForm(),
            const SizedBox(height: 20),
            loginButton(),
            const SizedBox(height: 20),
            loginToRegister()
          ],
        ),
      ),
    );
  }

  Widget loginToRegister() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        fast_text("尚未擁有帳號", AppColor.black, 25, false),
        InkWell(
          child: fast_text("註冊", AppColor.darkblue, 35, true),
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RegisterPage())),
        )
      ],
    );
  }

  Widget loginButton() {
    return customButton("登入", 30, AppColor.black, () async {
      if (isAccountValid && isPasswordValid) {
        bool result = await Auth.loginAuth(
            account_controller.text, password_controller.text);
        if (result) {
          String id = await SharedPref.getLoggedUserID();
          if (mounted) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage(userID: id)));
          }
        } else {
          setState(() {
            doAuthWarning = true;
          });
          if (mounted) {
            Utilities.showSnack(context, "登入失敗!");
          }
        }
      } else {
        if (mounted) {
          Utilities.showSnack(context, "請檢查輸入");
        }
      }
    });
  }

  Widget accountTextForm() {
    return SizedBox(
        width: 320,
        child: TextFormField(
          onChanged: (value) => setState(() {
            doAuthWarning = false;
          }),
          controller: account_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (doAuthWarning) {
              isAccountValid = false;
              return "";
            } else if (value == null || value.trim().isEmpty) {
              isAccountValid = false;
              return "請輸入帳號";
            } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                .hasMatch(value)) {
              isAccountValid = false;
              return "請輸入正確的帳號格式";
            } else {
              isAccountValid = true;
              return null;
            }
          },
          decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
              )),
        ));
  }

  bool obscure = true;
  Widget passwordTextForm() {
    return SizedBox(
        width: 320,
        child: TextFormField(
          onChanged: (value) => setState(() {
            doAuthWarning = false;
          }),
          obscureText: obscure,
          controller: password_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (doAuthWarning) {
              isPasswordValid = false;
              return "錯誤的帳號或密碼";
            } else if (value == null || value.trim().isEmpty) {
              isPasswordValid = false;
              return "請輸入密碼";
            } else {
              isPasswordValid = true;
              return null;
            }
          },
          decoration: InputDecoration(
              hintText: "Password",
              suffixIcon: IconButton(
                  icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() {
                        obscure = !obscure;
                      })),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
              )),
        ));
  }
}
