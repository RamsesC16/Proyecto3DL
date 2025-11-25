# Proyecto  Diseño Lógico.
Integrantes: Julio David Quesada Hernández, Ramses Cortes Torres. 

## 1. Abreviatura y Definiciones:
FPGA (Field Programmable Gate Array): Dispositivo programable que permite implementar circuitos digitales personalizados mediante una arquitectura de bloques lógicos configurables, utilizados para pruebas, desarrollo y aplicaciones electrónicas avanzadas.

Divisor (Unidad de división): Módulo digital encargado de realizar la operación aritmética de división entera entre dos números binarios o decimales, produciendo como salida el cociente y el residuo.

Flip-Flop: Componente secuencial básico que puede almacenar un único valor binario (0 o 1). Se utiliza como elemento de memoria en sistemas digitales y en el control de máquinas de estado.

Debounce (Antirrebote): Técnica empleada en electrónica digital para eliminar las señales erróneas que se producen por el rebote mecánico al presionar un botón o interruptor, garantizando que solo se registre una única entrada válida por pulsación.

FSM (Finite State Machine – Máquina de Estados Finitos): Sistema de control secuencial basado en estados y transiciones, utilizado para coordinar el flujo de datos entre los distintos módulos del sistema.
## 2. Descripción General del Problema:

El proyecto tuvo como objetivo principal el diseño e implementación de un sistema digital capaz de realizar divisiones enteras entre dos números ingresados mediante un teclado hexadecimal, utilizando máquinas de estado finitas para coordinar el funcionamiento de los distintos módulos del sistema.

Este diseño exigió una planificación estructurada previa, debido a que cada módulo debía operar de forma sincronizada con el resto del sistema, especialmente los bloques de lectura de datos, control secuencial y cálculo aritmético. A lo largo del desarrollo se lograron diversos avances, entre ellos la implementación del sistema en FPGA, la creación de testbenches individuales para cada módulo, y el fortalecimiento de la comprensión sobre el diseño de máquinas de estados síncronas y asíncronas.

Se logró implementar correctamente la lectura del teclado hexadecimal, permitiendo capturar los valores de dividendo y divisor, así como el diseño funcional del módulo de división entera a nivel de simulación. También se implementó el despliegue correcto de los resultados en los displays de siete segmentos, mostrando el cociente y el residuo según la operación realizada.

Sin embargo, aunque el sistema funciona correctamente en simulación, la integración completa del algoritmo de división en la implementación física presentó dificultades relacionadas con sincronización y temporización. Por esta razón, se desarrollaron dos versiones del módulo principal: una dedicada a la validación del funcionamiento del teclado y los displays en hardware físico, y otra dedicada a la ejecución completa de la división entera, la cual se validó únicamente en simulación. 

## 3. Descripción General del Sistema: 
<img width="1768" height="495" alt="image" src="https://github.com/user-attachments/assets/fb0c2900-af18-4b2c-887a-4f84e8529d83" />

De forma general, el circuito desarrollado tiene como función principal recibir dos números ingresados desde un teclado hexadecimal. Estos valores son almacenados internamente mediante flip-flops que operan bajo el control de una máquina de estados finita.

Antes de ser procesadas, las señales provenientes del teclado atraviesan un módulo debouncer, encargado de eliminar los rebotes eléctricos para asegurar que solo se registre una pulsación válida por tecla. Una vez filtrada la señal, los datos se envían al módulo de la máquina de estados encargada de la operación de división entera.

Dicha máquina de estados controla la captura secuencial de las teclas presionadas, asignando los valores ingresados al dividendo y al divisor. Una vez que ambos números han sido correctamente introducidos, la máquina de estados ejecuta el algoritmo iterativo de división, obteniendo el cociente y el residuo, los cuales son almacenados mediante flip-flops internos.

Finalmente, los resultados se muestran en los displays de siete segmentos mediante un sistema de multiplexación, que selecciona cuál dígito debe visualizarse, y un decodificador, que traduce cada número a su patrón correspondiente de visualización.



## 4. Problemas encontrados durante la implementación:
Problema 1: Rebotes del teclado

Solución: Implementación de un bloque de antirrebote basado en contadores sincrónicos.

Problema 2: Inestabilidad en los displays

Solución: Uso de un divisor de frecuencia y multiplexación controlada.

Problema 3: Errores iniciales en la división

Solución: Corrección del orden de los desplazamientos y restauración del residuo.

Problema 4: Temporización crítica

Solución: Implementación del algoritmo con pipeline parcial para reducir el camino crítico.
## 5. Análisis de Potencia: 

## 7. Bitácoras: 
[📘 Ver Bitácora de Julio](https://github.com/RamsesC16/Proyecto2DL/blob/main/BITÁCORAS/BITÁCORA_JULIO.pdf)
[📘 Ver Bitácora de Ramsés](https://github.com/RamsesC16/Proyecto2DL/blob/main/BITÁCORAS/BITÁCORA_RAMSÉS.pdf)
