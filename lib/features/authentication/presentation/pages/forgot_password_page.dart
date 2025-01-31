// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../../data/repositories/auth_repository.dart';
import '../bloc/forgot_password/forgot_password_cubit.dart';
import '../widgets/form_input.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(
        authRepository: context.read<AuthRepository>(),
      ),
      child: const ForgotPasswordPageContent(),
    );
  }
}

class ForgotPasswordPageContent extends StatelessWidget {
  const ForgotPasswordPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final email = context.select(
      (ForgotPasswordCubit cubit) => cubit.state.email,
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: naturalWhite,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.11),
            Image.asset("assets/icons/logo.png", width: 100),
            Text("Forgot Password", style: mainTitle),
            SizedBox(height: getHeight(8, context)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Enter your registered email so we can send you a link to reset password",
                style: smallText,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: getHeight(18, context)),
            BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
              listener: (context, state) {
                if (state.status == SendStatus.success) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text("Email sent, please check your email"),
                      ),
                    );
                } else if (state.status == SendStatus.error) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          state.errorMessage,
                        ),
                      ),
                    );
                }
              },
              child: const FormInput(
                formType: FormType.forgotPassword,
                icon: 'mail',
                hintText: 'Email',
              ),
            ),
            SizedBox(height: getHeight(24, context)),
            GestureDetector(
              onTap: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                if (email.trim().isEmpty) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text("Please input an email"),
                      ),
                    );
                } else {
                  context
                      .read<ForgotPasswordCubit>()
                      .sendRequestForgotPassword();
                }
              },
              child: Container(
                height: 56,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: yellowDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                  builder: (context, state) {
                    if (state.status == SendStatus.submitting) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              color: naturalBlack,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text("Loading", style: buttonLarge),
                        ],
                      );
                    } else {
                      return Center(
                        child: Text(
                          "Send",
                          style: buttonLarge,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
