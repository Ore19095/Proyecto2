module uP(input  clock, reset, input [3:0] pushbuttons, output [11:0] PC, address_RAM, output [7:0] program_byte,
          output [3:0] instr, oprnd, data_bus, FF_out, accu, output phase, c_flag, z_flag);
   
    
    // estos con cables que son usados para conectar las salidas de decode
    wire loadPC;
    wire incPC;
    wire loadA;
    wire loadFlags;
    wire [2:0] opALU;
    wire cs;
    wire we;
    wire oeALU;
    wire oeIn;
    wire oeOprnd;
    wire loadOut;
    wire [12:0] outDecode;
    wire [6:0] inDecode;


    assign inDecode = {instr, c_flag,z_flag,phase}; 
    Decode dec(inDecode, outDecode);
    //se asignaa cada cable el valor de la salida del decode
    assign incPC = outDecode[12];
    assign loadPC = outDecode[11];
    assign loadA = outDecode[10];
    assign loadFlags = outDecode[9];
    assign opALU = outDecode[8:6];
    assign cs = outDecode[5];
    assign we = outDecode[4];
    assign oeALU = outDecode[3];
    assign oeIn = outDecode [2];
    assign oeOprnd = outDecode [1];
    assign loadOut = outDecode[0];

    assign address_RAM = {oprnd,program_byte};
    //------------------ CONTROL DEL PROGRAMA -------------------------------
    Contador12b programCouter(loadPC,incPC, clock, reset, address_RAM, PC ); //program counter
    Memory  programROM(PC, program_byte); // memoria de programa
    FlipFlopD4b fetchOp(program_byte[3:0], ~phase, reset, clock, oprnd);
    FlipFlopD4b  fetchIns(program_byte[7:4], ~phase, reset, clock, instr);
    FlipFlopT   fase(1'b1, reset, clock, phase);
    //-----------------------------------------------------------------------
    //------------------- MANEJO DE DATOS------------------------------------
    wire[3:0] outAlu;
    wire c,z;
    Triestate bufferOprnd(oprnd,oeOprnd,data_bus);
    Triestate bufferIn(pushbuttons,oeIn,data_bus);
    Triestate bufferAlu(outAlu,oeALU, data_bus);

    RAM ram(address_RAM,cs,we,data_bus);
    //------------------- ALU ----------------------------------------------
    FlipFlopD4b accumulador(outAlu, loadA,reset, clock, accu );
    ALU unidadAritmetica(accu,data_bus, opALU, outAlu,c , z);

    FlipFlopD1b flagsC(c,loadFlags,reset, clock, c_flag);
    FlipFlopD1b flagsZ(z,loadFlags,reset, clock, z_flag);
    //--------------- Salida -----------------------------------------------
    FlipFlopD4b salida(data_bus,loadOut, reset, clock, FF_out );
    
    

endmodule