import UIKit
import ARKit
import SceneKit
import CoreLocation


import SwiftUI

struct ARViewContainer: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ARViewController {
        return ARViewController()
    }

    func updateUIViewController(_ uiViewController: ARViewController, context: Context) {
        // Update the view controller if needed
    }
}


class ARViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {
    
    var sceneView: ARSCNView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize ARSCNView
        sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Set up location manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Get the current camera transform
        let transform = frame.camera.transform
        
        // Define the size of the device (assuming an iPhone for this example)
        let phoneWidth: Float = 0.075 // 75mm width
        let phoneHeight: Float = 0.15 // 150mm height
        
        // Calculate the corner positions in the camera coordinate system
        let corners = [
            SIMD4<Float>(-phoneWidth/2, -phoneHeight/2, 0, 1), // bottom-left
            SIMD4<Float>(phoneWidth/2, -phoneHeight/2, 0, 1),  // bottom-right
            SIMD4<Float>(-phoneWidth/2, phoneHeight/2, 0, 1),  // top-left
            SIMD4<Float>(phoneWidth/2, phoneHeight/2, 0, 1)    // top-right
        ]
        
        // Transform the corners to world coordinates
        let worldCorners = corners.map { transform * $0 }
        
        // Log the world coordinates of the corners
        for (index, corner) in worldCorners.enumerated() {
            print("Corner \(index + 1): \(corner)")
        }
    }
    
    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Current location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}
