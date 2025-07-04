import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:painel_velocitynet/modules/login/auth_maneger.dart';
import 'package:painel_velocitynet/modules/login/auth_service.dart';
import 'package:painel_velocitynet/modules/login/api_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controlerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  late AuthService authService = AuthService(
      controlerEmail: controlerEmail,
      controllerPassword: controllerPassword,
      context: context);
  late ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
  }

  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff212121),
      body: SizedBox(
        height: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 500,
              width: 400,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Text(
                          'Login',
                          style: GoogleFonts.getFont('Poppins',
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 30),
                        ),
                      ],
                    ),
                    Container(
                      width: 50,
                      height: 8,
                      color: const Color(0xff46964A),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'E-mail',
                          style: GoogleFonts.getFont('Poppins',
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xFFEBEBEB),
                          ),
                          width: double.infinity,
                          child: TextField(
                            controller: controlerEmail,
                            // obscureText: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 20),
                              hintStyle: GoogleFonts.getFont('Poppins',
                                  color: const Color(0xff969696),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Senha',
                          style: GoogleFonts.getFont('Poppins',
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBEBEB),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          width: double.infinity,
                          height: 45,
                          child: TextFormField(
                            controller: controllerPassword,
                            obscureText: isVisible == true ? true : false,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                left: 20,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                  icon: isVisible != true
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off)),
                              hintStyle: GoogleFonts.getFont('Poppins',
                                  color: const Color(0xff969696),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          height: 60,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              backgroundColor: WidgetStateProperty.all(
                                  const Color(0xff46964A)),
                            ),
                            onPressed: () async {
                              await authService.autentication();
                              final token = await AuthManager.getToken();
                              if (token != null) {
                                ApiService.fazerRequisicaoAutenticada(token);
                              }
                            },
                            child: Text(
                              'Entrar',
                              style: GoogleFonts.getFont('Poppins',
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
