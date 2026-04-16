import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:e_commerce/core/helpers/validators.dart';
import 'package:e_commerce/core/style/assets.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/core/widgets/custom_phone_field.dart';
import 'package:e_commerce/core/widgets/custom_text_field.dart';
import 'package:e_commerce/core/widgets/stateful/custom_button.dart';
import 'package:e_commerce/core/widgets/stateless/flexiable_image.dart';
import 'package:e_commerce/core/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  late final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlexibleImage(
                source: Assets.assetsImagesLogtaDarkPng,
                height: 150,
                width: 150,
                fit: BoxFit.contain,
              ),
              
              Gap(20),
              LocalizedLabel(
                text: "welcomeAgain",
                style: TextStyles.blackBold32,
              ),
              Gap(10),
              LocalizedLabel(
                text: "welcomeAgain2",
                style: TextStyles.blackBold16,
              ),
              Gap(30),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocalizedLabel(
                      text: "phoneNumber",
                      style: TextStyles.blackBold14,
                    ),
                    Gap(5),
                    CustomPhoneField(
                      onChanged: (phone) {
                        print(phone.completeNumber);
                      },
                    ),
                    Gap(15),
                    Customtextfield(
                      labelText: "password",
                      hintText: '***********',
                      textEditingController: passwordController,
                      validator: Validators.passwordValidator,
                      prefix: Icon(
                        Icons.lock_outlined,
                        color: AppColors.greyColor,
                      ),
                      obscureText: obscureText,
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                    Gap(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: LocalizedLabel(
                            text: "forgetPassword",
                            style: TextStyles.blackRegular14
                                .copyWith(color: AppColors.primaryColor),
                          ),
                        ),
                      ],
                    ),
                    Gap(15),
                    CustomButton(
                      onPressed: () {},
                      title: "login",
                      isIcon: true,
                      icon: Icon(
                        Icons.login,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LocalizedLabel(
                          text: "dontHaveAcc",
                          style: TextStyles.blackRegular14,
                        ),
                        Gap(3),
                        GestureDetector(
                          onTap: () {},
                          child: LocalizedLabel(
                            text: "signInNow",
                            style: TextStyles.blackRegular14
                                .copyWith(color: AppColors.primaryColor , fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
