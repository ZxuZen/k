import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_steps_tracker/auth_service.dart';
import 'package:flutter_steps_tracker/di/injection_container.dart';
import 'package:flutter_steps_tracker/features/bottom_navbar/presentation/manager/home/home_cubit.dart';
import 'package:flutter_steps_tracker/features/bottom_navbar/presentation/pages/bottom_navbar.dart';
import 'package:flutter_steps_tracker/features/bottom_navbar/presentation/pages/home_page.dart';
import 'package:flutter_steps_tracker/features/intro/domain/use_cases/sign_in_anonymously_use_case.dart';
import 'package:flutter_steps_tracker/features/intro/presentation/manager/auth_actions/auth_cubit.dart';
import 'package:flutter_steps_tracker/features/intro/presentation/manager/auth_actions/auth_state.dart';
import 'package:flutter_steps_tracker/features/intro/presentation/manager/auth_status/auth_status_cubit.dart';
import 'package:flutter_steps_tracker/generated/l10n.dart';
import 'package:flutter_steps_tracker/utilities/constants/assets.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // static Future<User?> loginUsingEmailPassword(
  //     {required String email,
  //     required String password,
  //     required BuildContext context}) async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? user;

  //   try {
  //     UserCredential userCredential = await auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     user = userCredential.user;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == "user-not-found") {
  //       print("No User Found that email");
  //     }
  //   }
  //   return user;
  // }
  static Future<User?> signInAnonymouslyUseCase(
      {
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
    UserCredential userCredential = await auth.signInAnonymously();
      User? user = userCredential.user;
      user = userCredential.user;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BottomNavbar()));
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No User Found that email");
      }
    }
    return user;
  }
  // Declare _buildColumn method here
  Widget _buildColumn(bool isLoading, BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Spacer(
            flex: 1,
          ),
          CachedNetworkImage(
            imageUrl: AppAssets.logo,
            fit: BoxFit.cover,
            color: Theme.of(context).scaffoldBackgroundColor,
            height: 180,
          ),
          Text(
            S.of(context).allInOneTrack,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
          ),
          const Spacer(
            flex: 2,
          ),
          TextFormField(
            controller: _nameController,
            validator: (val) =>
                val!.isEmpty ? S.of(context).enterYourName : null,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: S.of(context).enterYourName,
            ),
          ),
   
          const SizedBox(height: 16.0),
          InkWell(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                await BlocProvider.of<AuthCubit>(context).signInAnonymously(
                  name: _nameController.text,
                );
              }
            },
            child: GestureDetector(
              // onTap: () async {
              //   User? user = await AuthServices.signInAnonymously(
              //       context); // Perhatikan penggunaan "context" di sini

              //   if (user != null) {
              //     // Pendaftaran berhasil, alihkan ke halaman HomePage
              //     Navigator.of(context).pushReplacement(
              //       MaterialPageRoute(builder: (context) => HomePage()),
              //     );
              //   }
              // },
              onTap: () async {
                User? user = await signInAnonymouslyUseCase(context: context);
                print(user);
                if(user !=null){
                  Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => BottomNavbar()));
                }else{

                }
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Center(
                  child: !isLoading
                      ? Text(
                          S.of(context).startUsingSteps,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                fontWeight: FontWeight.bold,
                              ),
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return BlocProvider<AuthCubit>(
                create: (context) => getIt<AuthCubit>(),
                child: Builder(
                  builder: (context) {
                    return Scaffold(
                      resizeToAvoidBottomInset: true,
                      body: Stack(
                        children: [
                          Image.asset(
                            AppAssets.manInBackgroundIntro,
                            fit: BoxFit.cover,
                            height: double.infinity,
                            width: double.infinity,
                          ),
                          SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: Opacity(
                              opacity: 0.8,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 48.0,
                              ),
                              child: Center(
                                child: BlocConsumer<AuthCubit, AuthState>(
                                  listener: (context, state) {
                                    state.maybeWhen(
                                        loggedIn: () {
                                          final cubit =
                                              BlocProvider.of<AuthStatusCubit>(
                                                  context);
                                          cubit.checkAuthStatus();
                                          // Navigator.of(context).pop();
                                        },
                                        error: (message) {},
                                        orElse: () {});
                                  },
                                  builder: (context, state) {
                                    return state.maybeWhen(
                                      loading: () =>
                                          _buildColumn(true, context),
                                      orElse: () =>
                                          _buildColumn(false, context),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            return CircularProgressIndicator();
          }),
    );
  }
}
