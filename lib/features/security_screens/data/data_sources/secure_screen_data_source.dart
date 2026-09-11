abstract interface class SecureScreenDataSource {
  Future<void> enableProtection();

  Future<void> disableProtection();
}