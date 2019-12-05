//
//  Quake+MKAnnotation.swift
//  Quakes
//
//  Created by Gi Pyo Kim on 12/5/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import MapKit

extension Quake: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        place
    }
    
    var subtitle: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = .current
        return "Magitude: \(magnitude)\n\(dateFormatter.string(from: time))"
    }
}
