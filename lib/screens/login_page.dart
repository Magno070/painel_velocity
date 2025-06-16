import 'package:flutter/material.dart';
import 'package:velocity_admin_painel/public/widgets/login_widget.dart';
import 'package:velocity_admin_painel/public/widgets/recuperar_senha.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _currentPage = 0;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _recEmailController;
  late TextEditingController _recCodeController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _recEmailController = TextEditingController();
    _recCodeController = TextEditingController();
  }

  void _setPage(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  Widget _buildInnerContent() {
    switch (_currentPage) {
      //* ////////////////////////////////////////////////// child 1 /////////////////////////////////////////////

      case 0:
        return LoginWidget(
          usernameController: _usernameController,
          passwordController: _passwordController,
          setFunction: () => _setPage(1),
        );

      //* ////////////////////////////////////////////////// child 2 /////////////////////////////////////////////

      case 1:
        return RecEmail(
          recEmailController: _recEmailController,
          enviarFunction: () => _setPage(2),
          sairFunction: () => _setPage(0),
        );

      //* ////////////////////////////////////////////////// child 3 /////////////////////////////////////////////

      case 2:
        return RecCodigo(
          recCodeController: _recCodeController,
          confirmarFunction: () => _setPage(0),
          cancelarFunction: () => _setPage(1),
        );
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Container(
          decoration: BoxDecoration(color: Colors.transparent),
          height: 600,
          width: 600,
          padding: EdgeInsets.fromLTRB(30, 40, 30, 40),
          child: _buildInnerContent(),
        ),
      ),
    );
  }
}
