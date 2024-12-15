#include <iostream>
#include <fstream>
#include <chrono>
#include <cstdlib>
#include <string>
#include <vector>
#include <ctime>

using namespace std;

// Función para generar un archivo aleatorio de tamaño específico (en bytes)
void generarArchivoAleatorio(const string &nombreArchivo, size_t tamañoEnBytes)
{
    ofstream archivo(nombreArchivo, ios::binary);
    if (!archivo)
    {
        cerr << "Error al crear el archivo: " << nombreArchivo << endl;
        return;
    }

    for (size_t i = 0; i < tamañoEnBytes; ++i)
    {
        char byteAleatorio = static_cast<char>(rand() % 256);
        archivo.put(byteAleatorio);
    }

    archivo.close();
    cout << "Archivo aleatorio generado: " << nombreArchivo << " (" << tamañoEnBytes << " bytes)" << endl;
}

// Función para medir el tiempo de ejecución de un comando
double medirTiempoDeEjecucion(const string &comando)
{
    auto inicio = chrono::high_resolution_clock::now();
    int resultado = system(comando.c_str());
    auto fin = chrono::high_resolution_clock::now();

    chrono::duration<double> duracion = fin - inicio;

    if (resultado != 0)
    {
        cerr << "Error ejecutando el comando: " << comando << endl;
    }

    return duracion.count();
}

// Función para eliminar un archivo
void eliminarArchivo(const string &nombreArchivo)
{
    if (remove(nombreArchivo.c_str()) != 0)
    {
        cerr << "Error al eliminar el archivo: " << nombreArchivo << endl;
    }
    else
    {
        cout << "Archivo eliminado: " << nombreArchivo << endl;
    }
}

// Función principal
int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        cerr << "Uso: " << argv[0] << " <número de archivos>" << endl;
        return 1;
    }

    int numArchivos = stoi(argv[1]);
    srand(time(0)); // Inicializar la semilla para la generación de números aleatorios

    ofstream resultados("resultados.txt", ios::app); // Abrir en modo append para no sobrescribir
    resultados << "Archivo\tTamaño\tTiempoCompresionZip\tTiempoCompresionGzip\tTiempoDescompresionZip\tTiempoDescompresionGzip" << endl;

    for (int i = 0; i < numArchivos; ++i)
    {
        string nombreArchivo = "archivo_" + to_string(i + 80) + ".bin";
        size_t tamañoEnBytes = rand() % 320000000 + 1; // Tamaño aleatorio entre 1 y 320,000,000 bytes
        generarArchivoAleatorio(nombreArchivo, tamañoEnBytes);

        double tiempoCompresionZip = 0.0, tiempoCompresionGzip = 0.0;
        double tiempoDescompresionZip = 0.0, tiempoDescompresionGzip = 0.0;

        vector<string> compresores = {"gzip", "zip"};
        for (const string &compresor : compresores)
        {
            string comandoCompresion, comandoDescompresion, archivoComprimido;
            if (compresor == "gzip")
            {
                comandoCompresion = "gzip " + nombreArchivo;
                archivoComprimido = nombreArchivo + ".gz";
                comandoDescompresion = "gunzip " + archivoComprimido;
                tiempoCompresionGzip = medirTiempoDeEjecucion(comandoCompresion);
                tiempoDescompresionGzip = medirTiempoDeEjecucion(comandoDescompresion);
            }
            else if (compresor == "zip")
            {
                archivoComprimido = nombreArchivo + ".zip";
                comandoCompresion = "zip " + archivoComprimido + " " + nombreArchivo;
                comandoDescompresion = "unzip -o " + archivoComprimido;
                tiempoCompresionZip = medirTiempoDeEjecucion(comandoCompresion);
                tiempoDescompresionZip = medirTiempoDeEjecucion(comandoDescompresion);
            }

            eliminarArchivo(archivoComprimido);
        }

        resultados << nombreArchivo << "\t" << tamañoEnBytes << "\t" << tiempoCompresionZip << "\t" << tiempoCompresionGzip << "\t" << tiempoDescompresionZip << "\t" << tiempoDescompresionGzip << endl;

        eliminarArchivo(nombreArchivo);
    }

    resultados.close();
    return 0;
}
