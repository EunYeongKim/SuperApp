//
//  AdaptivePresentationControllerDelegate.swift
//  MiniSuperApp
//
//  Created by 60080252 on 2022/01/05.
//

import UIKit

/// delegate이기때문에 weak를 해줘야해서 AnyObject를 받도록 함
protocol AdaptivePresentationControllerDelegate: AnyObject {
	func presentationControllerDidDismiss()
}

/// 이 객체가 UIAdaptive를 대신해서 받는 객체
final class AdaptivePresentationControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
	weak var delegate: AdaptivePresentationControllerDelegate?

	func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
		delegate?.presentationControllerDidDismiss()
	}
}
