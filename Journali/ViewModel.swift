//
//  JournalViewModel.swift
//  Journali
//
//  Created by Whyyy on 21/10/2024.
//

import SwiftUI
import SwiftData

class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
    @Published var searchTerm: String = ""
    @Published var showOnlyBookmarked: Bool = false
    @Published var isSortedByOldest: Bool = false
    @Published var showEntry: Bool = false

    func fetchEntries(context: ModelContext) {
            let sortDescriptor = isSortedByOldest ? SortDescriptor(\JournalEntry.entrydata, order: .forward) : SortDescriptor(\JournalEntry.entrydata, order: .reverse)
            
            let request = FetchDescriptor<JournalEntry>(
                predicate: nil,
                sortBy: [sortDescriptor]
            )
            
            do {
                self.entries = try context.fetch(request)
            } catch {
                print("Failed to fetch entries: \(error)")
                self.entries = []
            }
        }

    // Filter and sort entries based on user preferences
    func filteredAndSortedEntries() -> [JournalEntry] {
        let filteredEntries = entries.filter { entry in
            (showOnlyBookmarked ? entry.isBookmarked : true) &&
            (searchTerm.isEmpty || entry.title.localizedCaseInsensitiveContains(searchTerm))
        }
        
        return isSortedByOldest ? filteredEntries.sorted { $0.entrydata < $1.entrydata } : filteredEntries.sorted { $0.entrydata > $1.entrydata }
    }

    // Add a new journal entry
    func addEntry(_ newEntry: JournalEntry, context: ModelContext) {
        context.insert(newEntry)
        try? context.save()
        fetchEntries(context: context)
    }

    // Delete an entry
    func deleteEntry(_ entry: JournalEntry, context: ModelContext) {
        context.delete(entry)
        try? context.save()
        fetchEntries(context: context)
    }

    // Toggle the bookmark status of an entry
    func toggleBookmark(for entry: JournalEntry, context: ModelContext) {
        entry.isBookmarked.toggle()
        try? context.save()
    }
}
