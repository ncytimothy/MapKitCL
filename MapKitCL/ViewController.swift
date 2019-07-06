//
//  ViewController.swift
//  MapKitCL
//
//  Created by Tim Ng on 7/6/19.
//  Copyright © 2019 Tim Ng. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
    }


}

