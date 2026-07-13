//
//  NowPlayingView.swift
//  iosApp5
//
//  Created by Zubia Tahseen on 2026-07-12.
//
//  Full-screen Now Playing view — displays album art, playback controls,
//  a seek slider, volume control, and track navigation buttons.
//  Presented as a sheet from the mini player bar.
//

import SwiftUI

// MARK: - Now Playing View

/// Full-screen media player view with artwork, controls, and seek bar
struct NowPlayingView: View {
    /// Access the shared audio player from the environment
    @Environment(AudioPlayerManager.self) private var playerManager

    /// Dismiss action to close the sheet
    @Environment(\.dismiss) private var dismiss

    /// Tracks the drag position on the seek slider
    @State private var isDragging = false

    /// Animates the album art rotation
    @State private var artworkRotation: Double = 0

    var body: some View {
        // Use @Bindable to create bindings from the @Observable player manager
        @Bindable var player = playerManager

        VStack(spacing: 0) {
            // Drag handle indicator at the top
            dragHandle

            Spacer()

            // Large album artwork display
            artworkSection

            Spacer()

            // Track title and artist information
            trackInfoSection

            // Seek/progress slider
            seekSlider

            // Main playback controls (previous, play/pause, next)
            playbackControls

            // Volume slider control
            volumeSlider(volume: $player.volume)

            Spacer()
        }
        .padding(.horizontal, 30)
        .background(
            // Dynamic gradient background based on the current track's color
            LinearGradient(
                colors: [
                    (playerManager.currentSound?.accentColor ?? .blue).opacity(0.3),
                    .black.opacity(0.8)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }

    // MARK: - Drag Handle

    /// Small gray bar at the top indicating the view can be dismissed by dragging
    private var dragHandle: some View {
        Capsule()
            .fill(.secondary)
            .frame(width: 40, height: 5)
            .padding(.top, 12)
    }

    // MARK: - Artwork Section

    /// Large circular artwork display with the track's SF Symbol icon
    private var artworkSection: some View {
        ZStack {
            // Outer glowing circle
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            (playerManager.currentSound?.accentColor ?? .blue).opacity(0.6),
                            (playerManager.currentSound?.accentColor ?? .blue).opacity(0.1)
                        ],
                        center: .center,
                        startRadius: 60,
                        endRadius: 140
                    )
                )
                .frame(width: 280, height: 280)

            // Inner artwork circle with icon
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            playerManager.currentSound?.accentColor ?? .blue,
                            (playerManager.currentSound?.accentColor ?? .blue).opacity(0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 220, height: 220)
                .shadow(color: (playerManager.currentSound?.accentColor ?? .blue).opacity(0.5), radius: 20)

            // Track icon displayed prominently
            Image(systemName: playerManager.currentSound?.iconName ?? "music.note")
                .font(.system(size: 80))
                .foregroundStyle(.white)
                .rotationEffect(.degrees(artworkRotation))
        }
        // Subtle pulsing animation when playing
        .scaleEffect(playerManager.isPlaying ? 1.0 : 0.9)
        .animation(.easeInOut(duration: 0.5), value: playerManager.isPlaying)
    }

    // MARK: - Track Info Section

    /// Displays the current track's title and artist name
    private var trackInfoSection: some View {
        VStack(spacing: 6) {
            Text(playerManager.currentSound?.title ?? "Not Playing")
                .font(.title2.bold())
                .foregroundStyle(.primary)
                .lineLimit(1)

            Text(playerManager.currentSound?.artist ?? "—")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 24)
        .padding(.bottom, 20)
    }

    // MARK: - Seek Slider

    /// Slider showing playback progress with time labels
    private var seekSlider: some View {
        VStack(spacing: 4) {
            // Progress slider
            Slider(
                value: Binding(
                    get: { playerManager.currentTime },
                    set: { newValue in
                        playerManager.seek(to: newValue)
                    }
                ),
                in: 0...max(playerManager.totalDuration, 1)
            )
            .tint(playerManager.currentSound?.accentColor ?? .blue)

            // Time labels: current time on left, remaining on right
            HStack {
                Text(formatTime(playerManager.currentTime))
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Spacer()

                Text("-\(formatTime(max(0, playerManager.totalDuration - playerManager.currentTime)))")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.bottom, 16)
    }

    // MARK: - Playback Controls

    /// Main transport controls: previous, backward skip, play/pause, forward skip, next
    private var playbackControls: some View {
        HStack(spacing: 36) {
            // Previous track button
            Button { playerManager.playPrevious() } label: {
                Image(systemName: "backward.fill")
                    .font(.title2)
                    .foregroundStyle(.primary)
            }

            // Skip backward 15 seconds
            Button { playerManager.skipBackward() } label: {
                Image(systemName: "gobackward.15")
                    .font(.title2)
                    .foregroundStyle(.primary)
            }

            // Play/Pause toggle (large centered button)
            Button { playerManager.togglePlayPause() } label: {
                Image(systemName: playerManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(playerManager.currentSound?.accentColor ?? .blue)
            }

            // Skip forward 15 seconds
            Button { playerManager.skipForward() } label: {
                Image(systemName: "goforward.15")
                    .font(.title2)
                    .foregroundStyle(.primary)
            }

            // Next track button
            Button { playerManager.playNext() } label: {
                Image(systemName: "forward.fill")
                    .font(.title2)
                    .foregroundStyle(.primary)
            }
        }
        .padding(.bottom, 24)
    }

    // MARK: - Volume Slider

    /// Volume control slider with speaker icons
    private func volumeSlider(volume: Binding<Float>) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "speaker.fill")
                .font(.caption)
                .foregroundStyle(.secondary)

            Slider(value: volume, in: 0...1)
                .tint(.secondary)

            Image(systemName: "speaker.wave.3.fill")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    NowPlayingView()
        .environment({
            let manager = AudioPlayerManager()
            manager.currentSound = Sound.sampleSounds[0]
            return manager
        }())
}
