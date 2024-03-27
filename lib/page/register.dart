import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun10/page/details.dart';
import 'package:ws54_flutter_speedrun10/page/login.dart';
import 'package:ws54_flutter_speedrun10/service/utilites.dart';

import '../constant/style_guide.dart';
import '../service/auth.dart';
import '../service/shared_pref.dart';
import '../widget/custom_button.dart';
import '../widget/fast_text.dart';
import 'home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController account_controller;
  late TextEditingController password_controller;
  late TextEditingController confirm_controller;
  bool isAccountValid = false;
  bool isPasswordValid = false;
  bool isConfirmValid = false;
  @override
  void initState() {
    super.initState();
    account_controller = TextEditingController();
    password_controller = TextEditingController();
    confirm_controller = TextEditingController();
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_controller.dispose();
    confirm_controller.dispose();
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
            fast_text("註冊介面", AppColor.black, 40, true),
            const SizedBox(height: 20),
            fast_text("帳號", AppColor.black, 30, true),
            const SizedBox(height: 20),
            accountTextForm(),
            const SizedBox(height: 20),
            fast_text("密碼", AppColor.black, 30, true),
            const SizedBox(height: 20),
            passwordTextForm(),
            const SizedBox(height: 20),
            confirmTextForm(),
            const SizedBox(height: 20),
            registerButton(),
            const SizedBox(height: 20),
            registerToLogin()
          ],
        ),
      ),
    );
  }

  Widget registerToLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        fast_text("已經擁有帳號", AppColor.black, 25, false),
        InkWell(
          child: fast_text("登入", AppColor.darkblue, 35, true),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const LoginPage())),
        )
      ],
    );
  }

  Widget registerButton() {
    return customButton("註冊", 30, AppColor.black, () async {
      if (isAccountValid && isPasswordValid && isConfirmValid) {
        bool hasRegistered =
            await Auth.hasAcocuntBeenRegister(account_controller.text);
        if (hasRegistered) {
          if (mounted) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginPage()));
            Utilities.showSnack(context, "此帳號已被註冊!");
          }
        } else {
          if (mounted) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailsPage(
                      account: account_controller.text,
                      password: password_controller.text,
                    )));
          }
        }
      } else {
        if (mounted) {
          Utilities.showSnack(context, "請確認輸入!");
        }
      }
    });
  }

  Widget accountTextForm() {
    return SizedBox(
        width: 320,
        child: TextFormField(
          controller: account_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
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
          obscureText: obscure,
          controller: password_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
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

  bool obscure2 = true;
  Widget confirmTextForm() {
    return SizedBox(
        width: 320,
        child: TextFormField(
          obscureText: obscure2,
          controller: confirm_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              isConfirmValid = false;
              return "請輸入密碼";
            } else if (value != password_controller.text) {
              isConfirmValid = false;
              return "請確認密碼!";
            } else {
              isConfirmValid = true;
              return null;
            }
          },
          decoration: InputDecoration(
              hintText: "Confirm Password",
              suffixIcon: IconButton(
                  icon:
                      Icon(obscure2 ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() {
                        obscure2 = !obscure2;
                      })),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
              )),
        ));
  }
}
