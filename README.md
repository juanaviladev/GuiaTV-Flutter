#  ![Icono de la app](https://img.icons8.com/color/48/000000/retro-tv.png) GuiaTV

**GuiaTV** provee acceso a la programación de más de 100 canales gratuitos y de pago de la televisión española. No es una aplicación de streaming, para ello existen otras aplicaciones como [TDTChannels-APP](https://github.com/LaQuay/TDTChannels-APP).

El objetivo de este repositorio es seguir mejorando la aplicación, investigando nuevas librerías y APIs.

Está desarollada con Flutter, y aunque actualmente está preparada para ser desplegada en dispositivos iOS y Android, está previsto que en un futuro próximo puedan habilitarse otras como MacOS, Windows o Web.

## 🌟 Demo

|IOS|ANDROID|
|--|--|
| <img src="https://github.com/juanavilaes/GuiaTV-Flutter/raw/master/ios_demo.gif" width="200" /> | <img src="https://github.com/juanavilaes/GuiaTV-Flutter/raw/master/android_demo.gif" width="210" /> |
|📱**Apple Store**: No disponible|🤖 **Google Play**: No disponible|

## 🎉 Funcionalidades disponibles

-   **Acceso a la programación de +100 canales** 📺 📡  
    Puedes visitar toda la parrilla televisiva de cada uno de los canales de la televisión española gratuita y de pago. Por el momento se puede acceder hasta una semana (adelante y atrás) desde el día actual.
    
-   **Indicador de emisión en vivo** 🔴  
    En ciertos canales, es posible visualizar el progreso del programa que está en un momento determinado en emisión.
    
-   **Marcar un programa como favorito**  ❤️  
    Es posible marcar una franja televisiva como favorita, de forma que puedas guardar para más tarde un programa que no te quieres perder.
    
-   **Eliminar todos los favoritos**  🗑️  
    ¿Ya has visto todos los programas que tenías pendientes? Puedes borrarlos de una sola vez desde la pantalla de favoritos, haciendo clic en 'Limpiar'.
   
## 🛠️  Cómo funciona
La aplicación hace uso de los datos que proporciona la web [movistarplus.es/guiamovil](http://www.movistarplus.es/guiamovil), procesandolos en el dispositivo cliente para mostrarlos con un formato determinado.

Los programas marcados como favoritos son almacenados en una base de datos SQLite local (Android e iOS), no se almacena ningún dato en servidores externos, quedando todos los datos en el cliente.

## ❓  Backlog

-   Refactorizar algunas partes a MVVM
-   Generar APK y publicar en Google Play
-   Notificaciones programadas sobre el inicio de programas
-   Buscador de programas
-   Mejoras visuales
-   …

## 🙏  Librerías y agradecimientos

-   Parte de la iconografía y de las ilustraciones pertenecen a  [icons8.com](http://icons8.com/)
-   Los datos mostrados sobre cada canal pertenecen a [movistarplus.es](http://www.movistarplus.es/guiamovil)
