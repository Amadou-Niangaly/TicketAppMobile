import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

   LoginPage({super.key});

  final emailController = TextEditingController();
  final passworController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          margin: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputFiel(context)
            ],
          ),
        ),
      ),
    );
  }
   _header(context){
    return const Column(
      children: [
        Center(
          child: Text("Bienvenu",
          style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
        )
      ],
    );
   }
   _inputFiel(context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: "Username",
            border: OutlineInputBorder(
              borderRadius:BorderRadius.circular(12),
              borderSide: BorderSide.none
               ),
               fillColor: Theme.of(context).hintColor.withOpacity(0.1),
               filled: true,
               prefixIcon: const Icon(Icons.person)

          ),
        ),
        const SizedBox(height: 16,),
         TextField(
          controller: passworController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius:BorderRadius.circular(12),
              borderSide: BorderSide.none
               ),
               fillColor: Theme.of(context).hintColor.withOpacity(0.1),
               filled: true,
               prefixIcon: const Icon(Icons.password_sharp)

          ),
          obscureText: true,
        ),
        const SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _forgotPasswor(context),
          ],
        ),
        const SizedBox(height: 16,),
        ElevatedButton(
          onPressed: (){
            if(emailController.text.isNotEmpty && passworController.text.length>4){
              login();
            }
          },
        
           // ignore: sort_child_properties_last
           child: const Text(
            "Login",
            style: TextStyle(fontSize: 20,color: Colors.white),
           ),
           style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Theme.of(context).hintColor
           ),
           
           )
      ],
    );
   }
   _forgotPasswor(context){
    return TextButton(
      onPressed: (){}, 
      child: const Text("Forgot password?")
      );
   }
   Future<void> login() async{
    final auth=FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(email: emailController.text, password: passworController.text);
   }

}