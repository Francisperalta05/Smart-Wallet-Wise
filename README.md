
# Smart Wallet Wise

Smart Wallet Wise es una aplicación diseñada para gestionar tus ingresos y gastos personales de forma eficiente. Ofrece una experiencia fluida, moderna y con características avanzadas como la gestión de estado mediante **BLoC** y almacenamiento local con **SQLite**.

---

## 🛠️ Tecnologías Utilizadas

- **Flutter**: Framework para crear aplicaciones nativas de alto rendimiento.
- **Dart**: Lenguaje de programación utilizado para desarrollar en Flutter.
- **BLoC**: Patrón de gestión de estado para aplicaciones Flutter.
- **SQLite**: Base de datos local para almacenar las transacciones de la app.

---

## ✨ Características Principales

- **Gestión de Transacciones**:
  - Registrar **ingresos** y **gastos**.
  - Categorizar transacciones (Alimentación, Transporte, Salud, etc.).
  - Editar y eliminar transacciones existentes.
  - Asignar descripciones y fechas personalizadas.

- **Resumen Financiero**:
  - Balance total: ingresos vs. gastos.
  - Detalle por categoría.

- **Interfaz de Usuario Moderna**:
  - Tema oscuro.
  - Gradientes personalizables.

- **Gestión Local**:
  - Funciona sin conexión a Internet gracias a **SQLite**.

---

## 📋 Requisitos del Sistema

Para ejecutar esta aplicación, necesitarás:

- **Flutter**: Versión estable más reciente (recomendado `3.24.4`).
- **Dart**: Versión estable más reciente (recomendado `3.5.4`).
- **Android Studio** o **Visual Studio Code**: Para desarrollo y pruebas.

---

## 📦 Instalación y Configuración

1. **Clona el repositorio**:
   ```bash
   git clone https://github.com/Francisperalta05/Smart-Wallet-Wise.git
   cd smart-wallet-wise
   ```

2. **Instala las dependencias**:
   ```bash
   flutter pub get
   ```

3. **Ejecuta la aplicación**:
   ```bash
   flutter run
   ```

---

## 📂 Estructura del Proyecto

El proyecto sigue una estructura organizada para garantizar escalabilidad y mantenimiento:

- **lib/**
  - **blocs/**: Lógica de negocio y manejo de estado (BLoC).
    - `transaction_bloc.dart`: Gestiona el estado de las transacciones.
    - `transaction_event.dart`: Eventos relacionados con las transacciones.
    - `transaction_state.dart`: Estados posibles.
  - **models/**: Modelos de datos.
    - `transaction.dart`: Modelo de una transacción (ingreso/gasto).
  - **screens/**: Pantallas principales.
    - `transaction_list.dart`: Lista de transacciones y resumen financiero.
    - `add_transaction.dart`: Formulario para agregar/editar transacciones.
  - **database/**: Interacciones con SQLite.
    - `database_helper.dart`: Clase para manejar la base de datos local.
  - **main.dart**: Punto de entrada de la aplicación.

---

## 🧩 Dependencias

El proyecto utiliza las siguientes dependencias:

- **`flutter_bloc`**: Gestión de estado con el patrón BLoC.
- **`sqflite`**: Manejo de base de datos local SQLite.
- **`path`**: Rutas de archivos.
- **`equatable`**: Simplifica la comparación de objetos.

### Configuración en `pubspec.yaml`

Añade las siguientes líneas al archivo `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.6
  sqflite: ^2.0.0+4
  path: ^1.8.0
  equatable: ^2.0.3
```

Después, ejecuta:

```bash
flutter pub get
```

---

## 📖 Detalles Técnicos

### Manejo de Estado con BLoC

El **BLoC** organiza la lógica del negocio y la interacción con los eventos y estados definidos.

#### Eventos (`transaction_event.dart`)
- `TransactionAdded`: Agregar una nueva transacción.
- `TransactionDeleted`: Eliminar una transacción.
- `LoadTransactions`: Cargar transacciones desde la base de datos.

#### Estados (`transaction_state.dart`)
- `TransactionInitial`: Estado inicial.
- `TransactionLoaded`: Transacciones cargadas exitosamente.
- `TransactionError`: Error al cargar transacciones.

### Base de Datos SQLite

La clase `DatabaseHelper` gestiona las interacciones con la base de datos local:

- **`insertTransaction`**: Inserta una nueva transacción.
- **`deleteTransaction`**: Elimina una transacción.
- **`getTransactions`**: Obtiene todas las transacciones.

---

## 🚀 Próximas Mejoras

- **Filtros Avanzados**:
  - Filtrar por fechas, categorías y rangos personalizados.

- **Gráficos Interactivos**:
  - Visualización gráfica de estadísticas financieras.

- **Sincronización en la Nube**:
  - Integración para sincronizar datos entre múltiples dispositivos.

---

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Sigue estos pasos para contribuir:

1. Haz un fork del repositorio.
2. Crea una nueva rama:
   ```bash
   git checkout -b feature/nueva-caracteristica
   ```
3. Realiza tus cambios.
4. Haz un commit:
   ```bash
   git commit -m 'Añadir nueva característica'
   ```
5. Sube tus cambios:
   ```bash
   git push origin feature/nueva-caracteristica
   ```
6. Abre un Pull Request en GitHub.

---

## 📄 Licencia

Este proyecto está licenciado bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.

---

## 📧 Contacto

Si tienes alguna pregunta o sugerencia, no dudes en contactarme:

- **Correo electrónico**: [francisperalta05@gmail.com](mailto:francisperalta05@gmail.com)
- **LinkedIn**: [Angel Peralta](https://www.linkedin.com/in/angelperalt4/)
