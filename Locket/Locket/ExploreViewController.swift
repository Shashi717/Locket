//
//  ExploreViewController.swift
//  Locket
//
//  Created by Tsyrema Mansheeva on 2/10/18.
//  Copyright © 2018 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import ARKit


class ExploreViewController: UIViewController,  DisplayPhotoDelegate {
  

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
            print("gjhghjghjgjgj")
            
////            self.presentViewController(vc, animated: true, completion: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "DisplayVC") as! DisplayPhotoViewController
////            let vc = DisplayPhotoViewController()
//
            self.present(DisplayPhotoViewController(), animated: true, completion: nil)
            
            
            
//            self.performSegue(withIdentifier: "displayViewSegue", sender: self)
            
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "displayViewSegue" {
            if let vc = segue.destination as? DisplayPhotoViewController {
                vc.message = true
            }
        }
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

