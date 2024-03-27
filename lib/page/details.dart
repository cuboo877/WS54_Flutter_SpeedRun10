import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun10/page/home.dart';
import 'package:ws54_flutter_speedrun10/service/shared_pref.dart';
import 'package:ws54_flutter_speedrun10/service/sql_service.dart';

import '../constant/style_guide.dart';
import '../service/auth.dart';
import '../service/utilites.dart';
import '../widget/custom_button.dart';
import '../widget/fast_text.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.account, required this.password});
  final String account;
  final String password;
  @override
  State<StatefulWidget> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late TextEditingController username_controller;
  late TextEditingController birthday_controller;
  bool isUserNameValid = false;
  bool isBirthdaValid = false;
  @override
  void initState() {
    super.initState();
    username_controller = TextEditingController();
    birthday_controller = TextEditingController();
  }

  @override
  void dispose() {
    username_controller.dispose();
    birthday_controller.dispose();
    super.dispose();
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
            fast_text("使用者資料", AppColor.black, 40, true),
            const SizedBox(height: 20),
            fast_text("名稱", AppColor.black, 30, true),
            const SizedBox(height: 20),
            usernameTextForm(),
            const SizedBox(height: 20),
            fast_text("生日", AppColor.black, 30, true),
            const SizedBox(height: 20),
            birthdayTextForm(),
            const SizedBox(height: 20),
            startButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget startButton() {
    return customButton("開始使用", 30, AppColor.black, () async {
      if (isUserNameValid && isBirthdaValid) {
        await Auth.registerAtuh(UserData(
            Utilities.randomID(),
            username_controller.text,
            widget.account,
            widget.password,
            birthday_controller.text));
        String id = await SharedPref.getLoggedUserID();
        if (mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage(userID: id)));
        }
      } else {
        if (mounted) {
          Utilities.showSnack(context, "請檢查輸入");
        }
      }
    });
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
      backgroundColor: AppColor.black,
      title: const Text("即將完成註冊"),
      leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back)),
    );
  }
}
