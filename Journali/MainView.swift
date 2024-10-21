//
//  MainView.swift
//  Journali
//
//  Created by Whyyy on 21/10/2024.
//

import SwiftUI

struct MainView: View {
    
    @State private var showEntry = false
    @State var title: String = ""
    @State var entry: String = ""
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Text("Journal")
                        .font(.system(size: 33, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.leading)
                    Spacer()
                    
                    CircleButton(systemName: "line.3.horizontal.decrease"){
                        
                    } // Filter Button
                    CircleButton(systemName: "plus"){
                        showEntry.toggle()
                    } // Add Button
                    
                } //HStack
                .padding(.horizontal)
                .padding(.top, 20)
                Spacer()
            } //VStack
            
            VStack {
                Image("journal")
                    .resizable()
                    .frame(width: 77.7, height: 101.0)
                    .scaledToFit()
                
                Text("Begin Your Journal")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.83, green: 0.78, blue: 1))
                    .padding(.top, 24.23)
                
                Text("Craft your personal diary, tap the plus icon to begin")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 18, weight: .light, design: .rounded))
                    .padding(.top, 16)
                    .padding(.horizontal, 56.0)
            } //VStack
            .padding()
        } //ZStack
        .sheet(isPresented: $showEntry) {
            
            VStack{
                HStack{
                    
                    Text("Cancel")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(Color(red: 0.64, green: 0.6, blue: 1))
                        .padding(.top, 14)
                        .padding(.leading, 24.0)
                        .onTapGesture {
                            showEntry = false
                        }
                    
                    Spacer()
                    
                    Text("Save")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.64, green: 0.6, blue: 1))
                        .padding(.top, 14)
                        .padding(.trailing, 24.0)
                }
                
                TextField("Title", text: $title)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .accentColor(Color(red: 0.64, green: 0.6, blue: 1))
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 32)
                    .padding(.leading, 21)
                
                Text(Date.now.formatted(date: .numeric, time: .omitted))
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(Color(red: 0.64, green: 0.6, blue: 0.6))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                    .padding(.leading, 21)
                
                ZStack(alignment: .topLeading) {
                                        
                    TextEditor(text: $entry)
                        .font(.system(size: 20, weight: .regular, design: .rounded))
                        .accentColor(Color(red: 0.64, green: 0.6, blue: 1))
                        .padding(.leading, 15)
                        .padding(.top, 15)
                    
                    if entry.isEmpty {
                        Text("Type your Journal...")
                            .foregroundColor(.gray)
                            .padding(.leading, 21)
                            .padding(.top, 23)
                    }
                } //ZStack
            }
            
//            //Debugging
//            Rectangle()
//                .fill(.pink) // This is the content of the sheet
//                .ignoresSafeArea()
        }
    } //View
} //ContetnView


struct CircleButton: View {
    let systemName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action){
            ZStack {
                Circle()
                    .frame(width: 30.0, height: 30.0)
                    .foregroundColor(Color(red: 0.12, green: 0.12, blue: 0.13))
                
                Image(systemName: systemName)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(red: 0.83, green: 0.78, blue: 1))
            }
            .padding(.trailing, 12)
        }
    }
}

#Preview {
    MainView()
}
