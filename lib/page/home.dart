import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun10/constant/style_guide.dart';
import 'package:ws54_flutter_speedrun10/page/add.dart';
import 'package:ws54_flutter_speedrun10/page/edit.dart';
import 'package:ws54_flutter_speedrun10/page/login.dart';
import 'package:ws54_flutter_speedrun10/page/user.dart';
import 'package:ws54_flutter_speedrun10/service/auth.dart';
import 'package:ws54_flutter_speedrun10/service/sql_service.dart';
import 'package:ws54_flutter_speedrun10/widget/custom_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userID});
  final String userID;
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController tag_controller;
  late TextEditingController url_controller;
  late TextEditingController login_controller;
  late TextEditingController password_controller;
  late TextEditingController id_controller;
  bool hasFav = false;
  int isFav = 1;
  List passwordList = [];
  @override
  void initState() {
    super.initState();
    setPasswordList();
    tag_controller = TextEditingController();
    url_controller = TextEditingController();
    login_controller = TextEditingController();
    password_controller = TextEditingController();
    id_controller = TextEditingController();
  }

  @override
  void dispose() {
    tag_controller.dispose();
    url_controller.dispose();
    login_controller.dispose();
    password_controller.dispose();
    id_controller.dispose();
    super.dispose();
  }

  bool searching = false;

  Future<void> setPasswordList() async {
    searching = false;
    List<PasswordData> _passwordList =
        await PasswordDAO.getPasswordListByUserID(widget.userID);
    setState(() {
      passwordList = _passwordList;
    });
    print("get password :${passwordList.length}");
  }

  Future<void> setPasswordListByCondition() async {
    searching = true;
    List<PasswordData> _passwordList =
        await PasswordDAO.getPasswordListByCondition(
            widget.userID,
            tag_controller.text,
            url_controller.text,
            login_controller.text,
            password_controller.text,
            id_controller.text,
            hasFav,
            isFav);
    setState(() {
      passwordList = _passwordList;
    });
    print("get password by condition:${passwordList.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.black,
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddPage(userID: widget.userID)))),
      drawer: navDrawerContent(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: topBar(),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [searchBar(), passwordListViewBuilder()]),
        ),
      ),
    );
  }

  Widget searchBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFormField(
          controller: tag_controller,
          decoration: const InputDecoration(hintText: "tag"),
        ),
        TextFormField(
          controller: url_controller,
          decoration: const InputDecoration(hintText: "url"),
        ),
        TextFormField(
          controller: login_controller,
          decoration: const InputDecoration(hintText: "login"),
        ),
        TextFormField(
          controller: password_controller,
          decoration: const InputDecoration(hintText: "password"),
        ),
        TextFormField(
          controller: id_controller,
          decoration: const InputDecoration(hintText: "id"),
        ),
        Row(
          children: [
            Expanded(
                child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text("啟用我的最愛"),
                    value: (hasFav),
                    onChanged: (value) => setState(() {
                          hasFav = !hasFav;
                        }))),
            Expanded(
                child: CheckboxListTile(
                    enabled: hasFav,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text("我的最愛"),
                    value: (isFav == 0 ? false : true),
                    onChanged: (value) => setState(() {
                          isFav = isFav == 0 ? 1 : 0;
                        })))
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            customButton("搜尋", 20, AppColor.black, () async {
              setPasswordListByCondition();
            }),
            customButton("取消搜尋", 20, AppColor.black, () async {
              setPasswordList();
            }),
            customButton("消除設定", 20, AppColor.black, () async {
              setState(() {
                tag_controller.text = "";
                url_controller.text = "";
                password_controller.text = "";
                login_controller.text = "";
                id_controller.text = "";
              });
            }),
          ],
        )
      ]),
    );
  }

  Widget passwordListViewBuilder() {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: passwordList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: dataContainer(passwordList[index]),
          );
        });
  }

  Widget dataContainer(PasswordData data) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          border: Border.all(width: 2.0)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(data.tag),
            Text(data.url),
            Text(data.login),
            Text(data.password),
            Text(data.id),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                        shape: const CircleBorder(),
                        side: const BorderSide(color: AppColor.red, width: 2.0),
                        backgroundColor:
                            data.isFav == 0 ? AppColor.white : AppColor.red,
                        iconColor:
                            data.isFav == 0 ? AppColor.red : AppColor.white),
                    onPressed: () async {
                      setState(() {
                        data.isFav = data.isFav == 0 ? 1 : 0;
                      });
                      await PasswordDAO.addPassword(data);
                    },
                    child: const Icon(Icons.favorite)),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: AppColor.green,
                        shape: const CircleBorder()),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => EditPage(data: data))),
                    child: const Icon(
                      Icons.edit,
                      color: AppColor.white,
                    )),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: AppColor.red,
                        shape: const CircleBorder()),
                    onPressed: () async {
                      await PasswordDAO.removePassword(data.id);
                      setState(() {
                        if (searching) {
                          setPasswordListByCondition();
                        } else {
                          setPasswordList();
                        }
                      });
                    },
                    child: const Icon(
                      Icons.delete,
                      color: AppColor.white,
                    ))
              ],
            )
          ]),
    );
  }

  Widget topBar() {
    return AppBar(
      centerTitle: true,
      title: const Text("主畫面"),
      backgroundColor: AppColor.black,
    );
  }

  Widget navDrawerContent() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close)),
          ListTile(
            title: const Text("主畫面"),
            onTap: () => Navigator.of(context).pop(),
            leading: const Icon(Icons.home),
          ),
          ListTile(
            title: const Text("帳戶設置"),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserPage(userID: widget.userID))),
            leading: const Icon(Icons.settings),
          ),
          customButton("登出", 25, AppColor.red, () async {
            await Auth.logOut();
            if (mounted) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            }
          })
        ],
      ),
    );
  }
}
