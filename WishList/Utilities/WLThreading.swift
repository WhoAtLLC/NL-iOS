//
//  WLThreading.swift
//  WishList
//
//  Created by Dharmesh on 04/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class WLThreading: NSObject {
    
    class func workerDispatchQueue() -> DispatchQueue {
        return DispatchQueue(label: "com.wishlist.worker.queue", attributes: DispatchQueue.Attributes.concurrent);
    }
    
    class func apiDispatchQueue() -> DispatchQueue {
        return DispatchQueue(label: "com.wishlist.api.queue", attributes: DispatchQueue.Attributes.concurrent);
    }
    
    class func main(_ main: @escaping () -> Void) {
        DispatchQueue.main.async(execute: {
            main();
        });
    }
    
    class func background(_ background: @escaping () -> Void) {
        let wa_worker_queue = self.workerDispatchQueue();
        
        autoreleasepool {
            wa_worker_queue.async(execute: {
                background();
            });
        }
    }
}
