//
//  JournalEntryModel.swift
//  Journali
//
//  Created by Whyyy on 22/10/2024.
//

import Foundation
import SwiftData

@Model
final class JournalEntry: Identifiable {
    var id: UUID
    var title: String
    var entrydata: Date
    var entry: String
    var isBookmarked: Bool
    
    init (id: UUID = UUID(),title: String, entrydata: Date, entry: String, isBookmarked: Bool) {
        self.id = id
        self.title = title
        self.entrydata = entrydata
        self.entry = entry
        self.isBookmarked = isBookmarked
    }
}

struct MockData{
    static let  SampleJournalEntry: JournalEntry = {
        JournalEntry(title: "Test",
                    entrydata: Date(),
                    entry: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                     isBookmarked:false)
    }()
}
