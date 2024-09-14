//
//  MySplineWindow.swift
//  FocusZone
//
//  Created by Eason on 9/13/24.
//
import SplineRuntime
import SwiftUI

struct MySplineWindow: View {
    var body: some View {
        // fetching from cloud
        let url = URL(string: "https://build.spline.design/S9l5nViK3LJjATgo4JmH/scene.splineswift")!
        
        // fetching from local
        // let url = Bundle.main.url(forResource: "scene", withExtension: "splineswift")!
        
        SplineView(sceneFileURL: url).ignoresSafeArea(.all)
    }
}

#Preview() {
    MySplineWindow()
}
