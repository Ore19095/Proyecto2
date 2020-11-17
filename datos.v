module Acumulator(input wire [3:0] D,input wire load, reset, clk, output reg[3:0] Q );

    always @(posedge clk, posedge reset) begin
        
        if (reset) Q = 0; //si esta en reset la salida es 0
        else if(load) begin //si load es 1 en el siguiente flanco de reloj deja pasar D a Q
            Q <= D;
        end

    end
endmodule

module ALU(input wire[3:0] A,B,input [2:0] control , output wire [3:0] out, output wire C, Z );
    reg[4:0] resultado; //registro en el cual se almacena el resultado
    assign Z = ~(resultado[0] | resultado[1] | resultado[2] | resultado[3]); 
    // siempre qque todos los bits de out sean 0 Z va a ser 1 en caso contrario sera 0
    assign out = resultado[4:0]; //la salida son los 4 bits menos significativos de resultado
    assign C = resultado[4] ;//C es el ultimo bit (el de acarreo) de la operacion

    always @ (A,B,control) begin  // siempre qeu cambie A, B o Control se ejecuta
        case(control)
            3'b000: resultado <= A; //deja pasar A
            3'b001: resultado <= A -B;  //resta a y B 
            3'b010: resultado <= B; // deja pasar B
            3'b011: resultado <= A + B; //suma a y b
            3'b100: resultado <= ~(A|B); // NOR A y B
            default: resultado <= 0; //si se ingresara cualquier otra combinacion
        endcase
    end
endmodule

module Procesamiento(input wire[3:0] dataIn,input wire[2:0] control,
                      input wire  enableOutALU, loadAcu, reset, clk, output wire[3:0] dataOut, output wire C,Z);

    wire [3:0] data; //bus de datos, salida de la ALU
    
    wire [3:0] acuOut; //salida del acumulador

    
    Triestate busDriverOut(data,enableOutALU,dataOut);

    Acumulator acu(data,loadAcu,reset,clk,acuOut);

    ALU aritmetica(acuOut,dataIn,control,data,C,Z);


endmodule