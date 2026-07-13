//
//  SettingsView.swift
//  iosApp5
//
//  Created by Zubia Tahseen on 2026-07-12.
//
//  The Settings tab — provides user preferences for playback,
//  a sleep timer, and app information. Uses Form, Toggle, Stepper,
//  and other SwiftUI interface elements.
//

import SwiftUI

// MARK: - Settings View

/// Settings screen with playback preferences, sleep timer, and app info
struct SettingsView: View {
    /// Access the shared audio player from the environment
    @Environment(AudioPlayerManager.self) private var playerManager

    /// Whether notifications are enabled (UI demonstration)
    @State private var notificationsEnabled = true

    /// Whether autoplay is enabled (plays next track automatically)
    @State private var autoplayEnabled = true

    /// Selected audio quality option
    @State private var audioQuality = "High"

    /// Sleep timer duration in minutes (0 = off)
    @State private var sleepTimerMinutes = 0

    /// Whether the sleep timer is currently active
    @State private var sleepTimerActive = false

    /// Available audio quality options
    private let qualityOptions = ["Low", "Medium", "High", "Lossless"]

    var body: some View {
        @Bindable var player = playerManager

        NavigationStack {
            Form {
                // Playback preferences section
                playbackSection(volume: $player.volume)

                // Sleep timer section
                sleepTimerSection

                // Notification preferences
                notificationsSection

                // App information section
                aboutSection
            }
            .navigationTitle("Settings")
        }
    }

    // MARK: - Playback Section

    /// Controls for playback behavior and volume
    private func playbackSection(volume: Binding<Float>) -> some View {
        Section {
            // Master volume slider
            HStack {
                Image(systemName: "speaker.fill")
                    .foregroundStyle(.secondary)
                Slider(value: volume, in: 0...1)
                Image(systemName: "speaker.wave.3.fill")
                    .foregroundStyle(.secondary)
            }

            // Autoplay toggle — plays the next track when the current one ends
            Toggle(isOn: $autoplayEnabled) {
                Label("Autoplay Next", systemImage: "play.circle")
            }

            // Audio quality picker
            Picker("Audio Quality", selection: $audioQuality) {
                ForEach(qualityOptions, id: \.self) { quality in
                    Text(quality).tag(quality)
                }
            }
        } header: {
            Text("Playback")
        } footer: {
            Text("Higher quality uses more data when streaming.")
        }
    }

    // MARK: - Sleep Timer Section

    /// Sleep timer with a stepper to set duration
    private var sleepTimerSection: some View {
        Section {
            // Toggle to enable/disable the sleep timer
            Toggle(isOn: $sleepTimerActive) {
                Label("Sleep Timer", systemImage: "moon.zzz.fill")
            }

            // Duration stepper (only shown when timer is active)
            if sleepTimerActive {
                Stepper(
                    "\(sleepTimerMinutes) minutes",
                    value: $sleepTimerMinutes,
                    in: 5...120,
                    step: 5
                )

                // Visual indicator of the timer duration
                ProgressView(value: Double(sleepTimerMinutes), total: 120)
                    .tint(.indigo)
            }
        } header: {
            Text("Sleep Timer")
        } footer: {
            Text("Audio will automatically stop after the set duration.")
        }
    }

    // MARK: - Notifications Section

    /// Notification preferences
    private var notificationsSection: some View {
        Section("Notifications") {
            Toggle(isOn: $notificationsEnabled) {
                Label("Enable Notifications", systemImage: "bell.fill")
            }
        }
    }

    // MARK: - About Section

    /// App information and credits
    private var aboutSection: some View {
        Section("About") {
            // App version info
            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0")
                    .foregroundStyle(.secondary)
            }

            // Sound count info
            HStack {
                Text("Total Sounds")
                Spacer()
                Text("\(playerManager.sounds.count)")
                    .foregroundStyle(.secondary)
            }

            // Collapsible credits section
            DisclosureGroup("Credits") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("SoundScape")
                        .font(.headline)
                    Text("An ambient sound & media player app built with SwiftUI and AVKit.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Created by Zubia Tahseen")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Sample audio from SoundHelix.com")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
        .environment(AudioPlayerManager())
}
