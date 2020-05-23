import 'package:flutter/material.dart';
import 'package:guitar_tabs/colors.dart';
import 'main.dart';

TextFormField iconFormField(
    String title,
    IconData icon,
    TextEditingController passwordController,
    TextEditingController emailController) {
  return TextFormField(
    validator: (value) {
      if (value.isEmpty) {
        return 'Pole nie może być puste!';
      }
      return null;
    },
    obscureText: title == "Hasło" ? true : false,
    controller: title == "Hasło" ? passwordController : emailController,
    style: TextStyle(color: Colors.black),
    decoration: InputDecoration(
      // hintText: title,
      // hintStyle: TextStyle(color: Colors.grey[600]),
      labelText: title,
      labelStyle: TextStyle(color: Colors.grey[700]),
      icon: Icon(icon, color: kPrimaryColor),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[600]),
      ),
    ),
  );
}

TextFormField emailField(String title, TextEditingController emailController) {
  return TextFormField(
    validator: (value) {
      if (value.isEmpty) {
        return 'You have to fill this field!';
      }
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value);
      if (!emailValid) {
        return 'The email address is incorrect!';
      }
    },
    controller: emailController,
    style: TextStyle(color: Colors.black),
    decoration: fieldDecoration(title),
  );
}

TextFormField tabTextField(String title, TextEditingController tabController) {
  return TextFormField(
    keyboardType: TextInputType.multiline,
    maxLines: null,
    validator: (value) {
      if (value.isEmpty) {
        return 'You have to fill this field!';
      }
    },
    controller: tabController,
    style: TextStyle(color: Colors.black),
    decoration: fieldDecoration(title),
  );
}

TextFormField tabField(String title, TextEditingController tabController) {
  return TextFormField(
    validator: (value) {
      if (value.isEmpty) {
        return 'You have to fill this field!';
      }
    },
    controller: tabController,
    style: TextStyle(color: Colors.black),
    decoration: fieldDecoration(title),
  );
}

TextFormField passwordField(
    String title,
    TextEditingController confirmPasswordController,
    TextEditingController passwordController) {
  return TextFormField(
    validator: (value) {
      if (value.isEmpty) {
        return 'You have to fill this field!';
      }
      if (value != confirmPasswordController.text) {
        return 'Passwords does not match!';
      }
      bool passwordValid =
          RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
              .hasMatch(value);
      if (!passwordValid) {
        return "Password has to contain at least: \n - 8 signs\n - 1 digit,\n - 1 upper case letter, \n - 1 lower case letter";
      }
    },
    obscureText: true,
    textAlign: TextAlign.justify,
    controller: passwordController,
    style: TextStyle(color: Colors.black),
    decoration: fieldDecoration(title),
  );
}

TextFormField confirmPasswordField(
    String title,
    TextEditingController confirmPasswordController,
    TextEditingController passwordController) {
  return TextFormField(
    validator: (value) {
      if (value.isEmpty) {
        return 'You have to fill this field!';
      }
      if (value != passwordController.text) {
        return 'Passwords does not match!';
      }
    },
    obscureText: true,
    controller: confirmPasswordController,
    style: TextStyle(color: Colors.black),
    decoration: fieldDecoration(title),
  );
}

TextFormField singePasswordField(
    String title, TextEditingController passwordController) {
  return TextFormField(
    validator: (value) {
      if (value.isEmpty) {
        return 'You have to fill this field!';
      }
    },
    obscureText: true,
    textAlign: TextAlign.justify,
    controller: passwordController,
    style: TextStyle(color: Colors.black),
    decoration: fieldDecoration(title),
  );
}

TextFormField telephoneField(
    String title, TextEditingController telephoneController) {
  return TextFormField(
    validator: (value) {
      if (value.isEmpty) {
        return 'You have to fill this field!';
      }
      bool telephoneValid = RegExp(r'^(?=.*?[0-9]).{9}$').hasMatch(value);
      if (!telephoneValid) {
        return 'Numer telefonu musi się składać z 9 cyfr!';
      }
    },
    controller: telephoneController,
    style: TextStyle(color: Colors.black),
    decoration: fieldDecoration(title),
  );
}

TextFormField firstNameField(
    String title, TextEditingController firstNameController) {
  return TextFormField(
    textCapitalization: TextCapitalization.sentences,
    validator: (value) {
      if (value.isEmpty) {
        return 'You have to fill this field!';
      }
    },
    controller: firstNameController,
    style: TextStyle(color: Colors.black),
    decoration: fieldDecoration(title),
  );
}

TextFormField nickField(String title, TextEditingController nickController) {
  return TextFormField(
    textCapitalization: TextCapitalization.sentences,
    validator: (value) {
      if (value.isEmpty) {
        return 'You have to fill this field!';
      }
    },
    controller: nickController,
    style: TextStyle(color: Colors.black),
    decoration: fieldDecoration(title),
  );
}

TextFormField lastNameField(
    String title, TextEditingController lastNameController) {
  return TextFormField(
    textCapitalization: TextCapitalization.sentences,
    validator: (value) {
      if (value.isEmpty) {
        return 'You have to fill this field!';
      }
    },
    controller: lastNameController,
    style: TextStyle(color: Colors.black),
    decoration: fieldDecoration(title),
  );
}

TextFormField couponFormField(
    String title, TextEditingController couponController, bool enabled) {
  return TextFormField(
      validator: (value) {
        if ((value.length != 13) ||
            int.tryParse(value) == null ||
            !eanChecksum(value) ||
            !check_digit(value)) {
          return 'Kupon niepoprawny';
        }
      },
      enabled: enabled,
      controller: couponController,
      style: TextStyle(color: Colors.black),
      decoration: fieldDecoration(title),
      keyboardType: TextInputType.number);
}

InputDecoration fieldDecoration(title) {
  return InputDecoration(
    contentPadding: EdgeInsets.zero,
    // hintText: title,
    // hintStyle: TextStyle(color: Colors.grey[600]),
    labelText: title,
    errorMaxLines: 5,
    labelStyle: TextStyle(color: Colors.grey[700]),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[600]),
    ),
  );
}

InkWell dateFormField(String title, BuildContext context, Function setState,
    TextEditingController dateController, formatter, bool enabled) {
  return InkWell(
    onTap: () {
      if (enabled) {
        _selectDate(context, setState, dateController, formatter);
      }
    },
    child: IgnorePointer(
      child: TextFormField(
        enabled: enabled,
        decoration: fieldDecoration(title),
        controller: dateController,
      ),
    ),
  );
}

Future _selectDate(BuildContext context, Function setState,
    TextEditingController dateController, formatter) async {
  DateTime picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2019),
    locale: Locale('pl'),
    lastDate: DateTime.now(),
    builder: (BuildContext context, Widget child) {
      return Theme(
        data: ThemeData(
          primaryColor: kPrimaryColor,
          accentColor: kPrimaryColor,
          primarySwatch: kPrimaryColor,
          //dialogBackgroundColor: Colors.white,//Background color
        ),
        child: child,
      );
    },
  );
  if (picked != null)
    setState(() => dateController.text = formatter.format(picked).toString());
}

bool eanChecksum(String code) {
  String substring = code.substring(8, 12);
  int total = 0;
  int maxIndex = substring.length;
  int index;
  for (var i = 0; i < 3; i++) {
    index = maxIndex - i - 1;
    if (i % 2 != 0) {
      total += int.parse(substring[index]);
    } else {
      total += 3 * int.parse(substring[index]);
    }
  }
  return mod10(total) == int.parse(code[7]);
}

int mod10(int total) {
  int r = 10 - total % 10;
  if (r == 10) {
    r = 0;
  }
  return r;
}

bool check_digit(String code) {
  List<int> digits = code.split('').map((val) => int.parse(val)).toList();
  int last = digits.removeLast();
  int sum3 = 0;
  int sum1 = 0;
  for (int i = 0; i < digits.length; i++) {
    if (i % 2 == 0) {
      sum3 += 3 * digits[i];
    } else {
      sum1 += digits[i];
    }
  }
  int result = (sum3 + sum1) % 10;
  return result == last;
}
