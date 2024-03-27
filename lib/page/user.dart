import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun10/page/home.dart';
import 'package:ws54_flutter_speedrun10/service/sql_service.dart';

import '../constant/style_guide.dart';
import '../service/auth.dart';
import '../service/utilites.dart';
import '../widget/custom_button.dart';
import '../widget/fast_text.dart';
import 'details.dart';
import 'login.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.userID});
  final String userID;
  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  UserData userData = UserData("", "", "", "", "");
  late TextEditingController account_controller;
  late TextEditingController password_controller;
  late TextEditingController username_controller;
  late TextEditingController birthday_controller;
  bool isUserNameValid = true;
  bool isBirthdaValid = true;
  bool isAccountValid = true;
  bool isPasswordValid = true;
  @override
  void initState() {
    super.initState();
    setUserData();
    account_controller = TextEditingController();
    password_controller = TextEditingController();
    username_controller = TextEditingController();
    birthday_controller = TextEditingController();
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_controller.dispose();
    username_controller.dispose();
    birthday_controller.dispose();
    super.dispose();
  }

  Future<void> setUserData() async {
    UserData _userData = await UserDAO.getUserDataByUserID(widget.userID);
    setState(() {
      userData = _userData;
      account_controller.text = _userData.account;
      password_controller.text = _userData.password;
      username_controller.text = _userData.username;
      birthday_controller.text = _userData.birthday;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: topBar(),
      ),
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
            fast_text("使用者名稱", AppColor.black, 30, true),
            const SizedBox(height: 20),
            usernameTextForm(),
            const SizedBox(height: 20),
            fast_text("生日", AppColor.black, 30, true),
            const SizedBox(height: 20),
            birthdayTextForm(),
            const SizedBox(height: 20),
            submitButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget submitButton() {
    return customButton("編輯完成", 30, AppColor.black, () async {
      if (isAccountValid &&
          isPasswordValid &&
          isBirthdaValid &&
          isUserNameValid) {
        await UserDAO.updateUser(UserData(
            widget.userID,
            username_controller.text,
            account_controller.text,
            password_controller.text,
            birthday_controller.text));
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(userID: widget.userID)));
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

  Widget usernameTextForm() {
    return SizedBox(
        width: 320,
        child: TextFormField(
          controller: username_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              isUserNameValid = false;
              return "請輸入稱呼您的名稱";
            } else {
              isUserNameValid = true;
              return null;
            }
          },
          decoration: InputDecoration(
              hintText: "Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
              )),
        ));
  }

  Widget birthdayTextForm() {
    return SizedBox(
        width: 320,
        child: TextFormField(
          controller: birthday_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTap: () async {
            DateTime? _picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2026));
            if (_picked != null) {
              isBirthdaValid = true;
              setState(() {
                birthday_controller.text = _picked.toString().split(" ")[0];
              });
            } else {
              isBirthdaValid = false;
            }
          },
          readOnly: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              isBirthdaValid = false;
              return "請輸入生日";
            } else {
              isBirthdaValid = true;
              return null;
            }
          },
          decoration: InputDecoration(
              hintText: "Birthday",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
              )),
        ));
  }

  Widget topBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColor.black,
      title: const Text("編輯使用者資料"),
      leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back)),
    );
  }
}
