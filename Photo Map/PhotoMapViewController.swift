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
        
        mapView.delegate = self
        
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
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "tagSegue" {
            let locationsVC = segue.destinationViewController as! LocationsViewController
            locationsVC.delegate = self
            
        }
        
    }
}

extension PhotoMapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let original = info[UIImagePickerControllerOriginalImage] as! UIImage
        // let edited   = info[UIImagePickerControllerEditedImage] as! UIImage
        
        image = original
        
        dismissViewControllerAnimated(true) { () -> Void in
            self.performSegueWithIdentifier("tagSegue", sender: self)
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("cancelled")
    }
}

extension PhotoMapViewController: LocationsViewControllerDelegate {
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        let coordinate = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue)
        let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(region, animated: false)
        
        let annotation = PhotoAnnotation() // MKPointAnnotation()
        annotation.coordinate = coordinate
        // annotation.title = "Picture!"
        annotation.photo = image
        mapView.addAnnotation(annotation)
    }
}

extension PhotoMapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        print("viewForAnnotation")
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        
        // create it if it's te first time
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        // imageView.image = UIImage(named: "camera")
        let resizeRenderImageView = UIImageView(frame: CGRectMake(0, 0, 45, 45))
        resizeRenderImageView.layer.borderColor = UIColor.whiteColor().CGColor
        resizeRenderImageView.layer.borderWidth = 3.0
        resizeRenderImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeRenderImageView.image = (annotation as? PhotoAnnotation)?.photo

        UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
        resizeRenderImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        imageView.image = thumbnail


        
        return annotationView
    }
}