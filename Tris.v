module Triestate(input [3:0] in,input wire enable, output wire [3:0] y );
    // en general si el bit n de enable se encuentra en 0 el bit n de la salida se coloca 
    // en valor flotante, y en cambio si el bit n de enable esta en 1 deja pasar el valor
    // del bit n de in, a el bit n de y
    assign y[0] = (enable ? in[0] : 1'bz );
    assign y[1] = (enable ? in[1] : 1'bz );
    assign y[2] = (enable ? in[2] : 1'bz );
    assign y[3] = (enable ? in[3] : 1'bz );

endmodule