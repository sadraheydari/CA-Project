module CU(
    input clk,
    input[5:0] opcode,
    input equ, 
    input les,
    output reg[2:0] im_control,
    output reg[3:0] alu_control,
    output reg dm_control,
    output reg [6:0] sel
    );

    reg[2:0] counter;
    initial begin
        counter = 3'd7;
    end

    always @ (posedge clk) begin
        if (counter == 3'd7) begin
            counter = 3'd0;

            if (opcode >= 6'd28 & opcode <= 6'd31) begin // instruction memory R1
                im_control[0] = 0;
            end else begin
                im_control[0] = 1;
            end

            if (opcode >= 6'd1 & opcode <= 6'd15) begin // instruction memory R2
                im_control[2:1] = 2'd2;
            end else if (opcode >= 6'd24 & opcode <= 6'd27) begin
                im_control[2:1] = 2'd1;
            end else begin
                im_control[2:1] = 2'd0;
            end  

            if (opcode == 6'd25 | opcode == 6'd27) begin // data memory write enable
                dm_control = 1;
            end else begin
                dm_control = 0;
            end

            if (opcode == 6'd28) begin // pc input mux  (mux 0)
                sel[2:0] = 3'd0;
            end else if (opcode == 6'd30 | opcode == 6'd31) begin
                sel[2:0] = 3'd1;
            end else if (opcode == 6'd29) begin
                sel[2:0] = 3'd2;
            end else if (opcode == 6'd0) begin
                sel[2:0] = 3'd4;
            end else begin
                sel[2:0] = 3'd3;
            end

            if (opcode >= 6'd18 & opcode <= 6'd27) begin // alu in2 mux (mux 1)
                sel[3] = 0;
            end else begin
                sel[3] = 1;
            end

            if (opcode == 6'd27) begin // data memory write data input (mux 2)
                sel[4] = 0;
            end else begin
                sel[4] = 1;
            end

            if (opcode == 6'd26) begin // register memory write back data (mux 3)
                sel[6:5] = 2'd0;
            end else if (opcode == 6'd17) begin
                sel[6:5] = 2'd1;
            end else if (opcode == 6'd24 | opcode == 6'd26) begin
                sel[6:5] = 2'd3;
            end else begin
                sel[6:5] = 2'd2;
            end
            

            if (opcode >= 6'b000001 & opcode <= 6'b001111) begin // ALU function
                alu_control = opcode[3:0];
            end else if (opcode >= 6'b010000 & opcode <= 6'b010111) begin  // Immidiade ALU
                if (opcode == 6'b010000)        // LDI
                    alu_control = 4'b0001;
                else if (opcode == 6'b010001)   // LDUI
                    alu_control = 4'b0001;
                else if (opcode == 6'b010010)   // ADDI
                    alu_control = 4'b0001;
                else if (opcode == 6'b010011)   // SUBI
                    alu_control = 4'b0010;
                else if (opcode == 6'b010100)   // MULI
                    alu_control == 4'b0011;
                else if (opcode == 6'b010101)   // DIVI
                    alu_control = 4'b0100;
                else if (opcode == 6'b010110)   // NANDI
                    alu_control = 4'1001;
                else if (opcode == 6'b010111)   // XNORI
                    alu_control = 4'b1010;
            end else begin
                alu_control = 4'b0000;
            end

        end else begin
            counter = counter + 1;
        end    
    end
endmodule