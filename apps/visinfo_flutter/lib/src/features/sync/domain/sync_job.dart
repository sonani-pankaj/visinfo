enum SyncJobType {
  uploadPhoto,
  upsertMetadata,
  upsertTag,
  upsertCollection,
}

enum SyncJobStatus {
  queued,
  running,
  failed,
  completed,
}

class SyncJob {
  const SyncJob({
    required this.id,
    required this.type,
    required this.status,
    required this.payload,
    this.retryCount = 0,
    this.lastError,
  });

  final String id;
  final SyncJobType type;
  final SyncJobStatus status;
  final Map<String, Object?> payload;
  final int retryCount;
  final String? lastError;
}
