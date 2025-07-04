import 'package:painel_velocitynet/modules/controller/controller.dart';
import 'package:painel_velocitynet/modules/extension/responsive.dart';
import 'package:painel_velocitynet/modules/navigation/navigation_abstract_factory.dart';
import 'package:painel_velocitynet/modules/navigation/panel_navigation.dart';

final controllerApp = AppController();
final responsive = Responsive();
final normalModePanelNavigation = NormalModePanelNavigation();
final wideModePanelNavigation = WideModePanelNavigation();
final wideModeNavigationFactory = WideModeNavigationAbstractFactory();
final normalModeNavigationFactory = NormalModeNavigationAbstractFactory();
final navigationFactoryProducer = NavigationFactoryProducer(responsive);
final navigationFactory = navigationFactoryProducer.getFactory();
