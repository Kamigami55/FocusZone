//
//  ContentView.swift
//  FocusZone
//
//  Created by Eason on 9/12/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Hello, world!")

            ToggleImmersiveSpaceButton(immersiveSpaceID: model.immersiveSpaceID)
            
            ToggleImmersiveSpaceButton(
                immersiveSpaceID: model.splineImmersiveSpaceID
            )
            
            SolarSystemToggle()
            
            ImmersiveEnvironmentPickerView()
        }
        .padding()
        .immersionManager()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
        .environment(ImmersiveEnvironment())
}
