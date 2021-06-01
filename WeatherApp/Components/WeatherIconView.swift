//
//  WeatherIconView.swift
//  WeatherApp
//
//  Created by Gondai Mgano on 1/6/2021.
//  Copyright © 2021 Gondai Mgano. All rights reserved.
//

import UIKit

class WeatherIconView: UIImageView {

  
    
    override func layoutSubviews() {
       image = image?.withRenderingMode(.alwaysTemplate)
    }
    
   
    
}
