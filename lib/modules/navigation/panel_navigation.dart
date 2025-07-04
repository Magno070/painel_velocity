import 'package:flutter/material.dart';
import 'package:painel_velocitynet/modules/config/config.dart';
import 'package:painel_velocitynet/modules/curriculos/curriculos.dart';
import 'package:painel_velocitynet/modules/description/description.dart';
import 'package:painel_velocitynet/modules/entity/menu_entity.dart';
import 'package:painel_velocitynet/modules/extension/responsive.dart';
import 'package:painel_velocitynet/modules/navigation/navigation.dart';
import 'package:painel_velocitynet/modules/offer/widget/offer.dart';
import 'package:painel_velocitynet/modules/slider/widget/slide.dart';
import 'package:painel_velocitynet/modules/tv/widget/tv.dart';
import 'package:painel_velocitynet/modules/exit/exit.dart';
import 'package:painel_velocitynet/modules/questions/questions.dart';
import 'package:painel_velocitynet/modules/footer/footer.dart';

abstract class IPanelNavigation {
  Future<T?> toPanel<T extends Object?>(String roomName,
      {String? idPartner, String? idCompany});
}

class WideModePanelNavigation extends Navigation implements IPanelNavigation {
  final key = GlobalKey<NavigatorState>();
  @override
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SliderPage.route:
        return createAnimatedRoute(
          SliderPage(
            menu: settings.arguments as MenuEntity,
          ),
        );
      case PlansConfig.route:
        return createAnimatedRoute(
          PlansConfig(
            menu: settings.arguments as MenuEntity,
          ),
        );
      case Curriculos.route:
        return createAnimatedRoute(Curriculos(
          menu: settings.arguments as MenuEntity,
        ));
      case Description.route:
        return createAnimatedRoute(
          Description(
            menu: settings.arguments as MenuEntity,
          ),
        );
      case Offer.route:
        return createAnimatedRoute(
          Offer(
            menu: settings.arguments as MenuEntity,
          ),
        );
      case TV.route:
        return createAnimatedRoute(
          TV(
            menu: settings.arguments as MenuEntity,
          ),
        );
      case Questions.route:
        return createAnimatedRoute(
          Questions(
            menu: settings.arguments as MenuEntity,
          ),
        );
      case Footer.route:
        return createAnimatedRoute(
          Footer(
            menu: settings.arguments as MenuEntity,
          ),
        );
      case Exit.route:
        return createAnimatedRoute(
          Exit(
            menu: settings.arguments as MenuEntity,
          ),
        );
      // case PartnerProfile.route:
      //   return createAnimatedRoute(
      //     PartnerProfile(
      //       menu: settings.arguments as MenuEntity,
      //     ),
      //   );
      // case IdleDashboard.route:
      //   return createAnimatedRoute(
      //     const IdleDashboard(),
      //   );
      case IdleSlide.route:
        return createAnimatedRoute(
          const IdleSlide(),
        );
      default:
    }
    return null;
  }

  @override
  Future<T?> toPanel<T extends Object?>(String panelName,
      {String? idPartner, String? idCompany}) {
    return key.currentState!.pushReplacementNamed(
      panelName,
      arguments: MenuEntity(
          name: panelName, idPartner: idPartner, idCompany: idCompany),
    );
  }
}

class NormalModePanelNavigation implements IPanelNavigation {
  @override
  Future<T?> toPanel<T extends Object?>(String roomName,
      {String? idPartner, String? idCompany}) {
    return materialNavigationKey.currentState!.context
        .to(SliderPage(menu: MenuEntity(name: 'Helelo')));
  }
}
