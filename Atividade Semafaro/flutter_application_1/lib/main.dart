import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SemaforoApp(),
  ));
}

class SemaforoApp extends StatefulWidget {
  @override
  _SemaforoAppState createState() => _SemaforoAppState();
}

class _SemaforoAppState extends State<SemaforoApp> {

  int estado = 0;

  void mudarSemaforo() {
    setState(() {
      estado++;

      if (estado > 2) {
        estado = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      appBar: AppBar(
        title: Text("Semáforo de Trânsito"),
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // SEMÁFORO
            Container(
              width: 120,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                children: [

                  // VERMELHO
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: estado == 2 ? Colors.red : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),

                  SizedBox(height: 10),

                  // AMARELO
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: estado == 1 ? Colors.yellow : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),

                  SizedBox(height: 10),

                  // VERDE
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: estado == 0 ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),

            // PEDESTRE
            Column(
              children: [

                Icon(
                  estado == 2 ? Icons.directions_walk : Icons.pan_tool,
                  size: 80,
                  color: estado == 2 ? Colors.green : Colors.red,
                ),

                SizedBox(height: 10),

                Text(
                  estado == 2
                      ? "PEDESTRE: ATRAVESSE"
                      : "PEDESTRE: AGUARDE",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),

            SizedBox(height: 40),

            // BOTÃO
            ElevatedButton(
              onPressed: mudarSemaforo,
              child: Text("Mudar Semáforo"),
            )

          ],
        ),
      ),
    );
  }
}