//
//  Localization.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 19/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
}
