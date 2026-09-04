# SoundScape

An ambient sound & media player app for iOS, built with SwiftUI and AVKit.

SoundScape lets you browse a curated library of nature, ambient, music, and meditation
tracks, stream them with full playback controls, and fall asleep to them with a sleep
timer. It was built as an iOS coursework project for the Mobile and Web Developer
program at Trios College.

---

## Features

### Discover
- Welcome header and a **featured sound card** with a one-tap "Play Now" action
- Horizontally scrolling **category cards** — Nature, Ambient, Music, Meditation
- Embedded **video player** (AVKit `VideoPlayer`) demonstrating media playback
- "Suggested For You" carousel of sound cards

### Library
- Searchable list of all tracks (`.searchable`)
- **Segmented category filter** to narrow results by type
- **Swipe-to-favorite** on any row, with a heart indicator
- `ContentUnavailableView` empty state when no track matches the search or filter

### Now Playing
- Full-screen sheet with animated rotating artwork
- Scrubbable **seek slider** with elapsed and remaining time
- Play/pause, skip ±15 seconds, previous/next track
- Volume slider wired to the live player

### Mini Player
- Floating glass bar (`.ultraThinMaterial`) above the tab bar whenever a track is loaded
- Shows current artwork, title, and artist; play/pause and next controls
- Tap anywhere on the bar to expand into Now Playing

### Settings
- Volume control, autoplay toggle, and audio-quality picker
- **Sleep timer** with a stepper for duration
- Notification toggle
- About section with version, track count, and credits

---

## Tech Stack

| Area | Technology |
|---|---|
| UI | SwiftUI |
| Audio | AVFoundation (`AVPlayer`) |
| Video | AVKit (`VideoPlayer`) |
| State | `@Observable` macro + SwiftUI `@Environment` injection |
| Language | Swift 5 |
| Minimum iOS | iOS 26.4 |
| Devices | iPhone and iPad |

SwiftUI components used throughout: `TabView`, `NavigationStack`, `List`, `Form`,
`Section`, `Picker`, `Toggle`, `Stepper`, `Slider`, `ScrollView`, `.sheet`,
`.searchable`, `.swipeActions`, and `ContentUnavailableView`.

---

## Project Structure

```
iosApp5/
├── iosApp5App.swift          # App entry point — creates and injects AudioPlayerManager
├── ContentView.swift         # Root TabView + floating MiniPlayerBar
├── DiscoverView.swift        # Featured card, categories, video player, suggestions
├── LibraryView.swift         # Searchable, filterable track list with swipe actions
├── NowPlayingView.swift      # Full-screen player: artwork, seek, transport, volume
├── SettingsView.swift        # Playback prefs, sleep timer, notifications, about
├── SoundModel.swift          # Sound struct, SoundCategory enum, sample data, formatTime
├── AudioPlayerManager.swift  # @Observable AVPlayer wrapper — play, seek, skip, favorite
└── Assets.xcassets/          # App icon and accent color
```

### Architecture

A single `AudioPlayerManager` is created in `iosApp5App` and injected into the SwiftUI
environment. Every view reads it with `@Environment(AudioPlayerManager.self)`, so the
mini player, Now Playing sheet, Library, and Settings all stay in sync with one source
of truth. The manager wraps `AVPlayer` and publishes `currentSound`, `isPlaying`,
`currentTime`, `totalDuration`, and `volume`; a periodic time observer updates playback
position twice a second.

---

## Getting Started

**Requirements:** Xcode 26 or later, macOS, iOS 26.4 simulator or device.

```bash
git clone https://github.com/zubiatahseen1/iosApp5.git
cd iosApp5
open iosApp5.xcodeproj
```

Select an iPhone or iPad simulator and press **⌘R** to run.

> Audio and video stream from remote URLs, so an internet connection is required for
> playback.

---

## Credits

- Sample audio tracks: [SoundHelix](https://www.soundhelix.com)
- Icons: Apple SF Symbols
- Created by **Zubia Tahseen**

## License

Released for educational use as part of coursework.
