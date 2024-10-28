//
//  JournalEntryView.swift
//  Journali
//
//  Created by Whyyy on 23/10/2024.
//

import SwiftUI

struct JournalEntryView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var currentEntry = JournalEntry(
        title: "",
        entrydata: Date(),
        entry: "",
        isBookmarked: false
    )

    var body: some View {
        VStack{
            HStack{
                Button("Cancel"){
                    dismiss()
                }
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(Color(red: 0.64, green: 0.6, blue: 1))
                .padding(.top, 14)
                .padding(.leading, 24.0)
                
                Spacer()
                
                Button("Save") {
                    do {
                        context.insert(currentEntry)  // Insert the entry
                        try context.save()  // Save the context and handle any error that occurs
                        dismiss()  // Dismiss the view after saving
//                        print("Saved")
                    } catch {
                        // Handle the error here (e.g., show an alert or log the error)
                        print("Failed to save the entry: \(error)")
                    }
                }
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.64, green: 0.6, blue: 1))
                    .padding(.top, 14)
                    .padding(.trailing, 24.0)
            } //HStack
            
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
            } //ZStack
        } //VStack
    }
}

#Preview {
    JournalEntryView()
        .modelContainer(for: JournalEntry.self)
}
