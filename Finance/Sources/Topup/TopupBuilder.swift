//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by 60080252 on 2022/01/07.
//

import ModernRIBs
import FinanceRepository
import AddPaymentMethod
import CombineUtil
import FinanceEntity

public protocol TopupDependency: Dependency {
    var topupBaseViewController: ViewControllable { get }
	var cardsOnFileRepository: CardOnFileRepository { get }
	var superPayRepository: SuperPayRepository { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, AddPaymentMethodDependency, EnterAmountDependency, CardOnFileDependency {
	var cardsOnFileRepository: CardOnFileRepository { dependency.cardsOnFileRepository }
	var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { paymentMethodStream }
	var superPayRepository: SuperPayRepository { dependency.superPayRepository }

    fileprivate var topupBaseViewController: ViewControllable { dependency.topupBaseViewController }

	let paymentMethodStream: CurrentValuePublisher<PaymentMethod>

	init(
		dependency: TopupDependency,
		paymentMethodStream: CurrentValuePublisher<PaymentMethod>
	) {
		self.paymentMethodStream = paymentMethodStream
		super.init(dependency: dependency)
	}
}

// MARK: - Builder

public protocol TopupBuildable: Buildable {
    func build(withListener listener: TopupListener) -> Routing
}

public final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {

    public override init(dependency: TopupDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: TopupListener) -> Routing {
		let paymentMethodStream = CurrentValuePublisher(PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false))

        let component = TopupComponent(
			dependency: dependency,
			paymentMethodStream: paymentMethodStream
		)
        let interactor = TopupInteractor(dependency: component)
        interactor.listener = listener

		let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
		let enterAmountBuilder = EnterAmountBuilder(dependency: component)
		let cardOnFileBuilder = CardOnFileBuilder(dependency: component)

        return TopupRouter(
			interactor: interactor,
			viewController: component.topupBaseViewController,
			addPaymentMethodBuildable: addPaymentMethodBuilder,
			enterAmountBuildable: enterAmountBuilder,
			cardOnFileBuildable: cardOnFileBuilder
		)
    }
}
