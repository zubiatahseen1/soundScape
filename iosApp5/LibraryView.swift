//
//  LibraryView.swift
//  iosApp5
//
//  Created by Zubia Tahseen on 2026-07-12.
//
//  The Library tab — a searchable, filterable list of all sounds.
//  Users can browse by category, search by title, and swipe to favorite.
//

import SwiftUI

// MARK: - Library View

/// Displays the full library of sounds with search and category filtering
struct LibraryView: View {
    /// Access the shared audio player from the environment
    @Environment(AudioPlayerManager.self) private var playerManager

    /// Text entered in the search bar
    @State private var searchText = ""

    /// Currently selected category filter
    @State private var selectedCategory: SoundCategory = .all

    /// Controls whether the sort order info alert is shown
    @State private var showingSortAlert = false

    /// Filters sounds based on search text and selected category
    private var filteredSounds: [Sound] {
        playerManager.sounds.filter { sound in
            // Apply category filter (skip if "All" is selected)
            let matchesCategory = selectedCategory == .all || sound.category == selectedCategory

            // Apply search text filter (skip if search is empty)
            let matchesSearch = searchText.isEmpty ||
                sound.title.localizedCaseInsensitiveContains(searchText) ||
                sound.artist.localizedCaseInsensitiveContains(searchText)

            return matchesCategory && matchesSearch
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category filter using a segmented Picker
                categoryPicker

                // List of sounds matching the current filters
                soundList
            }
            .navigationTitle("Library")
            .searchable(text: $searchText, prompt: "Search sounds...")
            .toolbar {
                // Sort info button in the navigation bar
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSortAlert = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
            // Alert showing how sounds are organized
            .alert("Library Info", isPresented: $showingSortAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Sounds are organized by category. Use the filter and search bar to find specific tracks. Swipe left to favorite a sound.")
            }
        }
    }

    // MARK: - Category Picker

    /// Segmented picker for filtering sounds by category
    private var categoryPicker: some View {
        Picker("Category", selection: $selectedCategory) {
            ForEach(SoundCategory.allCases) { category in
                Text(category.rawValue).tag(category)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    // MARK: - Sound List

    /// Scrollable list of sounds with swipe actions
    private var soundList: some View {
        List {
            ForEach(filteredSounds) { sound in
                SoundRow(sound: sound, isCurrentlyPlaying: playerManager.currentSound?.id == sound.id)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // Play the tapped sound
                        withAnimation(.easeInOut) {
                            playerManager.play(sound)
                        }
                    }
                    // Swipe action to toggle favorite
                    .swipeActions(edge: .trailing) {
                        Button {
                            playerManager.toggleFavorite(sound)
                        } label: {
                            Label(
                                sound.isFavorite ? "Unfavorite" : "Favorite",
                                systemImage: sound.isFavorite ? "heart.slash.fill" : "heart.fill"
                            )
                        }
                        .tint(sound.isFavorite ? .gray : .red)
                    }
            }

            // Show message if no results match the filters
            if filteredSounds.isEmpty {
                ContentUnavailableView(
                    "No Sounds Found",
                    systemImage: "magnifyingglass",
                    description: Text("Try adjusting your search or filter.")
                )
            }
        }
        .listStyle(.plain)
    }
}

// MARK: - Sound Row

/// A single row in the library list displaying sound info
struct SoundRow: View {
    let sound: Sound
    let isCurrentlyPlaying: Bool

    var body: some View {
        HStack(spacing: 14) {
            // Sound icon with colored background
            Image(systemName: sound.iconName)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(sound.accentColor.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            // Title and artist info
            VStack(alignment: .leading, spacing: 2) {
                Text(sound.title)
                    .font(.body.bold())
                    // Highlight the currently playing track in its accent color
                    .foregroundStyle(isCurrentlyPlaying ? sound.accentColor : .primary)

                Text(sound.artist)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Favorite heart indicator
            if sound.isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.red)
                    .font(.caption)
            }

            // Duration label
            Text(formatTime(sound.duration))
                .font(.caption)
                .foregroundStyle(.secondary)

            // Animated equalizer icon for the currently playing track
            if isCurrentlyPlaying {
                Image(systemName: "waveform")
                    .foregroundStyle(sound.accentColor)
                    .symbolEffect(.variableColor.iterative)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview

#Preview {
    LibraryView()
        .environment(AudioPlayerManager())
}
