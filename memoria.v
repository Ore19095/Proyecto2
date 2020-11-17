module Memory(input wire [11:0] address, output wire [7:0] data );

    reg[7:0] memoria[4095:0];

    initial begin
        $readmemh("datos.mem",memoria);
    end

    assign  data = memoria[address];

endmodule