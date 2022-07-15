class Resource<T> {
  final T? data;
  final String? error;

  Resource._({
    this.data,
    this.error,
  });

  factory Resource.success(T data) {
    return Resource._(
      data: data,
    );
  }

  factory Resource.error(String error) {
    return Resource._(
      error: error,
    );
  }

  Future<void> result({
    required Function(T) onSuccess,
    required Function(String) onError,
  }) async {
    if (data != null) {
      await onSuccess(data as T);
    } else if (error != null) {
      await onError(error!);
    }
  }
}
