//
//  AddPaymentMethodInterface.swift
//  
//
//  Created by SEUNGHA on 2022/02/09.
//

import Foundation
import ModernRIBs
import FinanceEntity
import RIBsUtil

public protocol AddPaymentMethodBuildable: Buildable {
    func build(
        withListener listener: AddPaymentMethodListener,
        closeButtonType: DismissButtonType
    ) -> ViewableRouting
}

public protocol AddPaymentMethodListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func addPaymentMethodDidTapClose()
    func addPaymentMethodDidAddCard(PaymentMethod: PaymentMethod)
}
