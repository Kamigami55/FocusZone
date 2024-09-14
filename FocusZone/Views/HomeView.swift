//
//  HomeView.swift
//  FocusZone
//
//  Created by Eason on 9/14/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Focus Zone").font(.title)
            Text("Get things done")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 10) {
                Button(action: {
                    // Button action goes here
                }) {
                    HStack {
                        Text("\(appModel.selectedFocusTimeLength) mins")
                        Image(systemName: "chevron.right")
                    }                .frame(maxWidth: .infinity)
                    
                }
                .frame(maxWidth: .infinity)

                Button(action: {
                    print("Start Button Pressed")
                }) {
                    Text("Start")
                        .frame(maxWidth: .infinity)
                    
                }
                
            }
        }.padding()
    }
}

#Preview(windowStyle: .automatic) {
    HomeView()
        .frame(width: 500, height: 300)
        .environment(AppModel())
}
