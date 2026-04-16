
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

// 1. Audio Handler Class: Ye notification aur playback ko handle karegi
class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();

  MyAudioHandler() {
    // Media Item details set karna (Notification me dikhne ke liye)
    final item = MediaItem(
      id: 'https://example.com/song.mp3', // Yaha apna audio link dalein
      album: "Passion Pit",
      title: "Carried Away",
      artist: "Passion Pit",
      artUri: Uri.parse('https://example.com/album_art.jpg'), // Pink background image link
    );
    mediaItem.add(item);
    
    // Player state ko notification se sync karna
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() async {
    // Implement logic
  }

  @override
  Future<void> skipToPrevious() async {
    // Implement logic
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    // Shuffle logic yaha aayegi
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
