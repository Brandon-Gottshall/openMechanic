import 'package:firedart/firedart.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:mechanic/config/env.dart';

class AuthService {
  FirebaseAuth.initialize(Secret.api_key, );
  await FirebaseAuth.instance.signIn(email, password);

  var user = await FirebaseAuth.instance.getUser();

  Future<> initalize() async {
    FirebaseAuth.initialize(Secret.api_key, await firebaseTokenStore.create());
    await FirebaseAuth.instance.signIn(email, password);
    var user = await FirebaseAuth.instance.getUser();
    return user;
  }
  Future<User> login(email, password) async {
    return await FirebaseAuth.instance.signIn(email, password);
  }
}
