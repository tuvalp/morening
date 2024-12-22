abstract class AuthRepo {
  Future<String?> getUser();
  Future<void> login(String email, String password);
  Future<void> register(String email, String password, String name);
  Future<void> confirmUser(String confirmationCode, String email);
  Future<void> logout();
  Future<void> deleteUser();
}
