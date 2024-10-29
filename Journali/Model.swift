//
//  JournalEntry.swift
//  Journali
//
//  Created by Whyyy on 21/10/2024.
//

import Foundation
import SwiftData

@Model
final class JournalEntry: ObservableObject, Identifiable {
    var id: UUID = UUID()
    var title: String
    var entrydata: Date
    var entry: String
    var isBookmarked: Bool

    init(title: String, entrydata: Date, entry: String, isBookmarked: Bool = false) {
        self.title = title
        self.entrydata = entrydata
        self.entry = entry
        self.isBookmarked = isBookmarked
    }
}
