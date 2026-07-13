//
//  AudioPlayerManager.swift
//  iosApp5
//
//  Created by Zubia Tahseen on 2026-07-12.
//
//  Manages audio playback using AVFoundation's AVPlayer.
//  Provides play/pause, seek, skip, and volume controls.
//  Uses the @Observable macro for SwiftUI integration.
//

import AVFoundation
import SwiftUI

// MARK: - Audio Player Manager

/// Observable class that wraps AVPlayer to manage audio playback
/// throughout the app. Passed via SwiftUI environment.
@Observable
class AudioPlayerManager {

    // MARK: - Published Properties

    /// The currently loaded sound track
    var currentSound: Sound?

    /// Whether audio is currently playing
    var isPlaying = false

    /// Current playback position in seconds
    var currentTime: TimeInterval = 0

    /// Total duration of the current track in seconds
    var totalDuration: TimeInterval = 0

    /// Playback volume (0.0 to 1.0)
    var volume: Float = 0.7 {
        didSet { player?.volume = volume }
    }

    /// All available sounds — mutable to support favoriting
    var sounds: [Sound] = Sound.sampleSounds

    // MARK: - Private Properties

    /// The underlying AVPlayer instance
    private var player: AVPlayer?

    /// Token for the periodic time observer
    private var timeObserver: Any?

    // MARK: - Playback Controls

    /// Loads and plays a given sound track
    /// - Parameter sound: The Sound to begin playing
    func play(_ sound: Sound) {
        // Stop any current playback first
        stop()

        currentSound = sound

        guard let url = sound.audioURL else { return }

        // Create a new player item and player
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.volume = volume

        // Observe playback time every 0.5 seconds to update the UI
        timeObserver = player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            guard let self else { return }
            self.currentTime = time.seconds

            // Update total duration once it becomes available
            if let duration = self.player?.currentItem?.duration.seconds,
               !duration.isNaN {
                self.totalDuration = duration
            }
        }

        player?.play()
        isPlaying = true
    }

    /// Toggles between play and pause states
    func togglePlayPause() {
        guard player != nil else { return }

        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying.toggle()
    }

    /// Stops playback and resets the player state
    func stop() {
        // Remove the time observer to prevent memory leaks
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        player?.pause()
        player = nil
        isPlaying = false
        currentTime = 0
        totalDuration = 0
    }

    /// Seeks to a specific time position in the track
    /// - Parameter time: The target time in seconds
    func seek(to time: TimeInterval) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player?.seek(to: cmTime)
    }

    /// Skips forward 15 seconds in the current track
    func skipForward() {
        let newTime = min(currentTime + 15, totalDuration)
        seek(to: newTime)
    }

    /// Skips backward 15 seconds in the current track
    func skipBackward() {
        let newTime = max(currentTime - 15, 0)
        seek(to: newTime)
    }

    /// Toggles the favorite status of a sound
    /// - Parameter sound: The sound to toggle favorite on
    func toggleFavorite(_ sound: Sound) {
        if let index = sounds.firstIndex(where: { $0.id == sound.id }) {
            sounds[index].isFavorite.toggle()
        }
    }

    /// Plays the next sound in the list after the current one
    func playNext() {
        guard let current = currentSound,
              let currentIndex = sounds.firstIndex(where: { $0.id == current.id }) else { return }

        let nextIndex = (currentIndex + 1) % sounds.count
        play(sounds[nextIndex])
    }

    /// Plays the previous sound in the list before the current one
    func playPrevious() {
        guard let current = currentSound,
              let currentIndex = sounds.firstIndex(where: { $0.id == current.id }) else { return }

        let previousIndex = (currentIndex - 1 + sounds.count) % sounds.count
        play(sounds[previousIndex])
    }
}
