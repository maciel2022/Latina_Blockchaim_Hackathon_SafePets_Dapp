# Latina_Blockchain_Hackathon_SafePets
Repositorio creado para desplegar la Dapp realizada en equipo para el Latina Blockchain Hackathon.

Esta Daap no logro hacer conexion con las blockchaims de los retos, ya que no pudimos conseguir los tokes de test para realizar las pruebas.
Tambien se intento desplegar el entorno de hardhat para deployar zkENV Polygon Cardona, pero la documentacion no indica que versiones de las dependecias eran las corretas para su normal funcionamiento.

En concreto, esta daap trabaja con un contrato inteligente que funciona como BD en un principio, pero la idea es que actue para generar los token ERC-20 llamados TPS 'Token Safe Pets'. Esta se conecta a la wallet de quien ingrese y le almacenara los datos en su red. Posee una interfaz grafica para registrar a las mascotas, y una vez registradas se podra arpobar su castración efectiva, haciendo click sobre un check, de esa manera se vuelve a conectar a la wallet y genera el falso envio de los tokens. Al ser todo de prueba local nunca pudimos probar con una MainNet.

Obviamente estaremos trabajando mucho mas en toda la iteraccion del Smart Contract para llevar a cabo el mint y burn de dichos Tokens.

En el archivo TokenTSP.sol, estan los datos del contrato con el cual estaremos trabajando para continuar con este hermoso projecto.