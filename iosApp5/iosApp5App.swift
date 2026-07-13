//
//  iosApp5App.swift
//  iosApp5
//
//  Created by Zubia Tahseen on 2026-07-12.
//
//  Entry point for the SoundScape app.
//  Initializes the AudioPlayerManager and injects it
//  into the SwiftUI environment for all child views.
//

import SwiftUI

@main
struct iosApp5App: App {
    /// Shared audio player manager — injected into the environment
    /// so all views can access and control playback
    @State private var playerManager = AudioPlayerManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(playerManager)
        }
    }
}
