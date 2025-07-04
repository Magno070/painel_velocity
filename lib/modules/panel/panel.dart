import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:painel_velocitynet/modules/extension/responsive.dart';
import 'package:painel_velocitynet/modules/injection/injection.dart';
import 'package:painel_velocitynet/modules/panel/components/menus.dart';
import 'package:painel_velocitynet/modules/slider/widget/slide.dart';

class Panel extends StatefulWidget {
  const Panel({super.key});

  @override
  MyTabbedPanelState createState() => MyTabbedPanelState();
}

class MyTabbedPanelState extends State<Panel> {
  final PageController _pageController = PageController();

  double width(BuildContext context) {
    if (context.width < 570) {
      return context.width * 0.8;
    }
    if (context.width < 1200) {
      return context.width / 3;
    } else {
      return context.width / 4;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: controllerApp,
        builder: (context, value, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
                title: Text(
                  "Painel - Velocitynet",
                  style: GoogleFonts.getFont('Poppins',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                backgroundColor: Colors.black),
            body: responsive.isWebMode
                ? Row(
                    children: [
                      SizedBox(
                        width: context.width * 0.13,
                        child: const Menus(),
                      ),
                      const VerticalDivider(width: 0),
                      Expanded(
                        flex: 3,
                        child: Navigator(
                          key: wideModePanelNavigation.key,
                          onGenerateRoute:
                              wideModePanelNavigation.onGenerateRoute,
                          initialRoute: IdleSlide.route,
                        ),
                      ),
                    ],
                  )
                : const Menus(),
          );
        });
  }
}
    // return Scaffold(
    //   backgroundColor: Colors.black,
    //   appBar: AppBar(
    //       title: Text(
    //         "Painel - Velocitynet",
    //         style: GoogleFonts.getFont('Poppins',
    //             color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
    //       ),
    //       backgroundColor: Colors.black),
    //   body: Padding(
    //     padding: const EdgeInsets.only(
    //       right: 10,
    //     ),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         SizedBox(
    //           // width: MediaQuery.of(context).size.width < 1300 ? 200 : 350,
    //           // height: 800,
    //           child: NavigationRail(
    //             indicatorColor: Colors.transparent,
    //             backgroundColor: const Color(
    //               0xff181919,
    //             ),
    //             extended: true,
    //             selectedIndex: _currentIndex,
    //             groupAlignment: BorderSide.strokeAlignInside,
    //             labelType: NavigationRailLabelType.none,
    //             onDestinationSelected: (int index) {
    //               setState(() {
    //                 _currentIndex = index;
    //                 _pageController.animateToPage(
    //                   index,
    //                   duration: const Duration(milliseconds: 300),
    //                   curve: Curves.ease,
    //                 );
    //               });
    //             },
    //             destinations: [
    //               NavigationRailDestination(
    //                 padding: const EdgeInsets.only(bottom: 10, top: 10),
    //                 icon: Image.asset(
    //                   'images/slides.png',
    //                   color: Colors.white,
    //                   width: 30,
    //                 ),

    //                 // PhosphorIcon(
    //                 //   PhosphorIcons.regular.slideshow,
    //                 //   size: 25,
    //                 //   color: const Color(0xff969696),
    //                 // ),

    //                 label: Text(
    //                   'Slide',
    //                   style: GoogleFonts.getFont(
    //                     'Poppins',
    //                     color: Colors.white,
    //                     fontSize: 18,
    //                   ),
    //                 ),
    //               ),
    //               NavigationRailDestination(
    //                   padding: const EdgeInsets.only(bottom: 10, top: 10),
    //                   icon: const Icon(
    //                     Icons.settings,
    //                     size: 25,
    //                     color: Colors.white,
    //                   ),
    //                   // icon: PhosphorIcon(
    //                   //   PhosphorIcons.regular.globe,
    //                   //   size: 25,
    //                   //   color: const Color(0xff969696),
    //                   // ),
    //                   label: Text(
    //                     'Configurações',
    //                     overflow: TextOverflow.ellipsis,
    //                     style: GoogleFonts.getFont(
    //                       'Poppins',
    //                       color: Colors.white,
    //                       fontSize: 18,
    //                     ),
    //                   )),
    //               NavigationRailDestination(
    //                   padding: const EdgeInsets.only(bottom: 10, top: 10),
    //                   icon: Image.asset(
    //                     'images/descricao.png',
    //                     color: Colors.white,
    //                     width: 20,
    //                   ),
    //                   // icon: PhosphorIcon(
    //                   //   PhosphorIcons.regular.scroll,
    //                   //   size: 25,
    //                   //   color: const Color(0xff969696),
    //                   // ),
    //                   label: Text(
    //                     'Descrição',
    //                     style: GoogleFonts.getFont(
    //                       'Poppins',
    //                       color: Colors.white,
    //                       fontSize: 18,
    //                     ),
    //                   )),
    //               NavigationRailDestination(
    //                   padding: const EdgeInsets.only(bottom: 10, top: 10),
    //                   icon: Image.asset(
    //                     'images/ofertas.png',
    //                     color: Colors.white,
    //                     width: 20,
    //                   ),
    //                   // icon: PhosphorIcon(
    //                   //   PhosphorIcons.regular.tag,
    //                   //   size: 25,
    //                   //   color: const Color(0xff969696),
    //                   // ),
    //                   label: Text(
    //                     'Ofertas',
    //                     style: GoogleFonts.getFont(
    //                       'Poppins',
    //                       color: Colors.white,
    //                       fontSize: 20,
    //                     ),
    //                   )),
    //               NavigationRailDestination(
    //                 padding: const EdgeInsets.only(bottom: 10, top: 10),
    //                 // icon: Image.asset('images/ofertas.png', color: Colors.white, width: 30,),
    //                 icon: PhosphorIcon(
    //                   PhosphorIcons.regular.televisionSimple,
    //                   color: Colors.white,
    //                   size: 25,
    //                 ),
    //                 label: Text(
    //                   'TV',
    //                   style: GoogleFonts.getFont(
    //                     'Poppins',
    //                     color: Colors.white,
    //                     fontSize: 18,
    //                   ),
    //                 ),
    //               ),
    //               NavigationRailDestination(
    //                 padding: const EdgeInsets.only(bottom: 10, top: 10),
    //                 icon: Image.asset(
    //                   'images/perguntas.png',
    //                   color: Colors.white,
    //                   width: 20,
    //                 ),
    //                 // icon: PhosphorIcon(
    //                 //   PhosphorIcons.regular.chatCircleDots,
    //                 //   color: const Color(0xff969696),
    //                 //   size: 25,
    //                 // ),
    //                 label: Text(
    //                   'Perguntas',
    //                   style: GoogleFonts.getFont(
    //                     'Poppins',
    //                     color: Colors.white,
    //                     fontSize: 18,
    //                   ),
    //                 ),
    //               ),
    //               NavigationRailDestination(
    //                 padding: const EdgeInsets.only(bottom: 10, top: 10),
    //                 icon: Image.asset(
    //                   'images/rodape.png',
    //                   color: Colors.white,
    //                   width: 20,
    //                 ),
    //                 // icon: PhosphorIcon(
    //                 //   PhosphorIcons.regular.stackSimple,
    //                 //   color: const Color(0xff969696),
    //                 //   size: 25,
    //                 // ),
    //                 label: Text(
    //                   'Rodapé',
    //                   style: GoogleFonts.getFont(
    //                     'Poppins',
    //                     color: Colors.white,
    //                     fontSize: 18,
    //                   ),
    //                 ),
    //               ),
    //               NavigationRailDestination(
    //                 padding: const EdgeInsets.only(bottom: 10, top: 10),
    //                 icon: PhosphorIcon(PhosphorIcons.regular.signOut,
    //                     size: 25, color: Colors.red),
    //                 label: Text(
    //                   'Sair',
    //                   style: GoogleFonts.getFont(
    //                     'Poppins',
    //                     color: Colors.red,
    //                     fontSize: 18,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Expanded(
    //           child: PageView(
    //             controller: _pageController,
    //             onPageChanged: (index) {
    //               setState(() {
    //                 _currentIndex = index;
    //               });
    //             },
    //             children: const [
    //               // SlidePlans(),
    //               Slide(),
    //               // Plans(),
    //               PlansConfig(),
    // Description(),
    // Ofertas(),
    // TV(),
    // Perguntas(),
    // Footer(),
    // Exit(),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );