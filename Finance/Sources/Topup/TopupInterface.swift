//
//  TopupInterface.swift
//  
//
//  Created by SEUNGHA on 2022/02/09.
//

import Foundation
import ModernRIBs

public protocol TopupBuildable: Buildable {
    func build(withListener listener: TopupListener) -> Routing
}

public protocol TopupListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func topupDidClose()
    func topupDidFinish()
}
