import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_admin_painel/models/screen_menu.dart';

class SlidesPage extends StatefulWidget {
  const SlidesPage({super.key});

  @override
  State<SlidesPage> createState() => _SlidesPageState();
}

class _SlidesPageState extends State<SlidesPage> {
  // Lista de URLs das imagens, agora como variável de estado
  final List<String> _imageUrls = [
    'https://picsum.photos/seed/1/400/300', // Exemplo de URL de imagem
    'https://picsum.photos/seed/2/400/300',
    'https://picsum.photos/seed/3/400/300',
    'https://picsum.photos/seed/4/400/300',
    'https://picsum.photos/seed/5/400/300',
    'https://picsum.photos/seed/6/400/300',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenMenu(
        selectedItemId: 'SLIDES',
        pageTitleText: 'GERENCIAMENTO DE SLIDES',
        newChild: Container(
          color: Colors.grey[850],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
              ),
              itemCount: _imageUrls.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Flexible(
                            flex: 2,
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.note_add_outlined,
                                color: Colors.white,
                                size: 100,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: SizedBox(
                                height: 80,
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        12,
                                      ), // Bordas arredondadas
                                    ),
                                  ),
                                  onPressed: () {
                                    _imageUrls.add(
                                      'https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/400/300',
                                    );
                                    setState(() {
                                      _imageUrls;
                                    });
                                  },
                                  child: Text(
                                    'Adicionar slide',
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Flexible(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(_imageUrls[index - 1]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: SizedBox(
                                height: 80,
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _imageUrls.removeAt(index - 1);
                                    });
                                  },
                                  child: Text(
                                    'Excluir',
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
