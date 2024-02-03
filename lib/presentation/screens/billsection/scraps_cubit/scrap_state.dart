part of 'scrap_cubit.dart';

sealed class ScrapState extends Equatable {
  const ScrapState({required this.scraps});
  final List<ScrapModel> scraps;

  @override
  List<Object> get props => [scraps];
}

final class ScrapInitial extends ScrapState {
  const ScrapInitial({super.scraps = const <ScrapModel>[]});
}

final class ScrapsLoaded extends ScrapState {
  const ScrapsLoaded({required super.scraps});
}
