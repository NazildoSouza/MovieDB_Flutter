part of 'episodeimages_bloc.dart';

abstract class EpisodeimagesState extends Equatable {
  const EpisodeimagesState();

  @override
  List<Object> get props => [];
}

class EpisodeImagesLoading extends EpisodeimagesState {}

class EpisodeImagesError extends EpisodeimagesState {
  final String message;
  const EpisodeImagesError(this.message);

  @override
  String toString() {
    return '''EpisodeImagesError { error: $message }''';
  }

  @override
  List<Object> get props => [message];
}

class EpisodeImagesLoaded extends EpisodeimagesState {
  const EpisodeImagesLoaded(this.containImages);
  final bool containImages;

  @override
  String toString() {
    return '''EpisodeImagesLoaded { containImages: $containImages }''';
  }

  @override
  List<Object> get props => [containImages];
}
