//
//  ExploreViewController.swift
//  Locket
//
//  Created by Tsyrema Mansheeva on 2/10/18.
//  Copyright © 2018 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import ARKit
import FirebaseDatabase

class ExploreViewController: UIViewController,  DisplayPhotoDelegate, UIPopoverPresentationControllerDelegate {
    
    var ref:DatabaseReference!
    
    var url: String!
    
    var sceneView: ARSKView!
    let image = UIImage()
//    var imageView = UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveURLFromDatabase()
        if let view = self.view as? ARSKView {
            let scene = ExploreScene(size: view.bounds.size)
//            if let urlString = url {
//                scene.url = urlString
//            }
            sceneView = view
            sceneView!.delegate = self
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
            
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DisplayVC") as? DisplayPhotoViewController {
                //                viewController.newsObj = newsObj
                //                if let navigator = navigationController {
                
                self.navigationController?.pushViewController(viewController, animated: true)
                //                }
            }
            //
            //            let navVC = UINavigationController(rootViewController: ExploreViewController())
            //            navVC.pushViewController(DisplayPhotoViewController(), animated: true)
            //            self.present(navVC, animated: true, completion: nil)
            //
        }
    }
    
    func retrieveURLFromDatabase() {
        ref = Database.database().reference().child("User").child("ImageLocation")
        //The user have to provide the user part so they can access it
        Database.database().reference().child("User").child("ImageLocation").observeSingleEvent(of: .value, with: { (snapshot) in
            if let url = snapshot.value {
                print(url) // the url is the retrived value
            
//                self.getDataFromUrl(url: URL(string: url as! String)!, completion: {x,y,error in
//                    if error != nil {
//                        print(error)
//                    }
//                })
            }
        }, withCancel: nil)
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }

    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
//            DispatchQueue.main.async() {
//                self.imageView.image = UIImage(data: data)
//            }
        }
    }

//    func downloadImage(url: URL) {
//        print("Download Started")
//        getDataFromUrl(url: url) { data, response, error in
//            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Download Finished")
//            DispatchQueue.main.async() {
//                self.imageView.image = UIImage(data: data)
//            }
//        }
//    }
//
//    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            completion(data, response, error)
//            }.resume()
//    }
    
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
        if let url = URL(string: "hhttps://firebasestorage.googleapis.com/v0/b/locketinfo.appspot.com/o/theImage.png?alt=media&token=6f01e52c-d00f-405d-aeb3-c2983461d6c8") {
//            imageView.contentMode = .scaleAspectFit
            downloadImage(url: url)
        }
        let pic = SKSpriteNode(imageNamed: "heart")
        pic.name = "heart"
        return pic
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //        if segue.identifier == "displayViewSegue" {
    //            if let vc = segue.destination as? DisplayPhotoViewController {
    //                vc.message = true
    //            }
    //        }
    //    }
    
    
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

