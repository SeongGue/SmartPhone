//
//  GetDate.swift
//  MovieApp
//
//  Created by son on 2017. 5. 29..
//  Copyright © 2017년 SonSeongGue. All rights reserved.
//

import Foundation
import UIKit

let todaysDate = NSDate()
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyyMMdd"
let DateInFormat = dateFormatter.string(from: todaysDate as Date)
