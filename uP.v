<<<<<<< HEAD
=======

//Laboratorio 8 Ejercicio 02 
module Memory(input wire [11:0] address, output wire [7:0] data );
>>>>>>> parent of 524793e... Resolviendo el problema

module FlipFlopD2b(input wire [1:0] D,input wire load, reset, clk, output reg[1:0] Q );

    always @(posedge clk, posedge reset) begin
        
        if (reset) Q = 0; //si esta en reset la salida es 0
        else if(load) begin //si load es 1 en el siguiente flanco de reloj deja pasar D a Q
            Q <= D;
        end
    end
endmodule

module RAM(input wire [11:0] address, input wire weRAM, csRAM, inout wire [3:0] data);
    reg [3:0] memoria[0:4095] ;//bloque de memoria de 4k posiciones
    reg [3:0] dataOut;

    assign data = ( (csRAM & ~weRAM) ? dataOut : 4'bzzzz);// cuando csRAM es 1 y weRAM es 0 se le asigna a la salida el valor de
                                                            //data out, en cualquier otro caso se coloca en alta impedancia

    always @ (weRAM or csRAM or data or address) begin  //siempbre que haya un cambio en estas variables se ejecuta 
        if(weRAM & csRAM)
            memoria[address] = data;
    
        else if (~weRAM & csRAM) dataOut = memoria[address];
        
    end
endmodule

//Lab 9 Ejercicio 1
module  FlipFlopD1b(input d,enable,reset,clk,output reg q);

    always @(posedge clk, posedge reset) begin  //reset asincrono
        if (reset) q = 0; // si el reset esta activado la salida se coloca en 0
        else if (enable) q = d; //si reset esta en 0 y ademas esta enable en 1, entonces deja pasar d a q
    end

endmodule
//Lab 9 Ejercicio 2
module FlipFlopT(input enable, reset, clk, output wire q );
    
    FlipFlopD1b FF(~q,enable, reset,clk,q); // ya que lo que hace FF T es complementar la salida
    //se coloca ~q en la entrada del Flip Flop D, de forma que en cada flanco de subida, la salida Q
    // se complementa, siempre y cuando el enable este en 1, 

endmodule

module Decode(input[6:0] address,output reg [12:0] value );

    always @(address) begin
        
        casez(address)

        7'b??????0 : value <= 13'b1000000001000;
        7'b00001?1 : value <= 13'b0100000001000;
        7'b00000?1 : value <= 13'b1000000001000;
        7'b00011?1 : value <= 13'b1000000001000;
        7'b00010?1 : value <= 13'b0100000001000;
        7'b0010??1 : value <= 13'b0001001000010;
        7'b0011??1 : value <= 13'b1001001100000;
        7'b0100??1 : value <= 13'b0011010000010;
        7'b0101??1 : value <= 13'b0011010000100;
        7'b0110??1 : value <= 13'b1011010100000;
        7'b0111??1 : value <= 13'b1000000111000;
        7'b1000?11 : value <= 13'b0100000001000;
        7'b1000?01 : value <= 13'b1000000001000;
        7'b1001?11 : value <= 13'b1000000001000;
        7'b1001?01 : value <= 13'b0100000001000;
        7'b1010??1 : value <= 13'b0011011000010;
        7'b1011??1 : value <= 13'b1011011100000;
        7'b1100??1 : value <= 13'b0100000001000;
        7'b1101??1 : value <= 13'b0000000001001;
        7'b1110??1 : value <= 13'b0011100000010;
        7'b1111??1 : value <= 13'b1011100100000;
        default : value <= 0; // si se ingresa cualquier otra direccion la salida es 0

        endcase


    end


endmodule

module uP(input wire [3:0] pushbuttons, input reset, clock,
          output wire [11:0] PC, address_RAM, output wire [7:0] program_byte, output wire [3:0] instr, oprnd, data_bus, FF_out, accu,
          output wire phase, c_flag, z_flag);

    wire [12:0] controlSignals;
    wire [6:0] inDecode;
<<<<<<< HEAD

    assign inDecode = {instr, c_flag, z_flag, phase };
    FlipFlopT fase(1'b1, reset,clock,phase);
    //decodificador
    Decode  decode(inDecode, controlSignals);
    // ---------------- CONTROL DEL PROGRAMA ----------------------------
    ModuloInstruccion control(address_RAM, controlSignals[11], reset, controlSignals[12], ~phase, clock,
                              instr, opernd, program_byte, PC);

    assign address_RAM= {opernd, program_byte};
=======
    assign inDecode = {instr,c_flag,z_flag,phase}; //el bus que va de entrada al decode, se concantenan buses mostrados
    wire [12:0] controlSignals; //bus de señales de ocntrol


    //----------------CONTROL DE FLUJO DEL PROGRAMA--------------------------------
    Decode decode(inDecode, controlSignals); // se conectan los buses necesarios para el modulo de decode
    //se conecta el bit loadPC con load, incPC con enable, las seniales de reloj y reset, y ademas la direccion de la ram
    Contador12b programCounter(controlSignals[11], controlSignals[12],clock,reset, address_RAM, PC );
    //la memoria de programa, se conecta pc a la direccion y program_byte a la salida
    Memory  ROM(PC, program_byte);
    //el modulo de fetch, en donde el load es controlado por el complenento del valor de phase.

    //------------------ BUS DE DATOS-----------------------------------------------------------
    FlipFlopD4b FetchOperand(program_byte[3:0], ~phase, reset, clock, oprnd);
    FlipFlopD4b FetchInstr(program_byte[7:4], ~phase, reset, clock, instr);
    //se concantenan oprnd y program_byte para generar el valor de address
    assign address_RAM = {oprnd,program_byte};
    //se genera la salida de phase
    FlipFlopT Phase(1'b1 ,reset, clock,phase);
    // se onceta oeoperand de controlSignal bus tri estado y la salida se conecta al bus de datos 
    Triestate   busDriverOprnad(oprnd,controlSignals[1],data_bus);
    //se conecta la memoria ram al bus de datos y se le conectan las señales de weRAM y csRAM ademas del bus de direcciones
    RAM ram(address_RAM,controlSignals[4],controlSignals[5],data_bus);
    //-----------------MODULO DE ALU Y EL ACUMULADOR -------------------------------------------
    wire [3:0] aluOut; //Salida de la alu
    wire c,z; //salidas c y z de la alu
    //se conecta el FF del acumilador a la senial de control respectiva y ademas su salida se conecta a la salida del modulo accu
    FlipFlopD4b acumulador(aluOut, controlSignals[10],reset, clock, accu);

    ALU unidadAritmetica(accu, data_bus,controlSignals[8:6],aluOut,c,z);
    // buffer tri estado que conecta la salida de la alu con el bus de datos
    Triestate aluOuput(aluOut,controlSignals[3],data_bus);
    // ff de banderas
    FlipFlopD2b banderas({c,z},controlSignals[9],reset, clock, {c_flag,z_flag});
    //---------------------------- PUERTOS DE SALIDA -------------------------------------------
    FlipFlopD4b salida(data_bus, controlSignals[0],reset,clock, FF_out);
    Triestate in(pushbuttons, controlSignals[2],data_bus);
>>>>>>> parent of 524793e... Resolviendo el problema

endmodule