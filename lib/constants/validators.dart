part of constants;

class Validators {
  static final passwordValidator = MultiValidator(
    [
      RequiredValidator(errorText: 'Password is required'),
      // MinLengthValidator(
      //   8,
      //   errorText: 'password must be at least 8 digits long',
      // ),
      // PatternValidator(
      //   r'(?=.*?[#?!@$%^&*-])',
      //   errorText: 'passwords must have at least one special character',
      // )
    ],
  );

  static final emailValidator = MultiValidator(
    [
      RequiredValidator(errorText: 'Email is required'),
      EmailValidator(errorText: "Enter a valid email address"),
    ],
  );

  static bool isUserId(String text) {
    return RegExp(r'^([a-zA-Z0-9]{4,})$').hasMatch(text);
  }
}
