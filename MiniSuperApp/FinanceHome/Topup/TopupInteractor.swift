//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by 60080252 on 2022/01/07.
//

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.

	func attachAddPaymentMethod()
	func detachAddPaymentMethod()

	func attachEnterAmount()
	func detachEnterAmount()
}

protocol TopupListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
	func topupDidClose()
}

protocol TopupInteractorDependency {
	var cardsOnFileRepository: CardOnFileRepository { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentationControllerDelegate {

    weak var router: TopupRouting?
    weak var listener: TopupListener?

	private let dependency: TopupInteractorDependency

	let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
	init(dependency: TopupInteractorDependency) {
		self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
		self.dependency = dependency
		super.init()
		self.presentationDelegateProxy.delegate = self
	}

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.

		if dependency.cardsOnFileRepository.cardOnFile.value.isEmpty {
			// 카드 추가 화면
			router?.attachAddPaymentMethod()
		} else {
			// 금액 입력 화면
			router?.attachEnterAmount()
		}

    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }

	func presentationControllerDidDismiss() {
		listener?.topupDidClose()
	}

	func addPaymentMethodDidTapClose() {
		router?.detachAddPaymentMethod()
		listener?.topupDidClose()
	}

	func addPaymentMethodDidAddCard(PaymentMethod: PaymentMethod) {

	}

	// EnterAmountListener
	func enterAmountDidTapClose() {
		router?.detachEnterAmount()
		listener?.topupDidClose()
	}
}
