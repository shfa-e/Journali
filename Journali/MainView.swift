//
//  MainView.swift
//  Journali
//
//  Created by Whyyy on 21/10/2024.
//

import SwiftUI
import SwiftData

struct MainView: View {
    
    @State private var showEntry = false
    @State private var searchTerm = ""
    @State private var showOnlyBookmarked = false
    @State private var isSortedByOldest = false
    @Environment(\.modelContext) var context
    @Query private var entries: [JournalEntry]
    
    var purple = Color(red: 0.83, green: 0.78, blue: 1)
    var eblack = Color(red: 0.12, green: 0.12, blue: 0.13)
    var cellBackgroundColor = Color(red: 0.09, green: 0.09, blue: 0.1)
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Title and Buttons
                HStack {
                    Text("Journal")
                        .font(.system(size: 33, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.leading)
                    Spacer()
                    
                    Menu {
                        Button(action: {
                            showOnlyBookmarked.toggle()
                        }) {
                            Text(showOnlyBookmarked ? "Show All" : "Show Bookmarked")
                        }
                        
                        Button(action: {
                            isSortedByOldest.toggle()
                        }) {
                            Text("Journal Date: \(isSortedByOldest ? "Oldest First" : "Newest First")")
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(purple, eblack)
                    }
                    
                    Button(action: {
                        showEntry.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(purple, eblack)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // List with Searchable Modifier
                if entries.isEmpty {
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
                } else {
                    NavigationView{
                        List {
                            ForEach(
                                entries
                                    .filter { entry in // Filter based on search term and bookmark status
                                        (searchTerm.isEmpty || entry.title.contains(searchTerm)) &&
                                        (!showOnlyBookmarked || entry.isBookmarked)
                                    }
                                    .sorted(by:{
                                        isSortedByOldest ? $0.entrydata < $1.entrydata : $0.entrydata > $1.entrydata
                                    })
                            ) { entry in
                                Section {
                                    EntryCell(entry: entry)
                                        .listRowSeparator(.hidden)
                                        .listRowBackground(
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(cellBackgroundColor)
                                        )
                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                            Button(role: .destructive) {
                                                withAnimation {
                                                    context.delete(entry)
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
                    }
                    .searchable(text: $searchTerm, prompt: "Search")
                }
            }
            .sheet(isPresented: $showEntry) {
                JournalEntryView()
            }
        }
    }
}

#Preview {
    MainView()
}
