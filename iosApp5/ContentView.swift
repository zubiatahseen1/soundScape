//
//  ContentView.swift
//  iosApp5
//
//  Created by Zubia Tahseen on 2026-07-12.
//
//  Main content view for SoundScape — contains the TabView with
//  Discover, Library, and Settings tabs, plus a floating mini player
//  bar that appears when a track is playing.
//

import SwiftUI

// MARK: - Content View

/// Root view of the app containing the tab navigation and floating mini player
struct ContentView: View {
    /// Access the shared audio player from the environment
    @Environment(AudioPlayerManager.self) private var playerManager

    /// Tracks the currently selected tab
    @State private var selectedTab = 0

    /// Controls whether the full Now Playing sheet is presented
    @State private var showNowPlaying = false

    var body: some View {
        ZStack(alignment: .bottom) {
            // Main tab-based navigation
            TabView(selection: $selectedTab) {
                DiscoverView()
                    .tabItem {
                        Label("Discover", systemImage: "magnifyingglass")
                    }
                    .tag(0)

                LibraryView()
                    .tabItem {
                        Label("Library", systemImage: "music.note.list")
                    }
                    .tag(1)

                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                    .tag(2)
            }

            // Floating mini player — shown when a track is loaded
            if playerManager.currentSound != nil {
                MiniPlayerBar(showNowPlaying: $showNowPlaying)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 50) // Position above the tab bar
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(response: 0.4), value: playerManager.currentSound != nil)
            }
        }
        // Full-screen Now Playing sheet
        .sheet(isPresented: $showNowPlaying) {
            NowPlayingView()
        }
    }
}

// MARK: - Mini Player Bar

/// Compact player bar that floats above the tab bar showing the current track
struct MiniPlayerBar: View {
    /// Access the shared audio player from the environment
    @Environment(AudioPlayerManager.self) private var playerManager

    /// Binding to control the full Now Playing sheet
    @Binding var showNowPlaying: Bool

    var body: some View {
        Button {
            // Tap anywhere on the mini player to expand it
            showNowPlaying = true
        } label: {
            HStack(spacing: 12) {
                // Track icon with colored background
                Image(systemName: playerManager.currentSound?.iconName ?? "music.note")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        (playerManager.currentSound?.accentColor ?? .blue).gradient
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                // Track title and artist
                VStack(alignment: .leading, spacing: 2) {
                    Text(playerManager.currentSound?.title ?? "")
                        .font(.subheadline.bold())
                        .lineLimit(1)

                    Text(playerManager.currentSound?.artist ?? "")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                // Play/Pause button on the mini player
                Button {
                    playerManager.togglePlayPause()
                } label: {
                    Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title3)
                        .foregroundStyle(.primary)
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.plain)

                // Next track button
                Button {
                    playerManager.playNext()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.body)
                        .foregroundStyle(.primary)
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .environment(AudioPlayerManager())
}
