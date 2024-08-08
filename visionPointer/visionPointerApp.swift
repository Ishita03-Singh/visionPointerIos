//
//  visionPointerApp.swift
//  visionPointer
//
//  Created by Ishita Singh on 06/08/24.
//

import SwiftUI
import UIKit
import ARKit
import SceneKit
import CoreLocation

@main
struct visionPointerApp: App {
    var body: some Scene {
        WindowGroup {
            ARViewContainer()
            ContentView()
        }
    }
}

