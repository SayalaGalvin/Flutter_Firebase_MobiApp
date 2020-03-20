import 'package:flutter_project/loginpage.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  test('empty email return error',(){
  var result = EmailFieldValidator.validate('');
  expect(result,'Email cannot be empty');});

  test('not empty email return error',(){
    var result = EmailFieldValidator.validate('hasini@gmail.com');
    expect(result,null);});

  test('Invalid Email Test', () {
    var result = EmailFieldValidator.validate('hasini');
    expect(result, 'Enter Valid Email');
  });

  test('empty password return error',(){
    var result = PasswordFieldValidator.validate('');
    expect(result,'Password cannot be empty');});

  test('not empty password return error',(){
    var result = PasswordFieldValidator.validate('password');
    expect(result,null);});

  test('Invalid Password Test', () {
    var result = PasswordFieldValidator.validate('123');
    expect(result, 'Password must be more than 6 character');
  });

}