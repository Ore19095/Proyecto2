// Laboritorio 8 Ejercicio 01
module Contador12b(input wire  load,enable,clk,reset, input wire [11:0]valueLoad, output reg [11:0] out );

    always @ (posedge clk, posedge reset, posedge load) begin
        if (load) out <= valueLoad; //si load esta encendido deja pasar a la salida valueLoad
        else begin // en caso contrario, si reset esta en 1, en 0 se coloca la salida, en caso contrario
            if (reset) out <= 0;// si enable es 1 el contador incrementa en 1 cada flanco
            else if(enable) out <= out + 1;
        end 
    end
endmodule