//
//  CMTime + String Format.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/7/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//

import AVKit

extension CMTime {
    var string: String {
        let sInt = Int(seconds)
        let s: Int = sInt % 60
        let m: Int = (sInt / 60) % 60
        return String(format: "%02d:%02d", m, s)
    }
}
