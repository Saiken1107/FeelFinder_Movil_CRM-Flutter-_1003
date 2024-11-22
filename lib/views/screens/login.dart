// ignore_for_file: use_build_context_synchronously
import 'package:feelfinder_mobile/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Login extends StatefulWidget {
  const Login({
    super.key,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _scaffoldKey = GlobalKey();

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  //final UsuarioController _usuarioController = UsuarioController();

  bool _obscurePassword = true;

  final Box _boxLogin = Hive.box("login");

  @override
  Widget build(BuildContext context) {
    if (_boxLogin.get("loginStatus") ?? false) {
      return const MainScreen();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      // backgroundColor: Theme.of(context).colorScheme.background,
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 40,
              ),
              // Image.asset(
              //   'assets/icons/1024-libro.png',
              //   height: MediaQuery.of(context).size.height / 5,
              // ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Card(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(30.0, 0, 30, 0),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text(
                                    "Feel Finder CRM",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Inicie sesión",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            TextFormField(
                              controller: _controllerUsername,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: "Usuario",
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onEditingComplete: () =>
                                  _focusNodePassword.requestFocus(),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Por favor ingrese el nombre de usuario.";
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _controllerPassword,
                              focusNode: _focusNodePassword,
                              obscureText: _obscurePassword,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                labelText: "Contraseña",
                                prefixIcon: const Icon(Icons.password_outlined),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    icon: _obscurePassword
                                        ? const Icon(Icons.visibility_outlined)
                                        : const Icon(
                                            Icons.visibility_off_outlined)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Por favor ingrese la contraseña.";
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            const SizedBox(
                              height: 8,
                            ),
                            Column(children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_controllerUsername.text.trim() ==
                                          'admin' &&
                                      _controllerPassword.text.trim() ==
                                          'admin') {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const MainScreen();
                                        },
                                      ),
                                    );
                                  }
                                  /*
                          if (_formKey.currentState?.validate() ?? false) {
                            var usuario = await _usuarioController.obtenerUsuarioPorNombre(_controllerUsername.text.trim());

                            if (usuario.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  width: 200,
                                  backgroundColor: Colors.red.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  content: const Text(
                                    "El usuario no existe",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );

                              return;
                            }

                            if (usuario[0]['password'] != _controllerPassword.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  width: 200,
                                  backgroundColor: Colors.red.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  content: const Text(
                                    "La contraseña no es correcta",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );

                              return;
                            }

                            int idUsuario = usuario[0]['id'];

                            _boxLogin.put("loginStatus", true);
                            _boxLogin.put("tipoUsuario", "Local");
                            _boxLogin.put("userId", idUsuario);

                            if (usuario[0]['tutorial'] != 0) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const MainScreen();
                                  },
                                ),
                              );
                            } else {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => const Tutorial()),
                              );
                            }
                          }
                          */
                                },
                                child: Text(
                                  "Iniciar sesión",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Politicas(scaffoldKey: _scaffoldKey),
                            ]),
                          ]),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}

class Politicas extends StatelessWidget {
  const Politicas({
    super.key,
    required GlobalKey<FormState> scaffoldKey,
  }) : _scaffoldKey = scaffoldKey;

  final GlobalKey<FormState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          height: 30,
          alignment: AlignmentDirectional.center,
          child: const Text("Políticas de privacidad")),
      onTap: () {
        showModalBottomSheet(
          showDragHandle: true,
          context: _scaffoldKey.currentContext!,
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                top: 10,
                left: 15,
                right: 15,
                bottom: 10,
              ),
              child: ListView(
                clipBehavior: Clip.antiAlias,
                children: const [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          text: 'Política de privacidad',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text.rich(
                        textAlign: TextAlign.start,
                        TextSpan(
                          text:
                              'Fecha de entrada en vigencia: 19 de enero de 2024',
                          style: TextStyle(fontSize: 12),
                          children: [
                            TextSpan(
                              text:
                                  '\n\nEsta Política de Privacidad describe cómo se recopila, utiliza y comparte la información personal cuando utilizas la aplicación ("Click Asistencias"). Al utilizar la Aplicación, aceptas las prácticas descritas en esta política.',
                              style: TextStyle(fontSize: 12),
                            ),
                            TextSpan(
                              text: '\n\n1. Información Recopilada',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  """\n1.1 Información del Usuario: La Aplicación recopila información que nos proporcionas directamente, como tu nombre, dirección de correo electrónico, y cualquier otra información necesaria para el correcto funcionamiento de la aplicación.
                                  \n1.2 Información de Asistencia: La Aplicación recopila información sobre la asistencia de los usuarios, como la fecha y hora de registro, y cualquier otra información relevante para el seguimiento de la asistencia.
                                  \n1.3 Información del Dispositivo: Recopilamos información sobre el dispositivo que utilizas para acceder a la Aplicación, incluyendo el modelo del dispositivo, sistema operativo, identificadores únicos de dispositivo y configuración del sistema.""",
                              style: TextStyle(fontSize: 12),
                            ),
                            TextSpan(
                              text: '\n\n2. Uso de la Información',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  """\n2.1 Operación de la Aplicación: Utilizamos la información recopilada para operar, mantener y mejorar la funcionalidad de la Aplicación, incluyendo la toma de asistencias, la generación de informes y la administración de usuarios.
                                  \n2.2 Comunicación: Podemos utilizar tu dirección de correo electrónico para enviar notificaciones importantes relacionadas con la Aplicación, como actualizaciones de funciones, cambios en la política de privacidad o comunicaciones relacionadas con la cuenta.
                                  \n2.3 Análisis y Mejora: Analizamos la información recopilada para comprender cómo los usuarios interactúan con la Aplicación y mejorar continuamente la experiencia del usuario y la funcionalidad de la aplicación.""",
                              style: TextStyle(fontSize: 12),
                            ),
                            TextSpan(
                              text: '\n\n3. Seguridad',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  """\nImplementamos medidas de seguridad adecuadas para proteger la información recopilada contra el acceso no autorizado, la divulgación, la alteración y la destrucción.""",
                              style: TextStyle(fontSize: 12),
                            ),
                            TextSpan(
                              text:
                                  '\n\n4. Acceso y Control de la Información Personal',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  """\nProporcionamos a los usuarios acceso a su información personal y la posibilidad de corregirla, actualizarla o eliminarla según sea necesario. Puedes realizar estos cambios a través de la configuración de la cuenta en la Aplicación.""",
                              style: TextStyle(fontSize: 12),
                            ),
                            TextSpan(
                              text:
                                  '\n\n5. Cambios en la Política de Privacidad',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  """\nNos reservamos el derecho de actualizar esta política en cualquier momento. Te notificaremos sobre cambios significativos mediante notificaciones en la Aplicación o a través de otros medios.
                                  \nAl utilizar la Aplicación, aceptas los términos de esta Política de Privacidad. Si tienes alguna pregunta o inquietud sobre esta política, contáctanos a través de contacto@grupoinndex.com.""",
                              style: TextStyle(fontSize: 12),
                            ),
                            TextSpan(
                              text: """\n\nGrupo Inndex
                                  \ncontacto@grupoinndex.com 
                                  \nTel. +52 (477) 711 0077 c/30 Líneas""",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
