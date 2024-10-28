//
//  Entry2.swift
//  Journali
//
//  Created by Whyyy on 27/10/2024.
//

import SwiftUI
import SwiftData

struct EntryCell: View {
    
    @Environment(\.modelContext) var context
    @State private var isEditing: JournalEntry?
    @State var isBookmarked: Bool
    var editColor = Color(red: 0.5, green: 0.51, blue: 1)
    
    let entry: JournalEntry
    
    init(entry: JournalEntry) {
        self.entry = entry
        _isBookmarked = State(initialValue: entry.isBookmarked)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(entry.title)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(red: 0.83, green: 0.78, blue: 1))
                    
                    Spacer()
                    
                    Button(action: {
                        toggleBookmark()
                    }) {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .foregroundColor(Color(red: 0.83, green: 0.78, blue: 1))
                            .font(.system(size: 24))
                    }
                }
                .padding(.top, 10)
                
                Text(entry.entrydata.formatted(date: .numeric, time: .omitted))
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(Color(red: 0.64, green: 0.6, blue: 0.6))
                
                Text(entry.entry)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .lineLimit(5)
                    .padding(.bottom, 10)
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                isEditing = entry
            } label: {
                Image(systemName: "pencil")
            }
            .tint(editColor)
        }
        .sheet(item: $isEditing) { entry in
            EditEntryView(entry: entry)
        }
    }
    
    private func toggleBookmark() {
        // Toggle the bookmark status and save it
        isBookmarked.toggle()
        entry.isBookmarked = isBookmarked
        try? context.save()
    }
}


struct Entry2_Previews: PreviewProvider {
    static var previews: some View {
        EntryCell(entry: MockData.SampleJournalEntry)
    }
}
