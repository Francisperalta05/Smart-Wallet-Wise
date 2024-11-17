# Smart Wallet Wise

Una aplicación para gestionar tus ingresos y gastos personales, usando el patrón **MVC** junto con **BLoC** para manejar el estado y **SQLite** para la gestión local de la base de datos de transacciones.

## Tecnologías

- **Flutter**: Framework para crear aplicaciones nativas de alto rendimiento.
- **Dart**: Lenguaje de programación utilizado para desarrollar en Flutter.
- **BLoC**: Patrón de gestión de estado para aplicaciones Flutter.
- **SQLite**: Base de datos local para almacenar las transacciones de la app.

## Características

- Registrar ingresos y gastos.
- Ver un resumen del balance total, ingresos y gastos.
- Añadir, editar y eliminar transacciones.
- Interfaz de usuario moderna con un tema oscuro y gradientes.

## Requisitos del Sistema

Para ejecutar esta aplicación, necesitarás tener instalado el siguiente software:

- **Flutter**: La versión más reciente de Flutter.
- **Dart**: El lenguaje que usa Flutter.
- **Android Studio** o **Visual Studio Code**: Para la edición del código y la ejecución en dispositivos/emuladores.

### Versiones de las Herramientas

- **Flutter**: `3.24.4` (última versión estable disponible)
- **Dart**: `3.5.4` (última versión estable de Dart)

### Instalar Flutter

1. **Descargar Flutter**:
   - Dirígete a [flutter.dev](https://flutter.dev/docs/get-started/install) y sigue las instrucciones para descargar e instalar Flutter para tu sistema operativo.

2. **Instalar las dependencias**:
   - Una vez descargado e instalado, abre una terminal y ejecuta los siguientes comandos para verificar que todo esté funcionando correctamente:
   ```bash
   flutter doctor
   ```

3. **Configurar un editor**:
   - Si no tienes un editor configurado, te recomendamos **Visual Studio Code** o **Android Studio**.

## Instalación y Configuración

1. **Clonar el repositorio**:
   - Si aún no has clonado el repositorio de la aplicación, puedes hacerlo con el siguiente comando:
   ```bash
   git clone https://github.com/Francisperalta05/Smart-Wallet-Wise.git
   cd smart-wallet-wise
   ```

2. **Instalar las dependencias**:
   - Asegúrate de tener las dependencias necesarias en tu proyecto de Flutter. Abre la terminal en el directorio del proyecto y ejecuta:
   ```bash
   flutter pub get
   ```

3. **Empezar la aplicación**:
   - Para ejecutar la aplicación en un dispositivo o emulador, ejecuta:
   ```bash
   flutter run
   ```

## Estructura del Proyecto

La estructura del proyecto está organizada de la siguiente manera:

- **lib/**
  - **blocs/**: Contiene los archivos relacionados con la lógica de negocios y el estado (BLoC).
    - `transaction_bloc.dart`: BLoC para gestionar el estado de las transacciones.
    - `transaction_event.dart`: Los eventos que desencadenan cambios en el estado.
    - `transaction_state.dart`: Los estados posibles de las transacciones.
  - **models/**: Modelos de datos.
    - `transaction.dart`: El modelo de una transacción (ingreso/gasto).
  - **screens/**: Pantallas de la aplicación.
    - `transaction_list.dart`: Pantalla principal que muestra la lista de transacciones.
    - `add_transaction.dart`: Pantalla para agregar o editar una transacción.
  - **database/**: Configuración de la base de datos SQLite.
    - `database_helper.dart`: Clase para interactuar con la base de datos SQLite.
  - **main.dart**: Punto de entrada de la aplicación.

## Descripción del Código

### Transacciones BLoC

El BLoC maneja los eventos y estados relacionados con las transacciones, tales como agregar una transacción, eliminarla, y cargar el estado actual de las transacciones.

#### Eventos (`transaction_event.dart`)

- **TransactionAdded**: Evento para agregar una nueva transacción.
- **TransactionDeleted**: Evento para eliminar una transacción.
- **LoadTransactions**: Evento para cargar todas las transacciones desde la base de datos.

#### Estados (`transaction_state.dart`)

- **TransactionInitial**: Estado inicial antes de cargar las transacciones.
- **TransactionLoaded**: Estado que contiene la lista de transacciones cargadas desde la base de datos.
- **TransactionError**: Estado cuando ocurre un error al cargar las transacciones.

#### BLoC (`transaction_bloc.dart`)

El **BLoC** se encarga de gestionar la lógica del negocio y manejar las transacciones usando los eventos y estados definidos.

### Base de Datos SQLite

Usamos **SQLite** para almacenar las transacciones de manera local. Los métodos de la clase `DatabaseHelper` permiten insertar, eliminar y obtener las transacciones desde la base de datos.

#### Métodos importantes de `DatabaseHelper`:

- `insertTransaction(Transaction transaction)`: Inserta una nueva transacción.
- `deleteTransaction(int id)`: Elimina una transacción.
- `getTransactions()`: Obtiene todas las transacciones desde la base de datos.

### Pantallas

- **Pantalla de Lista de Transacciones (`transaction_list.dart`)**:
  - Muestra el balance total, los ingresos, los gastos y la lista de transacciones.
  - Permite navegar a la pantalla para agregar una nueva transacción.

- **Pantalla para Agregar Transacción (`add_transaction.dart`)**:
  - Formulario para agregar o editar una transacción. Permite ingresar el título, la cantidad y la fecha de la transacción.

## Dependencias

Estas son las dependencias que este proyecto utiliza:

- `flutter_bloc: ^8.1.6`: Para el manejo de estado con el patrón BLoC.
- `sqflite: ^2.0.0+4`: Para el manejo de la base de datos SQLite.
- `path: ^1.8.0`: Para manejar las rutas de los archivos de la base de datos.
- `equatable: ^2.0.3`: Para hacer que las clases de los estados y eventos sean fácilmente comparables.

Para agregar estas dependencias, puedes agregar las siguientes líneas en tu archivo `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.6
  sqflite: ^2.0.0+4
  path: ^1.8.0
  equatable: ^2.0.3
```

Después de agregar las dependencias, ejecuta:

```bash
flutter pub get
```

## Contribuciones

Las contribuciones son bienvenidas. Si tienes alguna sugerencia o mejoras, por favor abre un **issue** o crea un **pull request**.

## Licencia

Este proyecto está licenciado bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.

## Contacto

- **Correo electrónico**: [francisperalta05@gmail.com](mailto:francisperalta05@gmail.com)
- **LinkedIn**: [Angel Peralta](https://www.linkedin.com/in/angelperalt4/)
