enum AuthMethod {
  google("google"),
  github("github");

  final String value;

  const AuthMethod(this.value);
}