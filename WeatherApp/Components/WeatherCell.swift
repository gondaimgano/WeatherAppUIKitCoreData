//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Gondai Mgano on 31/5/2021.
//  Copyright © 2021 Gondai Mgano. All rights reserved.
//

import Foundation
import UIKit

class WeatherCell : UITableViewCell{
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var dayOfTheWeek: UILabel!
   
    @IBOutlet weak var timeOfDayLabel: UILabel!
    
    
}
