import 'package:get/get.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/home/home_page.dart';
// ignore: unused_import
import 'package:cafe_pinkeu/presentation/auth/pages/login/login.dart';

class Routes {
  static const HomePage = '/home';
  static const LoginPage = '/login';
}

class AppPages {
  static final routes = [
    GetPage(name: Routes.HomePage, page: () => HomePage()),
    GetPage(name: Routes.LoginPage, page: () => Login()),
  ];
}
