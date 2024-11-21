import '../domain/models/plan.dart';
import '../domain/models/stage.dart';

final List<Plan> plansMookup = [
  Plan(
    label: 'default',
    startDeltaBeforeAwake: 25,
    stages: [
      Stage(deltaTime: 0, trigger: 'smell', volume: 10, duration: 600),
      Stage(deltaTime: 10, trigger: 'ACTIVE_LIGHT', volume: 10, duration: 300),
      Stage(
          deltaTime: 5,
          trigger: 'SPEAKER',
          volume: 0.5,
          duration: 10,
          songPath: 'assets/sounds/file_example_WAV_1MG.wav'),
      Stage(deltaTime: 5, trigger: 'ACTIVE_LIGHT', volume: 10, duration: 360),
      Stage(deltaTime: 5, trigger: 'smell', volume: 10, duration: 180),
      Stage(
          deltaTime: 0,
          trigger: 'SPEAKER',
          volume: 0.9,
          duration: 20,
          songPath: 'assets/sounds/acoustic-guitar-dream.mp3'),
      Stage(deltaTime: 0, trigger: 'ACTIVE_LIGHT', volume: 10, duration: 60),
    ],
  ),
  Plan(
    label: 'short_wakeup',
    startDeltaBeforeAwake: 10,
    stages: [
      Stage(deltaTime: 0, trigger: 'smell', volume: 10, duration: 30),
      Stage(deltaTime: 1, trigger: 'ACTIVE_LIGHT', volume: 10, duration: 60),
      Stage(
          deltaTime: 2,
          trigger: 'SPEAKER',
          volume: 0.2,
          duration: 10,
          songPath: 'assets/sounds/Music_wo_lyrics.mp3'),
      Stage(deltaTime: 1, trigger: 'smell', volume: 10, duration: 60),
      Stage(deltaTime: 1, trigger: 'ACTIVE_LIGHT', volume: 10, duration: 120),
      Stage(
          deltaTime: 1,
          trigger: 'SPEAKER',
          volume: 0.3,
          duration: 30,
          songPath: 'assets/sounds/Music_wo_lyrics.mp3'),
      Stage(deltaTime: 2, trigger: 'smell', volume: 10, duration: 120),
      Stage(deltaTime: 1, trigger: 'ACTIVE_LIGHT', volume: 10, duration: 180),
      Stage(
          deltaTime: 0,
          trigger: 'SPEAKER',
          volume: 0.6,
          duration: 30,
          songPath: 'assets/sounds/Music_with_lyrics.mp3'),
      Stage(
          deltaTime: 1,
          trigger: 'SPEAKER',
          volume: 0.9,
          duration: 30,
          songPath: 'assets/sounds/Music_with_lyrics.mp3'),
      Stage(deltaTime: 0, trigger: 'smell', volume: 10, duration: 120),
    ],
  ),
  Plan(
    label: 'moderate_wakeup',
    startDeltaBeforeAwake: 20,
    stages: [
      Stage(deltaTime: 0, trigger: 'smell', volume: 10, duration: 60),
      Stage(deltaTime: 1, trigger: 'ACTIVE_LIGHT', volume: 10, duration: 120),
      Stage(
          deltaTime: 5,
          trigger: 'SPEAKER',
          volume: 0.2,
          duration: 20,
          songPath: 'assets/sounds/Music_wo_lyrics.mp3'),
      Stage(deltaTime: 2, trigger: 'smell', volume: 10, duration: 120),
      Stage(deltaTime: 1, trigger: 'ACTIVE_LIGHT', volume: 10, duration: 180),
      Stage(
          deltaTime: 3,
          trigger: 'SPEAKER',
          volume: 0.4,
          duration: 30,
          songPath: 'assets/sounds/Music_wo_lyrics.mp3'),
      Stage(deltaTime: 5, trigger: 'smell', volume: 10, duration: 60),
      Stage(deltaTime: 1, trigger: 'ACTIVE_LIGHT', volume: 10, duration: 240),
      Stage(
          deltaTime: 2,
          trigger: 'SPEAKER',
          volume: 0.6,
          duration: 45,
          songPath: 'assets/sounds/Music_with_lyrics.mp3'),
    ],
  ),
  // Continue defining each plan similarly for 'middle_awakening', 'easy_and_long_awakening', 'hard_awakening', 'snooz', and 'test-device' as needed...
];
