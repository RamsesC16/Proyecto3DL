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
![Diagrama de bloques Proyecto 3_251125_180009_page-0001](https://github.com/user-attachments/assets/b68718eb-ed9a-47fc-af90-b11ab3533065)
De forma general, el circuito desarrollado tiene como función principal recibir dos números ingresados desde un teclado hexadecimal. Estos valores son almacenados internamente mediante flip-flops que operan bajo el control de una máquina de estados finita.

Antes de ser procesadas, las señales provenientes del teclado atraviesan un módulo debouncer, encargado de eliminar los rebotes eléctricos para asegurar que solo se registre una pulsación válida por tecla. Una vez filtrada la señal, los datos se envían al módulo de la máquina de estados encargada de la operación de división entera.

Dicha máquina de estados controla la captura secuencial de las teclas presionadas, asignando los valores ingresados al dividendo y al divisor. Una vez que ambos números han sido correctamente introducidos, la máquina de estados ejecuta el algoritmo iterativo de división, obteniendo el cociente y el residuo, los cuales son almacenados mediante flip-flops internos.

Finalmente, los resultados se muestran en los displays de siete segmentos mediante un sistema de multiplexación, que selecciona cuál dígito debe visualizarse, y un decodificador, que traduce cada número a su patrón correspondiente de visualización.


## 3.1 Módulo **DeBounce**

El módulo DeBounce se encarga de eliminar las señales espurias producidas por el rebote mecánico de los pulsadores o interruptores físicos. Cuando un botón es presionado o liberado, pueden aparecer múltiples transiciones rápidas debido a las vibraciones internas del contacto. Este módulo filtra dichas transiciones mediante un mecanismo de temporización y muestreo, asegurando que a la lógica digital del sistema solo llegue una señal limpia y estable, evitando activaciones múltiples no deseadas.


## 3.2 Módulo **Barrido**

El módulo Barrido controla la activación secuencial de los displays de siete segmentos o de las líneas de salida en sistemas multiplexados. Su función es habilitar de forma periódica cada display durante un intervalo de tiempo muy corto, de manera que, por persistencia visual, el usuario perciba todos los dígitos encendidos simultáneamente. Esta técnica reduce el número de pines necesarios y optimiza el uso de hardware.


## 3.3 Módulo **BinToBCD**

El módulo BinToBCD realiza la conversión de números en formato binario a su equivalente en formato BCD (Binary Coded Decimal). Esta conversión es fundamental para la visualización en displays de siete segmentos, ya que cada dígito decimal debe ser representado de manera independiente. El módulo toma un valor binario de entrada y lo separa en centenas, decenas y unidades en formato BCD.


## 3.4 Módulo **CambiaDatos**

El módulo CambiaDatos gestiona la actualización y selección de datos internos del sistema. Permite cambiar el valor de registros o buses internos según el estado del sistema o según las condiciones de control definidas. Este módulo actúa como intermediario entre las salidas de los bloques de cálculo y los bloques de almacenamiento o visualización.


## 3.5 Módulo **Cociente**

El módulo Cociente se encarga de almacenar y/o procesar el resultado correspondiente al cociente obtenido en una operación de división. Su función principal es aislar y entregar el resultado final de la división para que pueda ser utilizado por otros módulos, como los encargados de visualización o de control.


## 3.6 Módulo **Contador**

El módulo Contador implementa un contador síncrono que incrementa o decrementa su valor en cada flanco del reloj, dependiendo de la configuración. Se utiliza para generar retardos, temporizaciones, secuencias de control y señalización de eventos dentro del sistema.


## 3.7 Módulo **Divisor**

El módulo Divisor ejecuta la operación aritmética de división entre dos números binarios. Este módulo implementa el algoritmo de división digital, ya sea mediante restas sucesivas o mediante un mecanismo secuencial controlado por una máquina de estados, entregando como resultado el cociente y, en algunos casos, el residuo.


## 3.8 Módulo **Evaluar**

El módulo Evaluar compara y analiza señales internas del sistema para tomar decisiones de control. Su función es verificar condiciones específicas, como cero, mayor que, menor que o igualdad entre operandos, y generar señales de control que son utilizadas por la máquina de estados u otros módulos de decisión.


## 3.9 Módulo **FSM**

El módulo FSM (Finite State Machine) es el bloque de control principal del sistema. Se encarga de coordinar la secuencia de operaciones del circuito, determinando qué acciones se ejecutan en cada estado y cómo se realizan las transiciones entre estados en función de las entradas y de las condiciones evaluadas internamente. Es el núcleo del control secuencial del diseño.


## 3.10 Módulo **Lectura**

El módulo Lectura gestiona la captura de datos provenientes de entradas externas, como switches, teclados o buses de datos. Su función principal es sincronizar y estabilizar estas entradas antes de ser procesadas por el resto del sistema, garantizando que los valores sean coherentes y libres de inestabilidades.


## 3.11 Módulo **MUX 2:1**

El módulo MUX 2:1 es un multiplexor que selecciona una de dos señales de entrada de acuerdo con una señal de control. Su función es dirigir el flujo de datos dentro del sistema, permitiendo elegir entre distintas fuentes de información utilizando una única línea de salida.


## 3.12 Módulo **MUX 4:1**

El módulo MUX 4:1 selecciona una de cuatro señales de entrada en función de dos líneas de control. Este módulo es utilizado para enrutar datos desde múltiples fuentes hacia un único destino, optimizando el uso de recursos y facilitando la interconexión entre bloques funcionales.


## 3.13 Módulo **Register**

El módulo Register es un registro síncrono que almacena datos binarios de manera temporal. Este bloque captura el valor presente en su entrada en el flanco activo del reloj y lo mantiene estable en su salida hasta que se produzca una nueva actualización.


## 3.14 Módulo **Resta**

El módulo Resta realiza la operación aritmética de sustracción entre dos operandos binarios. Este módulo es fundamental en algoritmos de división por restas sucesivas y en lógica de comparación, produciendo tanto el resultado de la resta como señales de condición, como préstamo o resultado negativo.


## 3.15 Módulo **SevenSeg**

El módulo SevenSeg convierte valores numéricos en los patrones de activación necesarios para controlar un display de siete segmentos. Su función es traducir los dígitos decimales o BCD en las combinaciones de segmentos que permiten visualizar números legibles por el usuario.


## 3.16 Módulo **Top**

El módulo Top es el bloque de nivel superior que integra todos los subsistemas del diseño. Se encarga de interconectar los módulos internos, distribuir las señales de reloj y reset, y coordinar el funcionamiento global del sistema, garantizando que el flujo de datos y control sea coherente desde las entradas del sistema hasta las salidas de visualización.


## 4. Problemas encontrados durante la implementación:
Problema 1: Rebotes del teclado

Solución: Implementación de un bloque de antirrebote basado en contadores sincrónicos.

Problema 2: Inestabilidad en los displays

Solución: Uso de un divisor de frecuencia y multiplexación controlada.

Problema 3: Errores iniciales en la división

Solución: Corrección del orden de los desplazamientos y restauración del residuo.

Problema 4: Temporización crítica

Solución: Implementación del algoritmo con pipeline parcial para reducir el camino crítico.
## 5. Análisis de Potencia: <img width="299" height="575" alt="image" src="https://github.com/user-attachments/assets/f57dfb8f-b61b-408c-84e5-2fee8be31637" />


## 6. Testbenches: 
TESTBENCHES DE LOS MODULOS:

TB de module_barrido:

Starting simulation...
VCD info: dumpfile module_barrido_tb.vcd opened for output.
Time: 0ns, COLUMNA: 000x
Time: 60ns, COLUMNA: 0010
Time: 140ns, COLUMNA: 0100
Time: 220ns, COLUMNA: x000
Time: 300ns, COLUMNA: 000x
Time: 380ns, COLUMNA: 0010
Time: 460ns, COLUMNA: 0100
Time: 540ns, COLUMNA: x000
Time: 620ns, COLUMNA: 000x
Time: 700ns, COLUMNA: 0010
Time: 780ns, COLUMNA: 0100
Time: 860ns, COLUMNA: x000
Time: 940ns, COLUMNA: 000x
Ending simulation...
../sim/module_barrido_tb.sv:33: $finish called at 1000000 (1ps)



TB de module_bintobcd:

==== TEST BINARY TO BCD ====
bin_1=3 -> bcd_1=03 | bin_2=7 -> bcd_2=07
bin_1=8 -> bcd_1=08 | bin_2=9 -> bcd_2=09
---- Sweep completo ----
A=0 BCD_A=00 | B=0 BCD_B=00
A=0 BCD_A=00 | B=1 BCD_B=01
A=0 BCD_A=00 | B=2 BCD_B=02
A=0 BCD_A=00 | B=3 BCD_B=03
A=0 BCD_A=00 | B=4 BCD_B=04
A=0 BCD_A=00 | B=5 BCD_B=05
A=0 BCD_A=00 | B=6 BCD_B=06
A=0 BCD_A=00 | B=7 BCD_B=07
A=0 BCD_A=00 | B=8 BCD_B=08
A=0 BCD_A=00 | B=9 BCD_B=09
A=1 BCD_A=01 | B=0 BCD_B=00
A=1 BCD_A=01 | B=1 BCD_B=01
A=1 BCD_A=01 | B=2 BCD_B=02
A=1 BCD_A=01 | B=3 BCD_B=03
A=1 BCD_A=01 | B=4 BCD_B=04
A=1 BCD_A=01 | B=5 BCD_B=05
A=1 BCD_A=01 | B=6 BCD_B=06
A=1 BCD_A=01 | B=7 BCD_B=07
A=1 BCD_A=01 | B=8 BCD_B=08
A=1 BCD_A=01 | B=9 BCD_B=09
A=2 BCD_A=02 | B=0 BCD_B=00
A=2 BCD_A=02 | B=1 BCD_B=01
A=2 BCD_A=02 | B=2 BCD_B=02
A=2 BCD_A=02 | B=3 BCD_B=03
A=2 BCD_A=02 | B=4 BCD_B=04
A=2 BCD_A=02 | B=5 BCD_B=05
A=2 BCD_A=02 | B=6 BCD_B=06
A=2 BCD_A=02 | B=7 BCD_B=07
A=2 BCD_A=02 | B=8 BCD_B=08
A=2 BCD_A=02 | B=9 BCD_B=09
A=3 BCD_A=03 | B=0 BCD_B=00
A=3 BCD_A=03 | B=1 BCD_B=01
A=3 BCD_A=03 | B=2 BCD_B=02
A=3 BCD_A=03 | B=3 BCD_B=03
A=3 BCD_A=03 | B=4 BCD_B=04
A=3 BCD_A=03 | B=5 BCD_B=05
A=3 BCD_A=03 | B=6 BCD_B=06
A=3 BCD_A=03 | B=7 BCD_B=07
A=3 BCD_A=03 | B=8 BCD_B=08
A=3 BCD_A=03 | B=9 BCD_B=09
A=4 BCD_A=04 | B=0 BCD_B=00
A=4 BCD_A=04 | B=1 BCD_B=01
A=4 BCD_A=04 | B=2 BCD_B=02
A=4 BCD_A=04 | B=3 BCD_B=03
A=4 BCD_A=04 | B=4 BCD_B=04
A=4 BCD_A=04 | B=5 BCD_B=05
A=4 BCD_A=04 | B=6 BCD_B=06
A=4 BCD_A=04 | B=7 BCD_B=07
A=4 BCD_A=04 | B=8 BCD_B=08
A=4 BCD_A=04 | B=9 BCD_B=09
A=5 BCD_A=05 | B=0 BCD_B=00
A=5 BCD_A=05 | B=1 BCD_B=01
A=5 BCD_A=05 | B=2 BCD_B=02
A=5 BCD_A=05 | B=3 BCD_B=03
A=5 BCD_A=05 | B=4 BCD_B=04
A=5 BCD_A=05 | B=5 BCD_B=05
A=5 BCD_A=05 | B=6 BCD_B=06
A=5 BCD_A=05 | B=7 BCD_B=07
A=5 BCD_A=05 | B=8 BCD_B=08
A=5 BCD_A=05 | B=9 BCD_B=09
A=6 BCD_A=06 | B=0 BCD_B=00
A=6 BCD_A=06 | B=1 BCD_B=01
A=6 BCD_A=06 | B=2 BCD_B=02
A=6 BCD_A=06 | B=3 BCD_B=03
A=6 BCD_A=06 | B=4 BCD_B=04
A=6 BCD_A=06 | B=5 BCD_B=05
A=6 BCD_A=06 | B=6 BCD_B=06
A=6 BCD_A=06 | B=7 BCD_B=07
A=6 BCD_A=06 | B=8 BCD_B=08
A=6 BCD_A=06 | B=9 BCD_B=09
A=7 BCD_A=07 | B=0 BCD_B=00
A=7 BCD_A=07 | B=1 BCD_B=01
A=7 BCD_A=07 | B=2 BCD_B=02
A=7 BCD_A=07 | B=3 BCD_B=03
A=7 BCD_A=07 | B=4 BCD_B=04
A=7 BCD_A=07 | B=5 BCD_B=05
A=7 BCD_A=07 | B=6 BCD_B=06
A=7 BCD_A=07 | B=7 BCD_B=07
A=7 BCD_A=07 | B=8 BCD_B=08
A=7 BCD_A=07 | B=9 BCD_B=09
A=8 BCD_A=08 | B=0 BCD_B=00
A=8 BCD_A=08 | B=1 BCD_B=01
A=8 BCD_A=08 | B=2 BCD_B=02
A=8 BCD_A=08 | B=3 BCD_B=03
A=8 BCD_A=08 | B=4 BCD_B=04
A=8 BCD_A=08 | B=5 BCD_B=05
A=8 BCD_A=08 | B=6 BCD_B=06
A=8 BCD_A=08 | B=7 BCD_B=07
A=8 BCD_A=08 | B=8 BCD_B=08
A=8 BCD_A=08 | B=9 BCD_B=09
A=9 BCD_A=09 | B=0 BCD_B=00
A=9 BCD_A=09 | B=1 BCD_B=01
A=9 BCD_A=09 | B=2 BCD_B=02
A=9 BCD_A=09 | B=3 BCD_B=03
A=9 BCD_A=09 | B=4 BCD_B=04
A=9 BCD_A=09 | B=5 BCD_B=05
A=9 BCD_A=09 | B=6 BCD_B=06
A=9 BCD_A=09 | B=7 BCD_B=07
A=9 BCD_A=09 | B=8 BCD_B=08
A=9 BCD_A=09 | B=9 BCD_B=09
==== FIN DEL TEST ====
../sim/module_bintobcd_tb.sv:57: $finish called at 102000 (1ps)



TB de module_cambia_datos:

===== TEST module_cambia_datos =====
R_in=00000 A=1011 indice=0  -> R_out=00001
R_in=00101 A=1100 indice=0 -> R_out=01011
R_in=00101 A=1100 indice=1 -> R_out=01011
R_in=00101 A=1100 indice=2 -> R_out=01010
R_in=00101 A=1100 indice=3 -> R_out=01010
---- Sweep completo ----
R_in=00000 A=0110 indice=0 -> R_out=00000
R_in=00000 A=0110 indice=1 -> R_out=00001
R_in=00000 A=0110 indice=2 -> R_out=00001
R_in=00000 A=0110 indice=3 -> R_out=00000
R_in=00001 A=0110 indice=0 -> R_out=00010
R_in=00001 A=0110 indice=1 -> R_out=00011
R_in=00001 A=0110 indice=2 -> R_out=00011
R_in=00001 A=0110 indice=3 -> R_out=00010
R_in=00010 A=0110 indice=0 -> R_out=00100
R_in=00010 A=0110 indice=1 -> R_out=00101
R_in=00010 A=0110 indice=2 -> R_out=00101
R_in=00010 A=0110 indice=3 -> R_out=00100
R_in=00011 A=0110 indice=0 -> R_out=00110
R_in=00011 A=0110 indice=1 -> R_out=00111
R_in=00011 A=0110 indice=2 -> R_out=00111
R_in=00011 A=0110 indice=3 -> R_out=00110
R_in=00100 A=0110 indice=0 -> R_out=01000
R_in=00100 A=0110 indice=1 -> R_out=01001
R_in=00100 A=0110 indice=2 -> R_out=01001
R_in=00100 A=0110 indice=3 -> R_out=01000
R_in=00101 A=0110 indice=0 -> R_out=01010
R_in=00101 A=0110 indice=1 -> R_out=01011
R_in=00101 A=0110 indice=2 -> R_out=01011
R_in=00101 A=0110 indice=3 -> R_out=01010
R_in=00110 A=0110 indice=0 -> R_out=01100
R_in=00110 A=0110 indice=1 -> R_out=01101
R_in=00110 A=0110 indice=2 -> R_out=01101
R_in=00110 A=0110 indice=3 -> R_out=01100
R_in=00111 A=0110 indice=0 -> R_out=01110
R_in=00111 A=0110 indice=1 -> R_out=01111
R_in=00111 A=0110 indice=2 -> R_out=01111
R_in=00111 A=0110 indice=3 -> R_out=01110
===== FIN TEST =====
../sim/module_cambia_datos_tb.sv:52: $finish called at 37000 (1ps)



TB de module_cociente:

======== TEST module_cociente ========
signo=0 indice=0 -> Q=0000
signo=0 indice=1 -> Q=0100
signo=0 indice=2 -> Q=0100
signo=0 indice=3 -> Q=0101
signo=1 indice=0 -> Q=0101
signo=1 indice=1 -> Q=0001
signo=1 indice=2 -> Q=0001
signo=1 indice=3 -> Q=0000
ENABLE=0 -> Q (sin cambios) = 0000
======== FIN TEST ========



TB module_contador:

======= TEST module_contador =======
t=55000  sel=0000
t=65000  sel=0000
t=75000  sel=0000
t=85000  sel=0000
t=95000  sel=0000
t=105000  sel=0000
t=115000  sel=0001
t=125000  sel=0001
t=135000  sel=0001
t=145000  sel=0001
t=155000  sel=0001
t=165000  sel=0001
t=175000  sel=0001
t=185000  sel=0001
t=195000  sel=0001
t=205000  sel=0001
t=215000  sel=0001
t=225000  sel=0010
t=235000  sel=0010
t=245000  sel=0010
======= FIN DEL TEST =======
../sim/module_contador_tb.sv:39: $finish called at 245000 (1ps)



TB del module_DeBounce:

======== INICIO TEST module_DeBounce ========

--- Caso 1: Rebote corto, NO debe activarse DB_out ---

--- Caso 2: Presion real, SI debe activarse DB_out ---

--- Caso 3: Rebote al soltar, NO debe generar segundo pulso ---

--- Caso 4: Segundo pulso valido tras inhibicion ---

======== FIN TEST ========
../sim/module_DeBounce_tb.sv:89: $finish called at 2642000 (1ps)



TB del modulo_divisor:

======== INICIO TEST module_divisor ========

--- Ejecutando division: 8 / 2 ---
Resultado final:  Q = 0  (bin 0000),  R = x  (bin xxxxx)

--- Ejecutando division: 9 / 3 ---
Resultado final:  Q = 0  (bin 0000),  R = x  (bin xxxxx)

--- Ejecutando division: 7 / 2 ---
Resultado final:  Q = 0  (bin 0000),  R = x  (bin xxxxx)

--- Ejecutando division: 14 / 4 ---
Resultado final:  Q = 0  (bin 0000),  R = x  (bin xxxxx)

--- Ejecutando division: 5 / 5 ---
Resultado final:  Q = 0  (bin 0000),  R = x  (bin xxxxx)

--- Ejecutando division: 3 / 7 ---
Resultado final:  Q = 0  (bin 0000),  R = x  (bin xxxxx)

======== FIN TEST ========
../sim/module_divisor_tb.sv:79: $finish called at 185000 (1ps)



TB del module_evaluar:

TB start
t=0ns  B=0000  start=x
t=5ns  B=0000  start=0
t=20ns  B=0101  start=0
t=25ns  B=0101  start=1
t=35ns  B=0101  start=0
t=40ns  B=0110  start=0
t=60ns  B=0000  start=0
t=80ns  B=1111  start=0
t=85ns  B=1111  start=1
t=95ns  B=1111  start=0
../sim/module_evaluar_tb.sv:45: $finish called at 100000 (1ps)



TB del module_fsm:

-----------------------------------------------
 FSM TESTBENCH
-----------------------------------------------
 time | press reset | state outputs
-----------------------------------------------
    5ns |   0     1   | y_AB=01 y_disp=0 reset_2=0
   15ns |   0     1   | y_AB=01 y_disp=0 reset_2=0
   25ns |   0     0   | y_AB=01 y_disp=0 reset_2=0
   35ns |   0     0   | y_AB=01 y_disp=0 reset_2=0
   45ns |   0     0   | y_AB=01 y_disp=0 reset_2=0
   55ns |   0     0   | y_AB=10 y_disp=0 reset_2=0
   65ns |   0     0   | y_AB=10 y_disp=0 reset_2=0
   75ns |   0     0   | y_AB=00 y_disp=0 reset_2=0
   85ns |   0     0   | y_AB=00 y_disp=0 reset_2=0
   95ns |   0     0   | y_AB=00 y_disp=1 reset_2=0
  105ns |   0     0   | y_AB=00 y_disp=1 reset_2=0
  115ns |   0     0   | y_AB=00 y_disp=0 reset_2=1
-----------------------------------------------
../sim/module_fsm_tb.sv:66: $finish called at 125000 (1ps)
  125ns |   0     0   | y_AB=01 y_disp=0 reset_2=0



TB del module_lectura:

=== Test corto de module_lectura ===
Numero detectado: 0000
../sim/module_lectura_tb.sv:53: $finish called at 595000 (1ps)



TB del module_mux_21:

=== Test corto module_mux_21 ===
in_1 = 0101
in_2 = 1110
sel final = 1
out_data final = 1110
../sim/module_mux_21_tb.sv:40: $finish called at 20000 (1ps)



TB del module_mux_41:

=== Test corto module_mux_41 ===
sel final = 11 | out_data final = 1111
../sim/module_mux_41_tb.sv:41: $finish called at 40000 (1ps)



TB del module_register:

=== Test corto module_register ===
q final = 0011
../sim/module_register_tb.sv:42: $finish called at 40000 (1ps)



TB del module_resta:

=== Test module_resta ===
R=12  B= 5  D= 7  signo=0
R= 9  B= 9  D= 0  signo=0
R= 7  B=12  D=27  signo=1
../sim/module_resta_tb.sv:33: $finish called at 3000 (1ps)



TB del module_sevenseg:

=== Test module_sevenseg ===
num=0  seg=0111111
num=5  seg=1101101
num=9  seg=1101111
num=A  seg=1110111
num=F  seg=1110001
../sim/module_sevenseg_tb.sv:24: $finish called at 5000 (1ps)



TB del module_top:

=== Test estilo usuario module_top ===
[USUARIO] Presiona tecla 3
[USUARIO] Presiona tecla 7
seg = 1111111
cats = 1111
col = 000x
=== Fin test estilo usuario ===
../sim/module_top_tb.sv:75: $finish called at 5530000 (1ps)

## 7. Bitácoras: 
**JULIO DAVID QUESADA HERNÁNDEZ**

<img width="1141" height="1508" alt="image" src="https://github.com/user-attachments/assets/1586e248-e5f3-4277-a2a1-43149ac77e3f" />


**RAMSES ALONSO CORTES TORRES**

![Screenshot_20251126_000319_Drive](https://github.com/user-attachments/assets/f41b217b-80c9-4c9b-a269-7078a68f73ef)


![Screenshot_20251126_000333_Drive](https://github.com/user-attachments/assets/487caa82-2167-43cb-acab-e5a2c61d3a6b)
