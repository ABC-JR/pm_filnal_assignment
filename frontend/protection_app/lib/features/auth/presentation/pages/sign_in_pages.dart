
import 'package:first_video/core/theme/AppPallete.dart';
import 'package:first_video/features/auth/presentation/pages/sign_up_pages.dart';
import 'package:first_video/features/auth/presentation/widgets/my_button.dart';
import 'package:first_video/features/auth/presentation/widgets/my_texfield.dart';
import 'package:first_video/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:first_video/features/home/presentation/pages/homepage.dart';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SignInPages extends ConsumerStatefulWidget {
  const SignInPages({super.key});

  @override
  ConsumerState<SignInPages> createState() => _SignInPagesState();
}

class _SignInPagesState extends ConsumerState<SignInPages> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  var final_from_key = GlobalKey<FormState>();

  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    
  final isLoading = ref.watch(authViewmodelProvider.select((value) => value?.isLoading == true));




    ref.listen(
      authViewmodelProvider , 
      (_ , next){
       print("STATE TYPE: ${next.runtimeType}");

        // if(next == null) return Center(child: Text("Something went wrong"));

        next!.when(
          data: (data) {
            ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
               SnackBar(content: Text("Logged in successfully"))

             
            );
           
              Navigator.pushAndRemoveUntil(
                context,MaterialPageRoute(builder: (context) => Homepage()), (route) => false
               );
          },
          error:(error, stackTrace) {
              ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
               SnackBar(content: Text("${error.toString()}"))
            );
            
          },
          loading: () {
              Navigator.pushAndRemoveUntil(
                context,MaterialPageRoute(builder: (context) => Homepage()), (route) => false
               );
          }

        );
      }
    );



    return Scaffold(
      body: 
      isLoading == true ? const Center(child: CircularProgressIndicator()) :
      // final state = ref.watch(authViewmodelProvider);
      // final isLoading = state?.isLoading ?? false;
      Padding(
        padding: const EdgeInsets.all(15.0),

        child: Form(
          key: final_from_key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign In",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),

              MyTexfield(hinttext: "Email", textcontroller: emailcontroller),
              const SizedBox(height: 15),
              MyTexfield(
                hinttext: "Password",
                textcontroller: passwordcontroller,
                isobcured: true,
              ),
              const SizedBox(height: 20),
              MyButton(
                text: "Sign in",
                onTap: () async {
                  if (final_from_key.currentState!.validate()) {
                    await ref.read(authViewmodelProvider.notifier).singIn(
                      email: emailcontroller.text,
                      password: passwordcontroller.text,
                    );
                  }else{
                    SnackBar(content: Text("missing values"),);
                  }
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPages()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: Theme.of(context).textTheme.bodyMedium,

                    children: [
                      TextSpan(
                        text: "Sign up",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppPallete.gradient2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
