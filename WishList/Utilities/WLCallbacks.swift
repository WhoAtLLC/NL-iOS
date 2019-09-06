//
//  WLCallbacks.swift
//  WishList
//
//  Created by Dharmesh on 04/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

typealias SuccessCallback = (Void, AnyObject) -> Void
typealias ErrorCallback = (Void, NSError) -> Void
typealias ProgressCallback = (Void, (total: Int, progress: Int)) -> Void
