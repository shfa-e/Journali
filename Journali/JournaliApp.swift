//
//  JournaliApp.swift
//  Journali
//
//  Created by Whyyy on 21/10/2024.
//

import SwiftUI
import SwiftData

@main
struct JournaliApp: App {
    var body: some Scene {
        WindowGroup {
            SplashScreenUIView()
                .modelContainer(for: JournalEntry.self)
        }
    }
}
