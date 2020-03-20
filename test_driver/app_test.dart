import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
    group("Flutter Auth Test", () {
      final emailField = find.byValueKey("emailfield");
      final passwordField = find.byValueKey("passwordfield");
      final signbutton = find.byValueKey("log");
      final adminPage = find.byValueKey("home");
      final userPage = find.byValueKey("userp");

      FlutterDriver driver;
      setUpAll(()async{
        driver = await FlutterDriver.connect();
      });

      tearDownAll(()async{
        if(driver != null) {
          driver.close();
        }
      });

      test("login with incorrect email and password",() async{
        await driver.tap(emailField);
        await driver.enterText("test@gmail.com");
        await driver.tap(passwordField);
        await driver.enterText("test123");
        await driver.tap(signbutton);
        await driver.waitUntilNoTransientCallbacks();
        assert(adminPage == null && userPage == null);
      });

      test("login admin with correct email and password",() async {
        await driver.tap(emailField);
        await driver.enterText("madhuwanthiaah@gmail.com");
        await driver.tap(passwordField);
        await driver.enterText("admin123");
        await driver.tap(signbutton);
        assert(adminPage != null && userPage == null);

      });

      test("login user with correct email and password",() async {
        await driver.tap(emailField);
        await driver.enterText("cst16029@gmail.com");
        await driver.tap(passwordField);
        await driver.enterText("user123");
        await driver.tap(signbutton);
        assert(userPage != null && adminPage == null);
      });



    });
  }