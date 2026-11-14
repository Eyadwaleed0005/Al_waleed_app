abstract interface class DeleteAccountRemoteDataSource {
  Future<void> deleteAccount({required String currentPassword});
}
