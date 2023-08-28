// en este documento se encuentran todos los modulos que se usaran en el microprocesador
// ------------------ CONTADORES ---------------------------------------------------------------

module Contador12b(input wire  load,enable,clk,reset, input wire [11:0]valueLoad, output reg [11:0] out );

    always @ (posedge clk, posedge reset) begin
        if (load) out <= valueLoad;// de lo contrario se revisa reset si es un entonces la salida es 0
        else if (reset) out <= 0;//de lo contrario se revisa enable y si es 1 la salida se le aumenta 1
        else if(enable) out <= out + 1;// si es 1 entonces se asigna el valor cargado a la salida
            else out <= out;
    end
endmodule

//------------ AQUI VAN LOS FLIP FLOPS ----------------------------------------------------------
module  FlipFlopD1b(input d,enable,reset,clk,output reg q);

    always @(posedge clk, posedge reset) begin  //reset asincrono
        if (reset) q = 0; // si el reset esta activado la salida se coloca en 0
        else if (enable) q = d; //si reset esta en 0 y ademas esta enable en 1, entonces deja pasar d a q
    end

endmodule

module FlipFlopD2b(input wire [1:0] d, input wire enable, reset, clk, output reg [1:0] q );

    always @(posedge clk, posedge reset) begin  //reset asincrono
        if (reset) q = 0; // si el reset esta activado la salida se coloca en 0
        else if (enable) q = d; //si reset esta en 0 y ademas esta enable en 1, entonces deja pasar d a q
    end

endmodule

module FlipFlopD4b(input [3:0] d, input wire enable, reset, clk, output reg [3:0] q );

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

//---------------- MEMORIAS  --------------------------------------
module Memory(input wire [11:0] address, output wire [7:0] data );

    reg[7:0] memoria[4095:0];

    initial begin
        $readmemh("memory.list",memoria); // se lee la memoria
    end

    assign  data = memoria[address];

endmodule

module RAM(input [11:0] address, input cs, input we, inout[3:0] data );
    reg [3:0] dataOut;
    reg [3:0] ram[4095:0];

    assign data = (cs & ~we) ? dataOut : 4'bzzzz; // si cs es 1 y we es 0 se le asigna el valor de dataOut de lo contradio esta en z

    always @(address, cs, we, data) begin
        if(cs & ~we) dataOut = ram[address]; //si esta seleccionado pero no habilitado para escritura coloca enla salida lo de la direccion
        else if(cs & we) ram[address] = data;
    end

endmodule

module Decode(input[6:0] address,output reg [12:0] value );

    always @(address) begin
        
        casez(address)

        7'b??????0 : value = 13'b1000000001000;
        7'b00001?1 : value = 13'b0100000001000;
        7'b00000?1 : value = 13'b1000000001000;
        7'b00011?1 : value = 13'b1000000001000;
        7'b00010?1 : value = 13'b0100000001000;
        7'b0010??1 : value = 13'b0001001000010;
        7'b0011??1 : value = 13'b1001001100000;
        7'b0100??1 : value = 13'b0011010000010;
        7'b0101??1 : value = 13'b0011010000100;
        7'b0110??1 : value = 13'b1011010100000;
        7'b0111??1 : value = 13'b1000000111000;
        7'b1000?11 : value = 13'b0100000001000;
        7'b1000?01 : value = 13'b1000000001000;
        7'b1001?11 : value = 13'b1000000001000;
        7'b1001?01 : value = 13'b0100000001000;
        7'b1010??1 : value = 13'b0011011000010;
        7'b1011??1 : value = 13'b1011011100000;
        7'b1100??1 : value = 13'b0100000001000;
        7'b1101??1 : value = 13'b0000000001001;
        7'b1110??1 : value = 13'b0011100000010;
        7'b1111??1 : value = 13'b1011100100000;
        default : value = 0; // si se ingresa cualquier otra direccion la salida es 0

        endcase


    end


endmodule
//--------------- OTROS MODULOS ----------------------------------
module Triestate(input [3:0] in, input enable, output wire [3:0] y );
    // en general si  enable se encuentra en 0  la salida se coloca 
    // en valor flotante, y en cambio si el bit de enable esta en 1 deja pasar el valor
    // del bit in, a ey
    assign y[0] = (enable? in[0] : 1'bz );
    assign y[1] = (enable? in[1] : 1'bz );
    assign y[2] = (enable? in[2] : 1'bz );
    assign y[3] = (enable? in[3] : 1'bz );

endmodule

module ALU(input wire[3:0] A,B,input [2:0] control , output wire [3:0] out, output wire C, Z );
    reg[4:0] resultado; //registro en el cual se almacena el resultado
    assign Z = ~(resultado[0] | resultado[1] | resultado[2] | resultado[3]); 
    // siempre qque todos los bits de out sean 0 Z va a ser 1 en caso contrario sera 0
    assign out = resultado[3:0]; //la salida son los 4 bits menos significativos de resultado
    assign C = resultado[4] ;//C es el ultimo bit (el de acarreo) de la operacion

    always @ (A,B,control) begin  // siempre qeu cambie A, B o Control se ejecuta
        case(control)
            3'b000: resultado <= A; //deja pasar A
            3'b001: resultado <= A - B;  //resta a y B 
            3'b010: resultado <= B; // deja pasar B
            3'b011: resultado <= A + B; //suma a y b
            3'b100: resultado <= {1'b0, ~(A  & B)} ; // NAND A y B
            default: resultado <= 0; //si se ingresara cualquier otra combinacion
        endcase
    end
endmodule