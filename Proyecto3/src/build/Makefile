#Makefile con todo el flujo de trabajo para GOWIN. Utilizando Yosys, nextpnr, iverilog, gtkwave y openFPGALoader

#FPGA a utilizar... Esto no se debe modificar para efectos del curso.
BOARD  = tangnano9k
FAMILY = GW1N-9C
DEVICE = GW1NR-LV9QN88PC6/I5

#Nombre del proyecto... Acá ponen el nombre que deseen.
PROYECT = CALCULADORA

#Fuentes de diseno
SOURCES := $(wildcard ../design/*.v ../design/*.sv) #Todas las fuentes .v o .sv que estan en design
#Si quieren indicarlas una a una, pueden hacerlo como en este ejemplo:
#SOURCES = ../design/module_top_deco_gray.v ../design/module_input_deco_gray.v 

#Fuente de simulacion
#aca va el testbench que quieran simular
TESTBENCH = ../sim/module_top_tb.sv

# Constraints para el proyecto
#aca va el archivo de constraints del proyecto
CONSTRAINTS = ../constr/constraints.cst

#el top se indica sin la extension .v, esto hace referencia al nombre que le pusieron al módulo y no al archivo en si.
TOP_DESIGN = module_top
TOP_TB = module_top_tb
#nombre del vcd que va a generar el tb
VCD_FILE = module_top_tb.vcd

all: synth pnr bitstream load

# Synthesis
synth: ${SOURCES}
	@echo "Ejecutando la sintesis..."
	@yosys -p "read_verilog -sv ${SOURCES}; synth_gowin -top ${TOP_DESIGN} -json ${PROYECT}.json" > synthesis_${BOARD}.log 2>&1 
	@echo "COMPLETADO"

# Place and Route
pnr: ${PROYECT}.json
	@echo "Ejecutando el pnr..."
	@nextpnr-gowin --json ${PROYECT}.json --write ${PROYECT}_pnr.json --freq 27 --device ${DEVICE} --family ${FAMILY} --cst ${CONSTRAINTS} > pnr_${BOARD}.log 2>&1 
	@echo "COMPLETADO"

# Generar el Bitstream
bitstream: ${PROYECT}_pnr.json
	@echo "Generando ${PROYECT}_${BOARD}.fs"
	@gowin_pack -d ${FAMILY} -o ${PROYECT}_${BOARD}.fs ${PROYECT}_pnr.json
	@echo "COMPLETADO"
		
#Generar vcd con icarus verilog
test: ${SOURCES} ${TESTBENCH}
	@iverilog -o ${PROYECT}_test.o -s ${TOP_TB} -g2005-sv ${TESTBENCH} ${SOURCES}
	@vvp ${PROYECT}_test.o 
	
#Visualizar los diagramas de tiempo con GTKWave
wv: ${VCD_FILE}
	gtkwave ${VCD_FILE} 
        
# Cargar el bitstream en la FPGA
load: ${PROYECT}_${BOARD}.fs
	openFPGALoader -b ${BOARD} ${PROYECT}_${BOARD}.fs 

.PHONY: load  wv
.INTERMEDIATE: ${PROYECT}_pnr.json ${PROYECT}.json

test_push: ${SOURCES} ../sim/Push_datos_tb.sv
	@iverilog -o Push_datos_test.o -s Push_datos_tb -g2005-sv ../sim/Push_datos_tb.sv ${SOURCES}
	@vvp Push_datos_test.o

test_guardado: ${SOURCES} ../sim/Guardado_datos_tb.sv
	@iverilog -o Guardado_datos_test.o -s Guardado_datos_tb -g2005-sv ../sim/Guardado_datos_tb.sv ${SOURCES}
	@vvp Guardado_datos_test.o

test_suma: ${SOURCES} ../sim/Suma_datos_tb.sv
	@iverilog -o Suma_datos_test.o -s Suma_datos_tb -g2005-sv ../sim/Suma_datos_tb.sv ${SOURCES}
	@vvp Suma_datos_test.o

test_display: ${SOURCES} ../sim/display7_tb.sv
	@iverilog -o display7_test.o -s display7_tb -g2005-sv ../sim/display7_tb.sv ${SOURCES}
	@vvp display7_test.o

test_mux1: ${SOURCES} ../sim/mux_info_tb.sv
	@iverilog -o mux_info_test.o -s mux_info_tb -g2005-sv ../sim/mux_info_tb.sv ${SOURCES}
	@vvp mux_info_test.o

test_mux2: ${SOURCES} ../sim/mux_numeros_tb.sv
	@iverilog -o mux_numeros_test.o -s mux_numeros_tb -g2005-sv ../sim/mux_numeros_tb.sv ${SOURCES}
	@vvp mux_numeros_test.o

test_prueba: ${SOURCES} ../sim/Prueba_tb.sv
	@iverilog -o Prueba_test.o -s Prueba_tb -g2005-sv ../sim/Prueba_tb.sv ${SOURCES}
	@vvp Prueba_test.o

test_barrido_catodos: ${SOURCES} ../sim/barrido_catodos_tb.sv
	@iverilog -o barrido_catodos_test.o -s barrido_catodos_tb -g2005-sv ../sim/barrido_catodos_tb.sv ${SOURCES}
	@vvp barrido_catodos_test.o

test_barrido_contador_mux: ${SOURCES} ../sim/barrido_contador_mux_tb.sv
	@iverilog -o barrido_contador_mux_test.o -s barrido_contador_mux_tb -g2005-sv ../sim/barrido_contador_mux_tb.sv ${SOURCES}
	@vvp barrido_contador_mux_test.o

test_DeBounce_2: ${SOURCES} ../sim/DeBounce_2_tb.sv
	@iverilog -o DeBounce_2_test.o -s DeBounce_2_tb -g2005-sv ../sim/DeBounce_2_tb.sv ${SOURCES}
	@vvp DeBounce_2_test.o

test_press_monitor: ${SOURCES} ../sim/press_monitor_tb.sv
	@iverilog -o press_monitor_test.o -s press_monitor_tb -g2005-sv ../sim/press_monitor_tb.sv ${SOURCES}
	@vvp press_monitor_test.o

test_debug_lectura: ${SOURCES} ../sim/debug_lectura_tb.sv
	@iverilog -o debug_lectura_test.o -s debug_lectura_tb -g2005-sv ../sim/debug_lectura_tb.sv ${SOURCES}
	@vvp debug_lectura_test.o