import 'package:flutter/material.dart';
import 'package:mb_dlk/screens/login_page.dart';
import '../components/signup_form.dart';

class SignupPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _MyAppBar(),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SignupForm(),
            ),
          ),
        ],
      ),
    );
  }

}

class _MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.blue,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),  
          );
        },
      ),
      centerTitle: true,
      title: Text('Sign up', style: Theme.of(context).textTheme.displayMedium),
      floating: true,
    );
  }
}
