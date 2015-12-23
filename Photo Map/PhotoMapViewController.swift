//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController {
    var image: UIImage!
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
            MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfRegion, animated: false)
        
        let tap = UITapGestureRecognizer(target: self, action: "cameraButtonTapped")
        cameraButtonImageView.addGestureRecognizer(tap)
    }
    
    func cameraButtonTapped() {
        print("tapped")
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .PhotoLibrary
        presentViewController(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var cameraButtonImageView: UIImageView!
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

extension PhotoMapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let original = info[UIImagePickerControllerOriginalImage] as! UIImage
        // let edited   = info[UIImagePickerControllerEditedImage] as! UIImage
        print("original:", original)
        
        image = original
        
        dismissViewControllerAnimated(true) { () -> Void in
            self.performSegueWithIdentifier("tagSegue", sender: self)
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("cancelled")
    }
}
