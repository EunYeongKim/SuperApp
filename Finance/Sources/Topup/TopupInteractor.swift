//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by 60080252 on 2022/01/07.
//

import ModernRIBs
import RIBsUtil
import FinanceEntity
import FinanceRepository
import CombineUtil
import SuperUI
import AddPaymentMethod

protocol TopupRouting: Routing {
    func cleanupViews()
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.

	func attachAddPaymentMethod(closeButtonType: DismissButtonType)
	func detachAddPaymentMethod()

	func attachEnterAmount()
	func detachEnterAmount()

	func attachCardOnFile(paymentMethods: [PaymentMethod])
	func detachCardOnFile()

	func popToRoot()
}

public protocol TopupListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
	func topupDidClose()
	func topupDidFinish()
}

protocol TopupInteractorDependency {
	var cardsOnFileRepository: CardOnFileRepository { get }
	var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentationControllerDelegate {

    weak var router: TopupRouting?
    weak var listener: TopupListener?

	private let dependency: TopupInteractorDependency

	let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy

	private var paymentMethods: [PaymentMethod] {
		dependency.cardsOnFileRepository.cardOnFile.value
	}
	private var isEnterAmountRoot: Bool = false

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

		if let card = dependency.cardsOnFileRepository.cardOnFile.value.first {
			// 금액 입력 화면
			isEnterAmountRoot = true
			dependency.paymentMethodStream.send(card)
			router?.attachEnterAmount()
		} else {
			// 카드 추가 화면
			isEnterAmountRoot = false
			router?.attachAddPaymentMethod(closeButtonType: .close)
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
		if !isEnterAmountRoot {
			listener?.topupDidClose()
		}
	}

	func addPaymentMethodDidAddCard(PaymentMethod: PaymentMethod) {
		dependency.paymentMethodStream.send(PaymentMethod)

		if isEnterAmountRoot {
			router?.popToRoot()
		} else {
			isEnterAmountRoot = true
			router?.attachEnterAmount()
		}
	}

	// EnterAmountListener
	func enterAmountDidTapClose() {
		router?.detachEnterAmount()
		listener?.topupDidClose()
	}

	func enterAmountDidTapPaymentMethod() {
		router?.attachCardOnFile(paymentMethods: paymentMethods)
	}

	func enterAmountDidFinishTopup() {
		listener?.topupDidFinish()
	}

	// CardOnFileListener
	func cardOnFileDidTapClose() {
		router?.detachCardOnFile()
	}

	func cardOnFileDidTapAddCard() {
		router?.attachAddPaymentMethod(closeButtonType: .back)
	}

	func cardOnFileDidSelect(at index: Int) {
		if let selected = paymentMethods[safe: index] {
			dependency.paymentMethodStream.send(selected)
		}
		router?.detachCardOnFile()
	}
}
