import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verify_example/bloc/signup/signup_bloc.dart';
import 'package:verify_example/bloc/signup/signup_error.dart';

class SignUpPage extends StatelessWidget {
  final bloc = SignUpBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<SignUpBloc>(
            create: (_) => bloc,
            child: Padding(
              padding: EdgeInsets.all(30),
              child: BlocBuilder<SignUpBloc, SignUpState>(
                builder: (context, state) {
                  // return buildBody(context, state);
                  return buildState(context, state);
                },
              ),
            )),
      ),
    );
  }

  Container buildState(BuildContext context, SignUpState state) {
    final errors = state.errors;
    return Container(
        child: Column(
      children: <Widget>[
        buildFormField(context,
            title: 'Email',
            handler: (str) => SignUpEvent.setEmail(str),
            error: errors[SignUpFormField.email]?.firstOrNull),
        buildFormField(context,
            title: 'Password',
            handler: (str) => SignUpEvent.setPassword(str),
            error: errors[SignUpFormField.password]?.firstOrNull),
        buildFormField(context,
            title: 'Password Confirmation',
            handler: (str) => SignUpEvent.setPasswordConfirmation(str),
            error: errors[SignUpFormField.passwordConfirmation]?.firstOrNull)
      ],
    ));
  }

  Widget buildFormField(BuildContext context,
      {String? error,
      required SignUpEvent Function(String) handler,
      required String title}) {
    return Column(
      children: <Widget>[
        Text(title),
        TextField(
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintStyle: TextStyle(color: Colors.white70),
            hintText: 'Please enter your phone number',
            errorText: error,
          ),
          onChanged: (value) {
            BlocProvider.of<SignUpBloc>(context).add(handler(value));
          },
        ),
      ],
    );
  }
}

extension SafeList<E> on List<E> {
  E? get firstOrNull {
    return this.isEmpty ? null : this.first;
  }
}
