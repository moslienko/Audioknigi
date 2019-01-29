//
//  Extension+String.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 29/01/2019.
//  Copyright © 2019 Pavel Moslienko. All rights reserved.
//

import Foundation

extension String {
    //Локализация
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
}
