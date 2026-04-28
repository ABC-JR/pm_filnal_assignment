import 'package:first_video/core/theme/AppPallete.dart';

import 'package:first_video/features/auth/presentation/widgets/my_button.dart';
import 'package:first_video/features/auth/presentation/widgets/my_texfield.dart';
import 'package:first_video/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SignUpPages extends ConsumerStatefulWidget {
  const SignUpPages({super.key});

  @override
  ConsumerState<SignUpPages> createState() => _SignUpPagesState();
}

class _SignUpPagesState extends ConsumerState<SignUpPages> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final namecontroller = TextEditingController();

  var final_from_key = GlobalKey<FormState>();

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    namecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewmodelProvider.select((value) => value?.isLoading == true));


    ref.listen(authViewmodelProvider, 
    (_ , next){
      next!.when(data: (data){
        ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
           SnackBar(content: Text("Account created successfully"))
        );
      }, error: (error , st){
          ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
           SnackBar(content: Text("Error : $error"))
        );

      }, loading: () {

      });
    });



    return Scaffold(
      appBar: AppBar(),
      body:
      isLoading ? const Center(child: CircularProgressIndicator()) :

      
       Padding(
        padding: const EdgeInsets.all(15.0),
        child: 
            Form(
              key: final_from_key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "SignUp.",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),

                  MyTexfield(hinttext: "Name", textcontroller: namecontroller),
                  const SizedBox(height: 15),
                  MyTexfield(
                    hinttext: "Email",
                    textcontroller: emailcontroller,
                  ),
                  const SizedBox(height: 15),
                  MyTexfield(
                    hinttext: "Password",
                    textcontroller: passwordcontroller,
                    isobcured: true,
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    onTap: () async {
                       if (final_from_key.currentState!.validate()) {
                        await ref.read(authViewmodelProvider.notifier).singUp(
                          email: emailcontroller.text,
                          password: passwordcontroller.text,
                          name: namecontroller.text
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium,

                        children: [
                          TextSpan(
                            text: "Sign in",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
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
            )
  
      ),
    );
  }
}
