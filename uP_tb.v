module testbench();

    reg clk, res,enable,load;
    reg [11:0] carga;

    wire[11:0] out;

    Contador12b cont(load,enable,clk,res,carga,out);

    always  #1 clk <= ~clk;
    initial clk =0 ; //se inicializa el reloj

    initial begin
        res =0; enable = 0; load = 0; carga = 0;
        #1 res =1;
        #1 res = 0;
        #2 enable = 1;
        #50 res = 1;
        #2  res = 0;
        #10 carga = 255; 
        #4  load = 1;
        #10 load = 0;
        #10 enable = 0;
        #10 enable = 1;
        #10 res = 1;
        #2  res = 0;
        #10 carga = 4090;
        #1  load = 1;
        #4  load = 0;
        #4  enable = 0;
        #2  enable = 1;
        #35 $finish;
    end

    initial begin
        $dumpfile("uP_tb.vcd");
        $dumpvars(0,testbench);
    end


endmodule