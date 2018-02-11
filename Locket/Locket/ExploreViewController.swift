//
//  ExploreViewController.swift
//  Locket
//
//  Created by Tsyrema Mansheeva on 2/10/18.
//  Copyright © 2018 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import ARKit
import FirebaseDatabase


class ExploreViewController: UIViewController,  DisplayPhotoDelegate {
    var ref:DatabaseReference!
    func retrieveURLFromDatabase() {
        ref = Database.database().reference().child("User").child("ImageLocation")
        //The user have to provide the user part so they can access it
        Database.database().reference().child("User").child("ImageLocation").observeSingleEvent(of: .value, with: { (snapshot) in
            if let url = snapshot.value {
                print(url) // the url is the retrived value 
            }
        }, withCancel: nil)
    }

    
    var sceneView: ARSKView!
    let image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? ARSKView {
            sceneView = view
            sceneView!.delegate = self
            let scene = ExploreScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view.presentScene(scene)
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
       
    }
    func displayPhoto(shouldDisplay: Bool) {
        if shouldDisplay {
            let vc = DisplayPhotoViewController()
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
       
        sceneView?.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView?.session.pause()
    }
}

extension ExploreViewController: ARSKViewDelegate {
    func session(_ session: ARSession,
                 didFailWithError error: Error) {
        print("Session Failed - probably due to lack of camera access")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("Session interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("Session resumed")
        sceneView.session.run(session.configuration!,
                              options: [.resetTracking,
                                        .removeExistingAnchors])
    }
    
    // attach a heart to anchor
    func view(_ view: ARSKView,
              nodeFor anchor: ARAnchor) -> SKNode? {
        let pic = SKSpriteNode(imageNamed: "heart")
        pic.name = "heart"
        return pic
    }
    
    func displayPhoto (image: UIImage) {
        let vc = DisplayPhotoViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

