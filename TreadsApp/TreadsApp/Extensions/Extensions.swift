//
//  Extensions.swift
//  TreadsApp
//
//  Created by Alex on 1/10/18.
//  Copyright © 2018 Alex. All rights reserved.
//

import Foundation

extension Double {
    func metersToMiles(to places: Int) -> Double{
        let divisor = pow(10.0, Double(places))
        return ((self / 1609.34) * divisor).rounded() / divisor
    }
}
