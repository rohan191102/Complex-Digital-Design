`timescale 1ns / 1ps

module uart_top #(
    parameter OPERAND_WIDTH = 512,
    parameter ADDER_WIDTH   = 32,
    parameter NBYTES        = OPERAND_WIDTH / 8,
    parameter CLK_FREQ      = 125_000_000,
    parameter BAUD_RATE     = 115_200
) (
    input wire iClk, iRst,
    input wire iRx,
    output wire oTx
);
    reg [$clog2(NBYTES):0] rCnt;
    // Buffer and operands for communication
    reg [OPERAND_WIDTH-1:0] rBuffer, rBuffer2;
    reg [OPERAND_WIDTH-1:0] rA, rB;
    
    // FSM and UART TX variables
    reg [2:0] rFSM;  
    reg rTxStart;
    reg [7:0] rTxByte;
    wire wTxBusy, wTxDone;
    
    // UART RX and computation results
    wire [7:0] rRxByte;
    wire wRxDone;
    reg rCompStart;
    reg [((NBYTES+1)*8)-1:0] rRes;
    wire [OPERAND_WIDTH:0] result;
    wire wCompDone;
    reg rCarry;
    
    
    // FSM State definitions 
    localparam s_IDLE                = 3'b000,
               s_WAIT_RX_A           = 3'b001,
               s_WAIT_RX_B           = 3'b010,
               s_COMPUTE             = 3'b011,
               s_WAIT_FOR_COMPLETION = 3'b100,
               s_TX                  = 3'b101,
               s_WAIT_TX             = 3'b110,
               s_DONE                = 3'b111;
    

    // UART modules
    uart_tx #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) UART_TX_INST(
        .iClk(iClk),
        .iRst(iRst),
        .iTxStart(rTxStart),
        .iTxByte(rTxByte),
        .oTxSerial(oTx),
        .oTxBusy(wTxBusy),
        .oTxDone(wTxDone)
    );
    
    uart_rx #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) UART_RX_INST(
        .iClk(iClk),
        .iRst(iRst),
        .oRxByte(rRxByte),
        .oRxDone(wRxDone),
        .iRxSerial(iRx)
    );
    
    // MP Adder instance
    mp_adder #(.OPERAND_WIDTH(OPERAND_WIDTH), .ADDER_WIDTH(ADDER_WIDTH)) MP_ADDER_INST(
        .iClk(iClk),
        .iRst(iRst),
        .iStart(rCompStart),
        .iOpA(rA),
        .iOpB(rB),
        .oRes(result),
        .oDone(wCompDone)
    );
    
    
    // Main FSM
    always @(posedge iClk) begin
        if (iRst) begin
            rFSM <= s_IDLE;
        end else begin
            case (rFSM)
                s_IDLE:
                    begin
                        rFSM <= s_WAIT_RX_A;
                        rTxStart <= 0;
                        rCnt <= 0;
                        rTxByte <= 0;
                        rBuffer <= 0;
                        rBuffer2 <= 0;
                        rCarry <= 0;
                        rCompStart <= 0;
                        rA <=0;
                        rB<=0;
                        rCarry<=0;
                    end
                s_WAIT_RX_A:
                    begin
                        if (wRxDone && rCnt < NBYTES) begin
                            rBuffer <= {rBuffer[OPERAND_WIDTH-9:0], rRxByte};
                            rCnt <= rCnt + 1;
                        end else if (rCnt == NBYTES) begin
                            rFSM <= s_WAIT_RX_B;
                            rCnt <= 0;
                            rA <= rBuffer;
                        end
                    end
                s_WAIT_RX_B:
                    begin
                        if (wRxDone && rCnt < NBYTES) begin
                            rBuffer2 <= {rBuffer2[OPERAND_WIDTH-9:0], rRxByte};
                            rCnt <= rCnt + 1;
                        end else if (rCnt == NBYTES) begin
                            rFSM <= s_COMPUTE;
                            rB <= rBuffer2;
                            rCnt <= 0;
                        end
                    end
                s_COMPUTE:
                    begin
                        rCompStart <= 1;
                        rFSM <= s_WAIT_FOR_COMPLETION;
                    end
                s_WAIT_FOR_COMPLETION:
                    if (wCompDone) begin
                        rRes <= {7'b0000000, result};
                        rFSM <= s_TX;
                    end
                s_TX:
                    if (rCnt < NBYTES+1 && !wTxBusy) begin
                        rFSM <= s_WAIT_TX;
                        rTxStart <= 1;
                        rTxByte <= rRes[((NBYTES+1)*8)-1:((NBYTES+1)*8)-8];
                        rRes <= {rRes[OPERAND_WIDTH-1:0], 8'b00000000};
                        rCnt <= rCnt + 1;
                    end else if (rCnt == NBYTES+1) begin
                        rFSM <= s_DONE;
                    end
                s_WAIT_TX:
                    if (wTxDone) begin
                        rFSM <= s_TX;
                        rTxStart <= 0;
                        rTxByte <= 0;
                    end else begin
                        rFSM <= s_WAIT_TX;
                        rTxStart <= 0;
                    end
                s_DONE:
                    rFSM <= s_IDLE;
                    
                default:
                    rFSM <= s_IDLE;
            endcase
        end
    end

endmodule