//
//  ContentView.swift
//  Journali
//
//  Created by Whyyy on 21/10/2024.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = JournalViewModel()

    var purple = Color(red: 0.83, green: 0.78, blue: 1)
    var eblack = Color(red: 0.12, green: 0.12, blue: 0.13)
    var cellBackgroundColor = Color(red: 0.09, green: 0.09, blue: 0.1)

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.entries.isEmpty {
                    EmptyStateView(purple: purple)
                } else {
                    List {
                        ForEach(viewModel.filteredAndSortedEntries()) { entry in
                            Section {
                                EntryCell(entry: entry, viewModel: viewModel)
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(cellBackgroundColor)
                                    )
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                viewModel.deleteEntry(entry, context: context)
                                            }
                                        } label: {
                                            Image(systemName: "trash")
                                        }
                                        .tint(.red)
                                    }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .searchable(text: $viewModel.searchTerm, prompt: "Search")
                }
            }
            .navigationTitle("Journal")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            viewModel.showOnlyBookmarked.toggle()
                        }) {
                            Text(viewModel.showOnlyBookmarked ? "Show All" : "Show Bookmarked")
                        }
                        Button(action: {
                            viewModel.isSortedByOldest.toggle()
                        }) {
                            Text("Journal Date: \(viewModel.isSortedByOldest ? "Oldest First" : "Newest First")")
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(purple, eblack)
                            .padding(.trailing, -12) // 
                    }
                    
                    Button(action: {
                        viewModel.showEntry.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(purple, eblack)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showEntry) {
                JournalEntryView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchEntries(context: context)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct EntryCell: View {
    @Environment(\.modelContext) private var context
    @State private var isEditing: Bool = false
    @State var isBookmarked: Bool
    var editColor = Color(red: 0.5, green: 0.51, blue: 1)
    let entry: JournalEntry
    @ObservedObject var viewModel: JournalViewModel

    init(entry: JournalEntry, viewModel: JournalViewModel) {
        self.entry = entry
        self.viewModel = viewModel
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
                isEditing = true
            } label: {
                Image(systemName: "pencil")
            }
            .tint(editColor)
        }
        .sheet(isPresented: $isEditing) {
            EditEntryView(entry: entry)
        }
    }

    private func toggleBookmark() {
        isBookmarked.toggle()
        viewModel.toggleBookmark(for: entry, context: context)
    }
}

struct JournalEntryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @State private var currentEntry = JournalEntry(
        title: "",
        entrydata: Date(),
        entry: "",
        isBookmarked: false
    )
    @ObservedObject var viewModel: JournalViewModel

    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(Color(red: 0.64, green: 0.6, blue: 1))
                .padding(.top, 14)
                .padding(.leading, 24.0)
                Spacer()
                Button("Save") {
                    viewModel.addEntry(currentEntry, context: context)
                    dismiss()
                }
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(Color(red: 0.64, green: 0.6, blue: 1))
                .padding(.top, 14)
                .padding(.trailing, 24.0)
            }
            TextField("Title", text: $currentEntry.title)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .accentColor(Color(red: 0.64, green: 0.6, blue: 1))
                .padding(.top, 32)
                .padding(.leading, 21)
            Text(currentEntry.entrydata.formatted(date: .numeric, time: .omitted))
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(Color(red: 0.64, green: 0.6, blue: 0.6))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
                .padding(.leading, 21)
            ZStack(alignment: .topLeading) {
                TextEditor(text: $currentEntry.entry)
                    .font(.system(size: 20, weight: .regular, design: .rounded))
                    .accentColor(Color(red: 0.64, green: 0.6, blue: 1))
                    .padding(.leading, 15)
                    .padding(.top, 15)
                if currentEntry.entry.isEmpty {
                    Text("Type your Journal...")
                        .foregroundColor(.gray)
                        .padding(.leading, 21)
                        .padding(.top, 23)
                }
            }
        }
    }
}

struct EditEntryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @Bindable var entry: JournalEntry

    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(Color(red: 0.64, green: 0.6, blue: 1))
                .padding(.top, 14)
                .padding(.leading, 24.0)
                Spacer()
                Button("Save") {
                    do {
                        try context.save()
                        dismiss()
                    } catch {
                        print("Error saving context: \(error)")
                    }
                }
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(Color(red: 0.64, green: 0.6, blue: 1))
                .padding(.top, 14)
                .padding(.trailing, 24.0)
            }
            TextField("Title", text: $entry.title)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .accentColor(Color(red: 0.64, green: 0.6, blue: 1))
                .padding(.top, 32)
                .padding(.leading, 21)
            Text(entry.entrydata.formatted(date: .numeric, time: .omitted))
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(Color(red: 0.64, green: 0.6, blue: 0.6))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
                .padding(.leading, 21)
            ZStack(alignment: .topLeading) {
                TextEditor(text: $entry.entry)
                    .font(.system(size: 20, weight: .regular, design: .rounded))
                    .accentColor(Color(red: 0.64, green: 0.6, blue: 1))
                    .padding(.leading, 15)
                    .padding(.top, 15)
                if entry.entry.isEmpty {
                    Text("Type your Journal...")
                        .foregroundColor(.gray)
                        .padding(.leading, 21)
                        .padding(.top, 23)
                }
            }
        }
    }
}

struct EmptyStateView: View {
    var purple: Color

    var body: some View {
        VStack {
            Image("journal")
                .resizable()
                .frame(width: 77.7, height: 101.0)
                .scaledToFit()
            Text("Begin Your Journal")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(purple)
                .padding(.top, 24.23)
            Text("Craft your personal diary, tap the plus icon to begin")
                .multilineTextAlignment(.center)
                .font(.system(size: 18, weight: .light, design: .rounded))
                .padding(.top, 16)
                .padding(.horizontal, 56.0)
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .center)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .modelContainer(for: JournalEntry.self)
    }
}
