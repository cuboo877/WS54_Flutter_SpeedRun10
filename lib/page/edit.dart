import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun10/service/sql_service.dart';

import '../constant/style_guide.dart';
import '../service/utilites.dart';
import '../widget/custom_button.dart';
import '../widget/fast_text.dart';
import 'home.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key, required this.data});
  final PasswordData data;
  @override
  State<StatefulWidget> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController tag_controller;
  late TextEditingController url_controller;
  late TextEditingController login_controller;
  late TextEditingController password_controller;
  late TextEditingController custom_controller;
  bool isTagValid = true;
  bool isUrlValid = true;
  bool isAccountValid = true;
  bool isPasswordValid = true;

  bool hasLower = true;
  bool hasUpper = true;
  bool hasSymbol = true;
  bool hasNumber = true;
  int length = 16;

  @override
  void initState() {
    super.initState();
    tag_controller = TextEditingController(text: widget.data.tag);
    url_controller = TextEditingController(text: widget.data.url);
    login_controller = TextEditingController(text: widget.data.login);
    password_controller = TextEditingController(text: widget.data.password);
    custom_controller = TextEditingController();
  }

  @override
  void dispose() {
    tag_controller.dispose();
    url_controller.dispose();
    login_controller.dispose();
    password_controller.dispose();
    custom_controller.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              fast_text("標籤", AppColor.black, 30, true),
              const SizedBox(height: 20),
              tagTextForm(),
              const SizedBox(height: 20),
              fast_text("網址", AppColor.black, 30, true),
              const SizedBox(height: 20),
              urlTextForm(),
              const SizedBox(height: 20),
              fast_text("登入帳號", AppColor.black, 30, true),
              const SizedBox(height: 20),
              loginTextForm(),
              const SizedBox(height: 20),
              fast_text("密碼", AppColor.black, 30, true),
              const SizedBox(height: 20),
              passwordTextForm(),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  favButton(),
                  randomPasswordSettingButton(),
                ],
              ),
              const SizedBox(height: 20),
              submitButton()
            ]),
      ),
    );
  }

  Widget favButton() {
    return TextButton(
        style: TextButton.styleFrom(
            shape: const CircleBorder(),
            side: const BorderSide(color: AppColor.red, width: 2.0),
            backgroundColor:
                widget.data.isFav == 0 ? AppColor.white : AppColor.red,
            iconColor: widget.data.isFav == 0 ? AppColor.red : AppColor.white),
        onPressed: () => setState(() {
              widget.data.isFav = widget.data.isFav == 0 ? 1 : 0;
            }),
        child: const Icon(Icons.favorite));
  }

  Widget submitButton() {
    return customButton("編輯完成", 30, AppColor.black, () async {
      if (isAccountValid && isPasswordValid && isTagValid && isUrlValid) {
        await PasswordDAO.addPassword(PasswordData(
            widget.data.id,
            widget.data.userID,
            tag_controller.text,
            url_controller.text,
            login_controller.text,
            password_controller.text,
            widget.data.isFav));
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(userID: widget.data.userID)));
        }
      } else {
        if (mounted) {
          Utilities.showSnack(context, "請確認輸入");
        }
      }
    });
  }

  Widget tagTextForm() {
    return SizedBox(
        width: 320,
        child: TextFormField(
          controller: tag_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              isTagValid = false;
              return "請輸入稱呼標籤";
            } else {
              isTagValid = true;
              return null;
            }
          },
          decoration: InputDecoration(
              hintText: "Tag",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
              )),
        ));
  }

  Widget urlTextForm() {
    return SizedBox(
        width: 320,
        child: TextFormField(
          controller: url_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              isUrlValid = false;
              return "請輸入稱呼標籤";
            } else {
              isUrlValid = true;
              return null;
            }
          },
          decoration: InputDecoration(
              hintText: "Url",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
              )),
        ));
  }

  Widget loginTextForm() {
    return SizedBox(
        width: 320,
        child: TextFormField(
          controller: login_controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              isAccountValid = false;
              return "請輸入稱呼標籤";
            } else {
              isAccountValid = true;
              return null;
            }
          },
          decoration: InputDecoration(
              hintText: "Login Account",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
              )),
        ));
  }

  String randomPassword() {
    return Utilities.randomPassword(hasLower, hasUpper, hasSymbol, hasNumber,
        length, custom_controller.text);
  }

  Widget randomPasswordSettingButton() {
    return customButton("隨機密碼設定", 30, AppColor.black, () async {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: const Text("隨機密碼設定"),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  fast_text("指定字元", AppColor.black, 20, false),
                  TextFormField(
                    controller: custom_controller,
                    decoration: const InputDecoration(hintText: "ex:cuboo"),
                  ),
                  CheckboxListTile(
                      title: const Text("包含小寫字母"),
                      value: (hasLower),
                      onChanged: (value) =>
                          setState(() => hasLower = !hasLower)),
                  CheckboxListTile(
                      title: const Text("包含大寫字母"),
                      value: (hasUpper),
                      onChanged: (value) =>
                          setState(() => hasUpper = !hasUpper)),
                  CheckboxListTile(
                      title: const Text("包含符號"),
                      value: (hasSymbol),
                      onChanged: (value) =>
                          setState(() => hasSymbol = !hasSymbol)),
                  CheckboxListTile(
                      title: const Text("包含數字"),
                      value: (hasNumber),
                      onChanged: (value) =>
                          setState(() => hasNumber = !hasNumber)),
                  Row(
                    children: [
                      Slider(
                          min: 1,
                          max: 20,
                          divisions: 19,
                          value: (length.toDouble()),
                          onChanged: (value) =>
                              setState(() => length = value.toInt())),
                      Text(length.toString())
                    ],
                  )
                ]),
              );
            });
          });
    });
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
              suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                    onPressed: () => setState(() {
                          password_controller.text = randomPassword();
                        }),
                    icon: const Icon(Icons.casino)),
                IconButton(
                    icon:
                        Icon(obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() {
                          obscure = !obscure;
                        }))
              ]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
              )),
        ));
  }

  Widget topBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColor.black,
      title: const Text("編輯您的密碼"),
      leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back)),
    );
  }
}
