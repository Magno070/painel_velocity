import 'package:painel_velocitynet/modules/extension/responsive.dart';
import 'package:painel_velocitynet/modules/injection/injection.dart';
import 'package:painel_velocitynet/modules/navigation/panel_navigation.dart';

abstract class NavigationAbstractFactory {
  IPanelNavigation get panelNavigation;
}

class NavigationFactoryProducer {
  final Responsive _responsive;

  NavigationFactoryProducer(this._responsive);

  NavigationAbstractFactory getFactory() {
    return _responsive.isWebMode
        ? wideModeNavigationFactory
        : normalModeNavigationFactory;
  }
}

class WideModeNavigationAbstractFactory implements NavigationAbstractFactory {
  @override
  IPanelNavigation get panelNavigation {
    return wideModePanelNavigation;
  }
}

class NormalModeNavigationAbstractFactory implements NavigationAbstractFactory {
  @override
  IPanelNavigation get panelNavigation {
    return normalModePanelNavigation;
  }
}
