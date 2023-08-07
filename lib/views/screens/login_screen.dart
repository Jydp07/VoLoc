import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/bloc/login/login_bloc.dart';
import '../../logic/cubit/internet/cubit/internet_cubit.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(),
          ),
          BlocProvider(
            create: (context) => InternetCubit(),
          ),
        ],
        child: const _UserLogIn(),
      ),
    );
  }
}

class _UserLogIn extends StatefulWidget {
  const _UserLogIn({Key? key}) : super(key: key);

  @override
  State<_UserLogIn> createState() => _UserLogInState();
}

class _UserLogInState extends State<_UserLogIn> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  // @override
  // void dispose() {
  //   _email.dispose();
  //   _password.dispose();
  //   super.dispose;
  // }

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;

    return BlocBuilder<InternetCubit, InternetState>(
      builder: (context, state) {
        if (state == InternetState.Lost) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Waiting for Internet',
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          );
        }
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: screensize.width * 0.31,
                      top: screensize.height * 0.1),
                  child: Image.asset(
                    'assets/img/login.png',
                    height: 170,
                    width: 170,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: screensize.width * 0.33,
                      top: screensize.height * 0.31),
                  child: Text('Welcome',
                      style: GoogleFonts.roboto(
                          color: Colors.grey.shade900,
                          fontSize: 30,
                          fontWeight: FontWeight.w500)),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: screensize.height * .4, right: 35, left: 35),
                    child: Column(
                      children: [
                        BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            String? error;
                            if (state is LoginEmailInvalidState) {
                              error = state.error;
                            }
                            return TextFormField(
                              controller: _email,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(width: 4),
                                  ),
                                  errorText: error,
                                  label: const Text('Email'),
                                  labelStyle:
                                      TextStyle(color: Colors.grey.shade700),
                                  hintText: "Enter the Email",
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: Colors.black26,
                                  )),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                BlocProvider.of<LoginBloc>(context).add(
                                    LoginFieldChangedEvent(
                                        email: _email.text,
                                        password: _password.text));
                              },
                            );
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            String? error;
                            bool visibility = true;
                            if (state is LoginPasswordInvalidState) {
                              error = state.error;
                            }
                            if (state is PassVisibilityState) {
                              visibility = state.isOn;
                            }
                            return TextFormField(
                              controller: _password,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(width: 4),
                                ),
                                errorText: error,
                                label: const Text('Password'),
                                labelStyle:
                                    TextStyle(color: Colors.grey.shade700),
                                hintText: "Enter the Password",
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: Colors.black26,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(visibility
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    visibility
                                        ? BlocProvider.of<LoginBloc>(context)
                                            .add(PassVisibilityFalseEvent())
                                        : BlocProvider.of<LoginBloc>(context)
                                            .add(PassVisibilityTrueEvent());
                                  },
                                ),
                              ),
                              obscureText: visibility,
                              onChanged: (value) {
                                BlocProvider.of<LoginBloc>(context).add(
                                    LoginFieldChangedEvent(
                                        email: _email.text,
                                        password: _password.text));
                              },
                            );
                          },
                        ),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Forgot Password?',
                                  style: GoogleFonts.roboto(
                                      color: Colors.black54, fontSize: 15),
                                ))
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(screensize.width * 0.01),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: BlocConsumer<LoginBloc, LoginState>(
                              listener: (context, state) {
                                if (state is LoginSubmitState) {
                                  Navigator.pushReplacementNamed(context, '/tab');
                                }else if (state is ErrorState) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(state.error)));
                                  }
                              },
                              builder: (context, state) {
                                return TextButton(onPressed: () async {
                                  if (state is LoginValidState) {
                                    BlocProvider.of<LoginBloc>(context).add(
                                        LoginSubmitEvent(
                                            email: _email.text,
                                            password: _password.text));
                                  }
                                }, child: BlocBuilder<LoginBloc, LoginState>(
                                  builder: (context, state) {
                                    if (state is LoginLoadingState) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return Text(
                                      'LOGIN',
                                      style: GoogleFonts.roboto(
                                          fontSize: 20,
                                          color: const Color(0xE2EAF5FF),
                                          fontWeight: FontWeight.w500),
                                    );
                                  },
                                ));
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Or Login with',
                              style: GoogleFonts.aBeeZee(
                                fontSize: 18,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        
                      },
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/google.png',
                              width: 35,
                              height: 35,
                            ),
                           const  SizedBox(width: 20,),
                            Image.asset(
                              'assets/icons/github.png',
                              width: 35,
                              height: 35,
                            ),
                            const  SizedBox(width: 20,),
                            Image.asset(
                              'assets/icons/linkedin.png',
                              width: 35,
                              height: 35,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          " Don't have an Account ? ",
                          style: GoogleFonts.aBeeZee(
                            fontSize: 18,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/signup');
                            },
                            child: Text(
                              'Sign up',
                              style: GoogleFonts.aBeeZee(
                                  decoration: TextDecoration.underline,
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  });
}
}