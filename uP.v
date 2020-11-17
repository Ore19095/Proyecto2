
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

    assign inDecode = {instr, c_flag, z_flag, phase };
    FlipFlopT fase(1'b1, reset,clock,phase);
    //decodificador
    Decode  decode(inDecode, controlSignals);
    // ---------------- CONTROL DEL PROGRAMA ----------------------------
    ModuloInstruccion control(address_RAM, controlSignals[11], reset, controlSignals[12], ~phase, clock,
                              instr, opernd, program_byte, PC);

    assign address_RAM= {opernd, program_byte};

endmodule