//
//  SplashUIScreen.swift
//  Journali
//
//  Created by Whyyy on 29/10/2024.
//

import SwiftUI

struct SplashScreenUIView: View {
    @State private var navigateToEmptyView = false // State to control navigation

    var body: some View {
        NavigationView {
            ZStack {
                
                Color.black.edgesIgnoringSafeArea(.all)
                
                LinearGradient(gradient: Gradient(colors: [Color(red: 88 / 255, green: 86 / 255, blue: 215 / 255).opacity(0.3), Color.clear]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image("journal")
                        .resizable()
                        .frame(width: 77.0, height: 101.0)
                    
                    Text("Journali").font(.largeTitle).bold().foregroundStyle(Color.white)
                    
                    Text("Your thoughts, your story").foregroundStyle(Color.white)
                    
                } // End of VStack
                // NavigationLink to handle automatic navigation
                NavigationLink(destination: MainView(), isActive: $navigateToEmptyView) {
                    EmptyView() // Hidden navigation link
                }
            } // End of ZStack
            
            .onAppear {
                // Navigate to EmptyStateView after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    navigateToEmptyView = true
                }
            }
            
        } // End of NavigationView
    } // End of body
} // End of ContentView

#Preview {
    SplashScreenUIView()
}
