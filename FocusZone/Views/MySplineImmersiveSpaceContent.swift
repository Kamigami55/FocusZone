//
//  SplineImmersiveSpaceContent.swift
//  FocusZone
//
//  Created by Eason on 9/13/24.
//

import SplineRuntime
import SwiftUI

struct MySplineImmersiveSpaceContent: ImmersiveSpaceContent {
    var body: some ImmersiveSpaceContent {
        // fetching from cloud
        //        Blue shpere
//        let url = URL(string: "https://build.spline.design/p80PNuXU8xN5xWUbuNcd/scene.splineswift")!
        //        Platform
        let url = URL(string: "https://build.spline.design/S9l5nViK3LJjATgo4JmH/scene.splineswift")!
        
        // fetching from local
        // let url = Bundle.main.url(forResource: "scene", withExtension: "splineswift")!
        
        SplineImmersiveSpaceContent(sceneFileURL: url)
    }
}
