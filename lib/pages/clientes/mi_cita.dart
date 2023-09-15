import 'package:flutter/material.dart';

class CitaView extends StatelessWidget {
  final Future<Map<String, dynamic>?> citaFuture;
  final String documento;

  CitaView({required this.citaFuture, required this.documento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Cambia el color del AppBar a negro
        centerTitle: true, // Centra el texto del AppBar
        title: Text(
          'Detalles de la Cita',
          style: TextStyle(
            color: Colors.white, // Cambia el color del texto del AppBar a blanco
            fontSize: 20.0, // Cambia el tamaño de fuente del texto del AppBar
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: citaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  fontSize: 18.0, // Cambia el tamaño de fuente del texto de error
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                'No se encontró una cita con el documento $documento',
                style: TextStyle(
                  fontSize: 18.0, // Cambia el tamaño de fuente del texto de error
                ),
              ),
            );
          } else {
            final cita = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildInfoRow('Nombre', cita['nombre']),
                  buildInfoRow('Fecha', cita['fecha']),
                  buildInfoRow('Placa', cita['placa']),
                  buildInfoRow('Estado', cita['estado']),
                  buildInfoRow('Servicio', cita['servicio']),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.0, // Tamaño de fuente del etiqueta
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.0, // Tamaño de fuente del valor
            ),
          ),
        ],
      ),
    );
  }
}
