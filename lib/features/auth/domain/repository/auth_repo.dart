abstract class AuthRepo {
  Future<String> getUser();
  Future<void> login(String email, String password);
  Future<void> register(String email, String password);
  Future<void> logout();
}
