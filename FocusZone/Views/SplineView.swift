//
//  SplineView.swift
//  FocusZone
//
//  Created by Eason on 9/13/24.
//

import SplineRuntime
import SwiftUI

struct SplineView: ImmersiveSpaceContent {
    var body: some ImmersiveSpaceContent {
        // fetching from cloud
        let url = URL(string: "https://build.spline.design/p80PNuXU8xN5xWUbuNcd/scene.splineswift")!
        
        // fetching from local
        // let url = Bundle.main.url(forResource: "scene", withExtension: "splineswift")!
        
        SplineImmersiveSpaceContent(sceneFileURL: url)
    }
}
