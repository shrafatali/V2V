class Helper {
  static String validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Enter a Valid Email Address';
    } else {
      return null;
    }
  }

  static String validatePassword(
      String value, String passwordC, String confirmPasswordC) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please Enter Your Password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Password must contain atleast:\n1) 8 character\n2) atleast 1 lower case\n3) atleast 1 upper case\n4) atleast 1 numaric value\n5) atleast on special character';
      } else if (passwordC != confirmPasswordC) {
        return "Please Enter Same Password";
      } else {
        return null;
      }
    }
  }

  static String validatePassword1(String value, String passwordC) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please Enter Your Password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Password must contain atleast:\n- 8 Character\n- Atleast 1 lower case\n- Atleast 1 upper case\n- Atleast 1 numaric value\n- Atleast on special character';
      } else {
        return null;
      }
    }
  }
}
