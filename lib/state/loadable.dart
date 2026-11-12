import '../data/api/api_exception.dart';

enum LoadStatus { idle, loading, success, failure }

/// Simple immutable async value used by the screens.
class Loadable<T> {
  const Loadable._(this.status, this.data, this.error);

  const Loadable.idle() : this._(LoadStatus.idle, null, null);
  const Loadable.loading() : this._(LoadStatus.loading, null, null);
  const Loadable.success(T data) : this._(LoadStatus.success, data, null);
  const Loadable.failure(ApiException error) : this._(LoadStatus.failure, null, error);

  final LoadStatus status;
  final T? data;
  final ApiException? error;

  bool get isLoading => status == LoadStatus.loading;
  bool get isSuccess => status == LoadStatus.success;
  bool get isFailure => status == LoadStatus.failure;
}
