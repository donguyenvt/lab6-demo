//
//  PhotoAnnotation.swift
//  Photo Map
//
//  Created by Harley Trung on 12/23/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import Foundation
import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var photo: UIImage!

    var title: String? {
        return "\(coordinate.latitude)"
    }
}