module Contador12b(input wire  load,enable,clk,reset, input wire [11:0]valueLoad, output reg [11:0] out );

    always @ (posedge clk, posedge reset, posedge load) begin
        if (load) out <= valueLoad;
        else begin
            if (reset) out <= 0;
            else if(enable) out <= out + 1;
        end 
    end
endmodule