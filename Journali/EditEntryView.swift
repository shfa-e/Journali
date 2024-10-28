//
//  EditEntryView.swift
//  Journali
//
//  Created by Whyyy on 27/10/2024.
//

import SwiftUI
import SwiftData

struct EditEntryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Bindable var entry: JournalEntry
    
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
            } //HStack
            
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
            } //ZStack
        } //VStack
    }
}

//#Preview {
//    EditEntryView()
//}
