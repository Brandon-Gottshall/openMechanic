import 'package:firedart/firedart.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:mechanic/config/env.dart';
import 'package:mechanic/services/token_store.dart';

class AuthService {
  FirebaseAuth.initialize(Secret.api_key, await FirebaseTokenStore.create());

  Future<User> login(email, password) async {
    return await FirebaseAuth.instance.signIn(email, password);
  }

  Future<User> getUserObject() async {
    User user = await FirebaseAuth.instance.getUser();
    return user;
  }

}
