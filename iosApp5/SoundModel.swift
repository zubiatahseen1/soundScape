//
//  SoundModel.swift
//  iosApp5
//
//  Created by Zubia Tahseen on 2026-07-12.
//
//  Data models for the SoundScape app — defines Sound tracks,
//  categories, and sample data used throughout the app.
//

import SwiftUI

// MARK: - Sound Model

/// Represents a single sound track in the app
struct Sound: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let artist: String
    let category: SoundCategory
    let duration: TimeInterval   // Duration in seconds
    let iconName: String         // SF Symbol name for the track artwork
    let accentColor: Color       // Theme color for the track
    let audioURL: URL?           // Remote URL for audio playback
    var isFavorite: Bool = false // Whether the user has favorited this track

    // Custom Hashable conformance using unique id
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Sound, rhs: Sound) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Sound Category

/// Categories used to organize and filter sounds
enum SoundCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case nature = "Nature"
    case ambient = "Ambient"
    case music = "Music"
    case meditation = "Meditation"

    var id: String { rawValue }

    /// SF Symbol icon representing each category
    var iconName: String {
        switch self {
        case .all: return "square.grid.2x2.fill"
        case .nature: return "leaf.fill"
        case .ambient: return "sparkles"
        case .music: return "music.note"
        case .meditation: return "heart.circle.fill"
        }
    }

    /// Theme color for each category
    var color: Color {
        switch self {
        case .all: return .gray
        case .nature: return .green
        case .ambient: return .purple
        case .music: return .blue
        case .meditation: return .orange
        }
    }
}

// MARK: - Sample Data

extension Sound {
    /// Pre-populated sample sounds for the app
    static let sampleSounds: [Sound] = [
        // Nature sounds
        Sound(title: "Forest Rain", artist: "Nature Sounds", category: .nature,
              duration: 245, iconName: "cloud.rain.fill", accentColor: .blue,
              audioURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")),
        Sound(title: "Ocean Waves", artist: "Nature Sounds", category: .nature,
              duration: 312, iconName: "water.waves", accentColor: .cyan,
              audioURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3")),
        Sound(title: "Mountain Wind", artist: "Nature Sounds", category: .nature,
              duration: 198, iconName: "wind", accentColor: .mint,
              audioURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3")),
        Sound(title: "Birdsong Dawn", artist: "Nature Sounds", category: .nature,
              duration: 267, iconName: "bird.fill", accentColor: .green,
              audioURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3")),

        // Ambient sounds
        Sound(title: "Space Drift", artist: "Ambient Lab", category: .ambient,
              duration: 420, iconName: "moon.stars.fill", accentColor: .indigo,
              audioURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3")),
        Sound(title: "City Night", artist: "Ambient Lab", category: .ambient,
              duration: 356, iconName: "building.2.fill", accentColor: .purple,
              audioURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3")),
        Sound(title: "Deep Focus", artist: "Ambient Lab", category: .ambient,
              duration: 289, iconName: "rays", accentColor: .pink,
              audioURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3")),

        // Music
        Sound(title: "Piano Dreams", artist: "Calm Music", category: .music,
              duration: 234, iconName: "music.note.list", accentColor: .brown,
              audioURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3")),
        Sound(title: "Guitar Sunset", artist: "Calm Music", category: .music,
              duration: 278, iconName: "guitars.fill", accentColor: .orange,
              audioURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3")),
        Sound(title: "Gentle Strings", artist: "Calm Music", category: .music,
              duration: 345, iconName: "music.quarternote.3", accentColor: .red,
              audioURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3")),

        // Meditation
        Sound(title: "Breathing Space", artist: "Mindful", category: .meditation,
              duration: 600, iconName: "lungs.fill", accentColor: .teal,
              audioURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3")),
        Sound(title: "Inner Peace", artist: "Mindful", category: .meditation,
              duration: 480, iconName: "brain.head.profile.fill", accentColor: .pink,
              audioURL: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3")),
    ]
}

// MARK: - Helper Functions

/// Formats a TimeInterval (seconds) into a "m:ss" display string
func formatTime(_ time: TimeInterval) -> String {
    guard !time.isNaN && !time.isInfinite else { return "0:00" }
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    return String(format: "%d:%02d", minutes, seconds)
}
