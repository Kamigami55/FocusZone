//
//  MySplineVolume.swift
//  FocusZone
//
//  Created by Eason on 9/13/24.
//

import SplineRuntime
import SwiftUI

struct MySplineVolume: View {
    var body: some View {
        // fetching from cloud
        let url = URL(string: "https://build.spline.design/S9l5nViK3LJjATgo4JmH/scene.splineswift")!
        
        // fetching from local
        // let url = Bundle.main.url(forResource: "scene", withExtension: "splineswift")!
        
        SplineVolumetricContent(sceneFileURL: url)
    }
}

#Preview(windowStyle: .volumetric) {
    MySplineVolume()
}
