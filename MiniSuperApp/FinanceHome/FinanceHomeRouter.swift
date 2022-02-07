import ModernRIBs
import AddPaymentMethod
import SuperUI

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener, AddPaymentMethodListener, TopupListener {
  var router: FinanceHomeRouting? { get set }
  var listener: FinanceHomeListener? { get set }

	/// Interactor는 protocol 타입이기 때문에 값을 여기에서 정의해줘야함
	var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol FinanceHomeViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
	func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
  
	private let superPayDashboardBuildable: SuperPayDashboardBuildable
	private var superPayRouting: Routing?

	private let cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
	private var cardOnFileRouting: Routing?

	private let addPaymentMethodBuildable: AddPaymentMethodBuildable
	private var addPaymentRouting: Routing?

	private let topupBuildable: TopupBuildable
	private var topupRouting: Routing?

  init(
	interactor: FinanceHomeInteractable,
	viewController: FinanceHomeViewControllable,
	superPayDashboardBuildable: SuperPayDashboardBuildable,
	cardOnFileDashboardBuildable: CardOnFileDashboardBuildable,
	addPaymentMethodBuildable: AddPaymentMethodBuildable,
	topupBuildable: TopupBuildable
  ) {
	  self.topupBuildable = topupBuildable
	  self.addPaymentMethodBuildable = addPaymentMethodBuildable
	  self.superPayDashboardBuildable = superPayDashboardBuildable
	  self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }

	func attachSuperPayDashboard() {
		if superPayRouting != nil {
			return
		}

		let router = superPayDashboardBuildable.build(withListener: interactor)

		let dashboard = router.viewControllable
		viewController.addDashboard(dashboard)

		self.superPayRouting = router
		attachChild(router)
	}

	func attachCardOnFileDashboard() {
		if cardOnFileRouting != nil {
			return
		}

		let router = cardOnFileDashboardBuildable.build(withListener: interactor)

		let dashboard = router.viewControllable
		viewController.addDashboard(dashboard)

		self.cardOnFileRouting = router
		attachChild(router)
	}

	func attachAddPaymentMethod() {
		if addPaymentRouting != nil {
			return
		}

		let router = addPaymentMethodBuildable.build(
			withListener: interactor,
			closeButtonType: .close
		)

		/// navigation bar가 필요하기 때문에 navigation bar에 한번 싸서 present
		let navigation = NavigationControllerable(root: router.viewControllable)
		navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
		viewControllable.present(navigation, animated: true, completion: nil)

		addPaymentRouting = router
		attachChild(router)
	}

	func detachAddPaymentMethod() {
		guard let router = addPaymentRouting else {
			return
		}

		viewControllable.dismiss(completion: nil)

		detachChild(router)
		addPaymentRouting = nil
	}

	func attachTopup() {
		if topupRouting != nil {
			return
		}

		let router = topupBuildable.build(withListener: interactor)
		topupRouting = router
		attachChild(router)
	}

	func detachTopup() {
		guard let router = topupRouting else {
			return
		}
		detachChild(router)
		topupRouting = nil
	}
}
