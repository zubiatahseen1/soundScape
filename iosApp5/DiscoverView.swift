//
//  DiscoverView.swift
//  iosApp5
//
//  Created by Zubia Tahseen on 2026-07-12.
//
//  The Discover tab — showcases featured sounds, category browsing,
//  an embedded video player, and a horizontally scrollable sound list.
//

import SwiftUI
import AVKit

// MARK: - Discover View

/// Main discovery/home screen with featured content, categories, and a video player
struct DiscoverView: View {
    /// Access the shared audio player from the environment
    @Environment(AudioPlayerManager.self) private var playerManager

    /// Sample video URL for the embedded media player
    private let sampleVideoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Welcome header with current date greeting
                    headerSection

                    // Large featured sound card
                    featuredSoundCard

                    // Category browsing grid
                    categoriesSection

                    // Embedded video media player
                    videoPlayerSection

                    // Horizontally scrollable sound suggestions
                    suggestedSoundsSection
                }
                .padding(.horizontal)
                .padding(.bottom, 100) // Extra padding for mini player
            }
            .navigationTitle("Discover")
        }
    }

    // MARK: - Header Section

    /// Displays a personalized greeting at the top of the screen
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Welcome Back")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("Find Your Calm")
                .font(.title.bold())
        }
        .padding(.top, 8)
    }

    // MARK: - Featured Sound Card

    /// A large, visually prominent card highlighting a featured sound
    private var featuredSoundCard: some View {
        let featured = playerManager.sounds[0] // First sound as featured

        return Button {
            playerManager.play(featured)
        } label: {
            ZStack(alignment: .bottomLeading) {
                // Gradient background using the sound's accent color
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [featured.accentColor, featured.accentColor.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 200)

                // Large background icon
                Image(systemName: featured.iconName)
                    .font(.system(size: 120))
                    .foregroundStyle(.white.opacity(0.15))
                    .offset(x: 180, y: -20)

                // Text overlay with sound details
                VStack(alignment: .leading, spacing: 8) {
                    Text("FEATURED")
                        .font(.caption.bold())
                        .foregroundStyle(.white.opacity(0.8))

                    Text(featured.title)
                        .font(.title2.bold())
                        .foregroundStyle(.white)

                    Text(featured.artist)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))

                    // Play button indicator
                    HStack {
                        Image(systemName: "play.circle.fill")
                        Text("Play Now")
                            .font(.subheadline.bold())
                    }
                    .foregroundStyle(.white)
                    .padding(.top, 4)
                }
                .padding(20)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: featured.accentColor.opacity(0.3), radius: 10, y: 5)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Categories Section

    /// Grid of category buttons for browsing by type
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categories")
                .font(.title3.bold())

            // 2-column grid layout for categories
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                // Show all categories except "All"
                ForEach(SoundCategory.allCases.filter { $0 != .all }) { category in
                    CategoryCard(category: category)
                }
            }
        }
    }

    // MARK: - Video Player Section

    /// Embedded video player showcasing media playback capabilities
    private var videoPlayerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured Video")
                .font(.title3.bold())

            // AVKit VideoPlayer for embedded video playback
            VideoPlayer(player: AVPlayer(url: sampleVideoURL))
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 4)
        }
    }

    // MARK: - Suggested Sounds Section

    /// Horizontal scrollable list of sound suggestions
    private var suggestedSoundsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Suggested For You")
                .font(.title3.bold())

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    // Show a selection of sounds as suggestion cards
                    ForEach(playerManager.sounds.suffix(6)) { sound in
                        SoundCard(sound: sound) {
                            playerManager.play(sound)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Category Card

/// A compact card representing a sound category
struct CategoryCard: View {
    let category: SoundCategory

    var body: some View {
        HStack(spacing: 12) {
            // Category icon in a colored circle
            Image(systemName: category.iconName)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(category.color.gradient)
                .clipShape(Circle())

            Text(category.rawValue)
                .font(.subheadline.bold())
                .foregroundStyle(.primary)

            Spacer()
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Sound Card

/// A compact card for displaying a sound in horizontal scroll views
struct SoundCard: View {
    let sound: Sound
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // Sound icon with gradient background
                Image(systemName: sound.iconName)
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .frame(width: 100, height: 100)
                    .background(
                        LinearGradient(
                            colors: [sound.accentColor, sound.accentColor.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                // Track title and artist
                Text(sound.title)
                    .font(.caption.bold())
                    .lineLimit(1)

                Text(sound.artist)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .frame(width: 100)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    DiscoverView()
        .environment(AudioPlayerManager())
}
