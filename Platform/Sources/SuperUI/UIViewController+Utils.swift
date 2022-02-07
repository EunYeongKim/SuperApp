//
//  UIViewController+Utils.swift
//  MiniSuperApp
//
//  Created by 60080252 on 2022/01/10.
//

import UIKit
import RIBsUtil

public extension UIViewController {
	func setupNavigationItem(with buttonType: DismissButtonType, target: Any?, action: Selector?) {
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: buttonType.iconSystemName,
						   withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)),
			style: .plain,
			target: target,
			action: action
		)
	}
}
