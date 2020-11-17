
module Fetch(input wire[7:0] D,input wire enabled, reset, clk, output reg[3:0] instr, operand);
    // Flip Flop tipo D de 8 bits

    always @ (posedge clk, posedge reset) begin
        
        if (reset) begin  //cuando reset es 1 las salidas se colocan en 0
            instr <= 0;  
            operand <= 0;
        end
        else if (enabled) begin // si enabled esta en 1 deja pasar los bits 4-7 a instr y 0-3 a operand
            instr <= D[7:4];
            operand <= D[3:0];
        end
    end
endmodule

module ModuloInstruccion(input wire [11:0] valueLoad, input load, reset, enableCounter, enableFetch, clk,
                         output wire [3:0] instr, operand, output wire [7:0] programByte, output wire [11:0] valueCounter);


    
    Contador12b programCounter(load ,enableCounter, clk, reset, valueLoad, valueCounter); //conexion entre 
    Memory rom(valueCounter, programByte); //conexion entre memoria y el program counter
    Fetch   fetch(programByte, enableFetch, reset, clk, instr , operand); //conexion del fetch con la memoria

endmodule

