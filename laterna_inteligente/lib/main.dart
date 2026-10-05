import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lanterna Inteligente',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppCores.amarelo,
          brightness: Brightness.dark,
        ),
      ),
      home: const LanternaScreen(),
    );
  }
}

class AppCores {
  static const amarelo = Color(0xFFFFD700);
  static const fundo = Color(0xFF0D0D0D);
  static const cinzaEscuro = Color(0xFF1A1A1A);
  static const cinzaMedio = Color(0xFF2C2C2C);
  static const cinzaTexto = Color(0xFF888888);
  static const roxo = Color(0xFFAB47BC);
}

class LanternaScreen extends StatefulWidget {
  const LanternaScreen({super.key});

  @override
  State<LanternaScreen> createState() => _LanternaScreenState();
}

class _LanternaScreenState extends State<LanternaScreen> {
  bool _lanternaLigada = false;
  bool _modoAutomatico = false;

  // Intensidade da luz
  double _intensidade = 1.0;

  // Cor atual da luz
  Color _corLuz = Colors.white;

  // Melhoria do desafio
  int _vezesLigada = 0;

  // LIGAR / DESLIGAR

  Future<void> _alternarLanterna() async {
    setState(() {
      _lanternaLigada = !_lanternaLigada;

      if (_lanternaLigada) {
        _vezesLigada++;
      }
    });

    // Tenta controlar o flash físico do celular
    try {
      if (_lanternaLigada) {
        await TorchLight.enableTorch();
      } else {
        await TorchLight.disableTorch();
      }
    } catch (e) {
      print('Lanterna física não disponível: $e');
    }
  }

  // MODO AUTOMÁTICO

  void _alternarModoAutomatico(bool valor) {
    setState(() {
      _modoAutomatico = valor;
    });
  }

  // INTENSIDADE

  void _alterarIntensidade(double valor) {
    setState(() {
      _intensidade = valor;
    });
  }

  // COR

  void _alterarCor(Color cor) {
    setState(() {
      _corLuz = cor;
    });
  }

  // TELA PRINCIPAL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _lanternaLigada ? _corDaLuz() : AppCores.fundo,

      body: SafeArea(
        child: AnimatedContainer(
          duration:
              const Duration(milliseconds: 400),

          width: double.infinity,
          height: double.infinity,

          color: _lanternaLigada
              ? _corDaLuz()
              : AppCores.fundo,

          child: AnimatedSwitcher(
            duration:
                const Duration(milliseconds: 300),

            child: _lanternaLigada
                ? _telaDeLuz()
                : _telaNormal(),
          ),
        ),
      ),
    );
  }

  // CALCULA A COR DA LUZ

  Color _corDaLuz() {
    return Color.lerp(
      Colors.black,
      _corLuz,
      _intensidade,
    )!;
  }

  // TELA DE LUZ

  Widget _telaDeLuz() {
    return GestureDetector(
      key: const ValueKey('luz'),

      onTap: _alternarLanterna,

      child: Container(
        width: double.infinity,
        height: double.infinity,

        color: _corDaLuz(),

        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              Icon(
                Icons.flashlight_on,

                size: 100,

                color: _intensidade > 0.5
                    ? Colors.black
                    : Colors.white,
              ),

              const SizedBox(height: 30),

              Text(
                'LANTERNA LIGADA',

                style: TextStyle(
                  color: _intensidade > 0.5
                      ? Colors.black
                      : Colors.white,

                  fontSize: 24,

                  fontWeight:
                      FontWeight.bold,

                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                'Intensidade: '
                '${(_intensidade * 100).round()}%',

                style: TextStyle(
                  color: _intensidade > 0.5
                      ? Colors.black54
                      : Colors.white70,

                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Toque na tela para desligar',

                style: TextStyle(
                  color: _intensidade > 0.5
                      ? Colors.black54
                      : Colors.white70,

                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TELA NORMAL

  Widget _telaNormal() {
    return Column(
      key: const ValueKey('normal'),

      children: [

        // TOPO

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [
              const Text(
                '🔦 Lanterna',

                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      AppCores.cinzaMedio,

                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: const Text(
                  'DESLIGADA',

                  style: TextStyle(
                    color:
                        AppCores.cinzaTexto,

                    fontWeight:
                        FontWeight.bold,

                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        // MODO AUTOMÁTICO

        Container(
          margin:
              const EdgeInsets.symmetric(
            horizontal: 20,
          ),

          padding:
              const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: _modoAutomatico
                ? AppCores.roxo
                    .withOpacity(0.25)
                : AppCores.cinzaEscuro,

            borderRadius:
                BorderRadius.circular(16),

            border: Border.all(
              color: _modoAutomatico
                  ? AppCores.roxo
                  : AppCores.cinzaMedio,
            ),
          ),

          child: Row(
            children: [
              Icon(
                Icons.auto_mode,

                color: _modoAutomatico
                    ? AppCores.roxo
                    : AppCores.cinzaTexto,

                size: 30,
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Modo Automático',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _modoAutomatico
                          ? 'Modo automático ativado'
                          : 'Controle automático desativado',

                      style: const TextStyle(
                        color:
                            AppCores.cinzaTexto,

                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Switch(
                value:
                    _modoAutomatico,

                activeColor:
                    AppCores.amarelo,

                onChanged:
                    _alternarModoAutomatico,
              ),
            ],
          ),
        ),

        // CONTROLE DE INTENSIDADE

        Container(
          margin:
              const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 15,
          ),

          padding:
              const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color:
                AppCores.cinzaEscuro,

            borderRadius:
                BorderRadius.circular(16),
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              const Text(
                'Intensidade da luz',

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              Row(
                children: [
                  const Icon(
                    Icons.brightness_low,
                    color:
                        AppCores.cinzaTexto,
                  ),

                  Expanded(
                    child: Slider(
                      value:
                          _intensidade,

                      min: 0.1,
                      max: 1.0,

                      activeColor:
                          AppCores.amarelo,

                      onChanged:
                          _alterarIntensidade,
                    ),
                  ),

                  const Icon(
                    Icons.brightness_high,
                    color:
                        AppCores.amarelo,
                  ),
                ],
              ),

              Center(
                child: Text(
                  '${(_intensidade * 100).round()}%',

                  style:
                      const TextStyle(
                    color:
                        AppCores.amarelo,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // CORES

        Container(
          margin:
              const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 15,
          ),

          padding:
              const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color:
                AppCores.cinzaEscuro,

            borderRadius:
                BorderRadius.circular(16),
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              const Text(
                'Cor da luz',

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceAround,

                children: [
                  _botaoCor(
                    Colors.white,
                    'Branca',
                  ),

                  _botaoCor(
                    Colors.yellow,
                    'Amarela',
                  ),

                  _botaoCor(
                    Colors.blue,
                    'Azul',
                  ),

                  _botaoCor(
                    Colors.red,
                    'Vermelha',
                  ),

                  _botaoCor(
                    Colors.purple,
                    'Roxa',
                  ),
                ],
              ),
            ],
          ),
        ),

        // REPRESENTAÇÃO

        Expanded(
          child: Center(
            child: AnimatedContainer(
              duration:
                  const Duration(
                milliseconds: 400,
              ),

              width: 120,
              height: 120,

              decoration:
                  const BoxDecoration(
                shape:
                    BoxShape.circle,

                color:
                    AppCores.cinzaEscuro,
              ),

              child: const Icon(
                Icons.flashlight_off,

                size: 60,

                color:
                    AppCores.cinzaTexto,
              ),
            ),
          ),
        ),

        // CONTADOR

        Text(
          'Lanterna ligada '
          '$_vezesLigada vezes',

          style: const TextStyle(
            color:
                AppCores.cinzaTexto,

            fontSize: 13,
          ),
        ),

        const SizedBox(height: 20),

        // BOTÃO

        Padding(
          padding:
              const EdgeInsets.only(
            bottom: 30,
          ),

          child: GestureDetector(
            onTap:
                _alternarLanterna,

            child: Container(
              width: 90,
              height: 90,

              decoration:
                  const BoxDecoration(
                shape:
                    BoxShape.circle,

                color:
                    AppCores.cinzaMedio,
              ),

              child: const Icon(
                Icons.power_settings_new,

                size: 40,

                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // BOTÃO DE COR

  Widget _botaoCor(
    Color cor,
    String nome,
  ) {
    bool selecionada =
        _corLuz == cor;

    return GestureDetector(
      onTap: () {
        _alterarCor(cor);
      },

      child: Column(
        children: [
          AnimatedContainer(
            duration:
                const Duration(
              milliseconds: 200,
            ),

            width:
                selecionada ? 42 : 36,

            height:
                selecionada ? 42 : 36,

            decoration:
                BoxDecoration(
              color: cor,

              shape:
                  BoxShape.circle,

              border: Border.all(
                color: selecionada
                    ? Colors.white
                    : Colors.transparent,

                width: 3,
              ),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            nome,

            style:
                const TextStyle(
              color:
                  AppCores.cinzaTexto,

              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}