//
//  Glover.swift
//  Glover
//
//  Created by Sebastian Owodzin on 12/03/2016.
//  Copyright © 2016 mobiletoolkit.org. All rights reserved.
//

import Foundation

public let errorDomain = "org.mobiletoolkit.ios.glover"

public var manager: Manager!

public func initialize(configuration: Configuration) {
    manager = Manager(configuration: configuration)
}
