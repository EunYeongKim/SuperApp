//
//  CardOnFileInteractor.swift
//  MiniSuperApp
//
//  Created by 60080252 on 2022/01/10.
//

import ModernRIBs
import FinanceEntity

protocol CardOnFileRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFilePresentable: Presentable {
    var listener: CardOnFilePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.

	func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
	func cardOnFileDidTapClose()
	func cardOnFileDidTapAddCard()
	func cardOnFileDidSelect(at index: Int)
}

final class CardOnFileInteractor: PresentableInteractor<CardOnFilePresentable>, CardOnFileInteractable, CardOnFilePresentableListener {

    weak var router: CardOnFileRouting?
    weak var listener: CardOnFileListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.

	private let paymentMethods: [PaymentMethod]

    init(
		presenter: CardOnFilePresentable,
		paymentMethods: [PaymentMethod]
	) {
		self.paymentMethods = paymentMethods
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.

		presenter.update(with: paymentMethods.map(PaymentMethodViewModel.init))
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }

	// CardOnFilePresentableListener
	func didTapClose() {
		listener?.cardOnFileDidTapClose()
	}

	func didSelectItem(at index: Int) {
		if index >= paymentMethods.count {
			// 카드추가 버튼
			listener?.cardOnFileDidTapAddCard()
		} else {
			listener?.cardOnFileDidSelect(at: index)
		}
	}
}
