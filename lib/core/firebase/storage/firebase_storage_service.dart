import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:typed_data';

import 'package:al_waleed/core/connection/network/network_info.dart';
import 'package:al_waleed/core/firebase/storage/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageService implements StorageService {
  FirebaseStorageService({
    required NetworkInfo networkInfo,
    FirebaseStorage? firebaseStorage,
    this.enableLogging = kDebugMode,
    this.logRequestData = true,
    this.logResponseData = true,
  }) : _networkInfo = networkInfo,
       _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  final FirebaseStorage _firebaseStorage;
  final NetworkInfo _networkInfo;

  final bool enableLogging;
  final bool logRequestData;
  final bool logResponseData;

  @override
  Future<FullMetadata> uploadFile({
    required String localFilePath,
    required String storagePath,
    required String contentType,
    Map<String, String>? customMetadata,
    StorageProgressCallback? onProgress,
  }) {
    final normalizedStoragePath = _normalizeStoragePath(storagePath);
    final normalizedLocalFilePath = localFilePath.trim();

    return _execute(
      operation: 'UPLOAD FILE',
      path: normalizedStoragePath,
      requestData: {
        'contentType': contentType,
        'customMetadata': customMetadata,
      },
      action: () async {
        await _requireInternetConnection();

        if (normalizedLocalFilePath.isEmpty) {
          throw FirebaseException(
            plugin: 'firebase_storage',
            code: 'invalid-local-file-path',
            message: 'The local file path cannot be empty.',
          );
        }

        final localFile = File(normalizedLocalFilePath);
        final fileExists = await localFile.exists();

        if (!fileExists) {
          throw FirebaseException(
            plugin: 'firebase_storage',
            code: 'local-file-not-found',
            message: 'The selected local file could not be found.',
          );
        }

        final reference = _firebaseStorage.ref().child(normalizedStoragePath);

        final metadata = SettableMetadata(
          contentType: contentType,
          customMetadata: customMetadata,
        );

        final uploadTask = reference.putFile(localFile, metadata);

        StreamSubscription<TaskSnapshot>? progressSubscription;

        if (onProgress != null) {
          onProgress(0);

          progressSubscription = uploadTask.snapshotEvents.listen((snapshot) {
            final totalBytes = snapshot.totalBytes;

            if (totalBytes <= 0) return;

            final progress = snapshot.bytesTransferred / totalBytes;

            onProgress(progress.clamp(0.0, 1.0));
          });
        }

        try {
          final snapshot = await uploadTask;

          onProgress?.call(1);

          final uploadedMetadata = snapshot.metadata;

          if (uploadedMetadata != null) {
            return uploadedMetadata;
          }

          return await reference.getMetadata();
        } finally {
          await progressSubscription?.cancel();
        }
      },
    );
  }

  @override
  Future<Uint8List> getFileData({
    required String storagePath,
    required int maxSize,
  }) {
    final normalizedStoragePath = _normalizeStoragePath(storagePath);

    return _execute(
      operation: 'GET FILE DATA',
      path: normalizedStoragePath,
      requestData: {'maxSize': maxSize},
      action: () async {
        await _requireInternetConnection();

        if (maxSize <= 0) {
          throw FirebaseException(
            plugin: 'firebase_storage',
            code: 'invalid-max-size',
            message: 'The maximum download size must be greater than zero.',
          );
        }

        final reference = _firebaseStorage.ref().child(normalizedStoragePath);

        final fileData = await reference.getData(maxSize);

        if (fileData == null) {
          throw FirebaseException(
            plugin: 'firebase_storage',
            code: 'download-failed',
            message: 'The file data could not be downloaded.',
          );
        }

        return fileData;
      },
    );
  }

  @override
  Future<FullMetadata> getFileMetadata({required String storagePath}) {
    final normalizedStoragePath = _normalizeStoragePath(storagePath);

    return _execute(
      operation: 'GET FILE METADATA',
      path: normalizedStoragePath,
      action: () async {
        await _requireInternetConnection();

        return _firebaseStorage
            .ref()
            .child(normalizedStoragePath)
            .getMetadata();
      },
    );
  }

  @override
  Future<void> deleteFile({required String storagePath}) {
    final normalizedStoragePath = _normalizeStoragePath(storagePath);

    return _execute(
      operation: 'DELETE FILE',
      path: normalizedStoragePath,
      action: () async {
        await _requireInternetConnection();

        final reference = _firebaseStorage.ref().child(normalizedStoragePath);

        try {
          await reference.delete();
        } on FirebaseException catch (error) {
          if (error.code == 'object-not-found') {
            return;
          }

          rethrow;
        }
      },
    );
  }

  @override
  Future<String> getDownloadUrl({required String storagePath}) {
    final normalizedStoragePath = _normalizeStoragePath(storagePath);

    return _execute(
      operation: 'GET DOWNLOAD URL',
      path: normalizedStoragePath,
      action: () async {
        await _requireInternetConnection();

        return _firebaseStorage
            .ref()
            .child(normalizedStoragePath)
            .getDownloadURL();
      },
    );
  }

  Future<void> _requireInternetConnection() async {
    bool isConnected;

    try {
      isConnected = await _networkInfo.isConnected;
    } catch (_) {
      isConnected = false;
    }

    if (isConnected) return;

    throw FirebaseException(
      plugin: 'firebase_storage',
      code: 'no-internet',
      message: 'No internet connection is currently available.',
    );
  }

  String _normalizeStoragePath(String storagePath) {
    var normalizedPath = storagePath.trim();

    while (normalizedPath.startsWith('/')) {
      normalizedPath = normalizedPath.substring(1);
    }

    if (normalizedPath.isEmpty) {
      throw FirebaseException(
        plugin: 'firebase_storage',
        code: 'invalid-storage-path',
        message: 'The Firebase Storage path cannot be empty.',
      );
    }

    return normalizedPath;
  }

  Future<T> _execute<T>({
    required String operation,
    required String path,
    required Future<T> Function() action,
    Object? requestData,
  }) async {
    _logRequest(operation: operation, path: path, data: requestData);

    final stopwatch = Stopwatch()..start();

    try {
      final result = await action();

      stopwatch.stop();

      _logResponse(
        operation: operation,
        path: path,
        response: result,
        duration: stopwatch.elapsed,
      );

      return result;
    } catch (error, stackTrace) {
      stopwatch.stop();

      _logError(
        operation: operation,
        path: path,
        error: error,
        stackTrace: stackTrace,
        duration: stopwatch.elapsed,
      );

      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  void _logRequest({
    required String operation,
    required String path,
    Object? data,
  }) {
    if (!_canLog) return;

    final buffer = StringBuffer()
      ..writeln('┌───────────── STORAGE REQUEST ─────────────')
      ..writeln('│ Operation: $operation')
      ..writeln('│ Path: $path');

    if (logRequestData && data != null) {
      buffer
        ..writeln('│ Data:')
        ..writeln(_addLinePrefix(_prettyPrint(data)));
    }

    buffer.writeln('└──────────────────────────────────────────');

    developer.log(buffer.toString(), name: 'FirebaseStorageService');
  }

  void _logResponse({
    required String operation,
    required String path,
    Object? response,
    Duration? duration,
  }) {
    if (!_canLog) return;

    final buffer = StringBuffer()
      ..writeln('┌──────────── STORAGE RESPONSE ─────────────')
      ..writeln('│ Operation: $operation')
      ..writeln('│ Path: $path');

    if (duration != null) {
      buffer.writeln('│ Duration: ${duration.inMilliseconds} ms');
    }

    if (logResponseData) {
      buffer
        ..writeln('│ Data:')
        ..writeln(_addLinePrefix(_prettyPrint(_formatResponse(response))));
    }

    buffer.writeln('└──────────────────────────────────────────');

    developer.log(buffer.toString(), name: 'FirebaseStorageService');
  }

  void _logError({
    required String operation,
    required String path,
    required Object error,
    required StackTrace stackTrace,
    Duration? duration,
  }) {
    if (!_canLog) return;

    final buffer = StringBuffer()
      ..writeln('┌───────────── STORAGE ERROR ───────────────')
      ..writeln('│ Operation: $operation')
      ..writeln('│ Path: $path');

    if (duration != null) {
      buffer.writeln('│ Duration: ${duration.inMilliseconds} ms');
    }

    buffer
      ..writeln('│ Error: $error')
      ..writeln('└──────────────────────────────────────────');

    developer.log(
      buffer.toString(),
      name: 'FirebaseStorageService',
      error: error,
      stackTrace: stackTrace,
    );
  }

  Object? _formatResponse(Object? response) {
    if (response == null) {
      return {'status': 'success'};
    }

    if (response is Uint8List) {
      return {'status': 'success', 'downloadedBytes': response.lengthInBytes};
    }

    if (response is FullMetadata) {
      return {
        'status': 'success',
        'bucket': response.bucket,
        'fullPath': response.fullPath,
        'name': response.name,
        'size': response.size,
        'contentType': response.contentType,
        'timeCreated': response.timeCreated?.toIso8601String(),
        'updated': response.updated?.toIso8601String(),
        'customMetadata': response.customMetadata,
      };
    }

    return response;
  }

  String _prettyPrint(Object? value) {
    try {
      return const JsonEncoder.withIndent(
        '  ',
      ).convert(_convertToLoggableValue(value));
    } catch (_) {
      return value.toString();
    }
  }

  Object? _convertToLoggableValue(Object? value) {
    if (value == null || value is String || value is num || value is bool) {
      return value;
    }

    if (value is DateTime) {
      return value.toIso8601String();
    }

    if (value is Uint8List) {
      return {'type': 'Uint8List', 'lengthInBytes': value.lengthInBytes};
    }

    if (value is Map) {
      return value.map((key, item) {
        return MapEntry(key.toString(), _convertToLoggableValue(item));
      });
    }

    if (value is Iterable) {
      return value.map(_convertToLoggableValue).toList();
    }

    return value.toString();
  }

  String _addLinePrefix(String value) {
    return value.split('\n').map((line) => '│ $line').join('\n');
  }

  bool get _canLog {
    return enableLogging && kDebugMode;
  }
}
