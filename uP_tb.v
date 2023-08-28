module testbenchMio();

    reg clock, reset;
    reg [3:0] pushbuttons;
    wire phase, c_flag, z_flag;
    wire [3:0] instr, oprnd, accu, data_bus, FF_out;
    wire [7:0] program_byte;
    wire [11:0] PC, address_RAM;

    uP uPmodule(.clock(clock),
                .reset(reset),
                .pushbuttons(pushbuttons),
                .phase(phase),
                .c_flag(c_flag),
                .z_flag(z_flag),
                .instr(instr),
                .oprnd(oprnd),
                .accu(accu),
                .data_bus(data_bus),
                .FF_out(FF_out),    
                .program_byte(program_byte),
                .PC(PC),
                .address_RAM(address_RAM));

    initial
        #1000 $finish;

    always
        #5 clock = ~clock;

    initial begin
        #1  reset = 1;clock=0;
        #1  reset = 0; pushbuttons = 10;
        #100 $display("el valor en la salida es: %h",FF_out);
    end

    initial begin
        $dumpfile("uP_tb.vcd");
        $dumpvars(0,testbenchMio);
    end

endmodule
