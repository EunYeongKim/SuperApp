import ModernRIBs
import AddPaymentMethod
import FinanceRepository
import CombineUtil
import Topup

public protocol FinanceHomeDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
	var cardsOnFileRepository: CardOnFileRepository { get }
	var superPayRepository: SuperPayRepository { get }
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency, TopupDependency {

	var cardsOnFileRepository: CardOnFileRepository { dependency.cardsOnFileRepository }
	var superPayRepository: SuperPayRepository { dependency.superPayRepository }
	var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
	var topupBaseViewController: ViewControllable

  init(
	dependency: FinanceHomeDependency,
	topupBaseViewController: ViewControllable
  ) {
	  self.topupBaseViewController = topupBaseViewController
	  super.init(dependency: dependency)
  }
}

// MARK: - Builder

public protocol FinanceHomeBuildable: Buildable {
  func build(withListener listener: FinanceHomeListener) -> ViewableRouting
}

public final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
  
    public override init(dependency: FinanceHomeDependency) {
    super.init(dependency: dependency)
  }
  
    public func build(withListener listener: FinanceHomeListener) -> ViewableRouting {
	let viewController = FinanceHomeViewController()

    let component = FinanceHomeComponent(
		dependency: dependency,
		topupBaseViewController: viewController
	)

    let interactor = FinanceHomeInteractor(presenter: viewController)
    interactor.listener = listener

	  let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
	  let cardOnFileBuilder = CardOnFileDashboardBuilder(dependency: component)

	  let addPaymentBuilder = AddPaymentMethodBuilder(dependency: component)

	  let topupBuilder = TopupBuilder(dependency: component)

    return FinanceHomeRouter(
		interactor: interactor,
		viewController: viewController,
		superPayDashboardBuildable: superPayDashboardBuilder,
		cardOnFileDashboardBuildable: cardOnFileBuilder,
		addPaymentMethodBuildable: addPaymentBuilder,
		topupBuildable: topupBuilder
	)
  }
}
