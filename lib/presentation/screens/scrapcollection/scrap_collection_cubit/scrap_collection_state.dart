part of 'scrap_collection_cubit.dart';

sealed class ScrapCollectionState extends Equatable {
  const ScrapCollectionState();

  @override
  List<Object> get props => [];
}

final class ScrapCollectionLoading extends ScrapCollectionState {
  const ScrapCollectionLoading();
}

final class ScrapCollectionLoaded extends ScrapCollectionState {
  const ScrapCollectionLoaded(this.collection);

  final Iterable<MyCollection> collection;

  @override
  List<Iterable<MyCollection>> get props => [collection];
}

final class ScrapCollectionError extends ScrapCollectionState {
  const ScrapCollectionError(this.message);
  final String message;

  @override
  List<String> get props => [message];
}
