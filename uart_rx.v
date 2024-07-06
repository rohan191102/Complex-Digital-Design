//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2024 21:35:45
// Design Name: 
// Module Name: uart_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module uart_rx #(
  parameter   CLK_FREQ      = 125_000_000,
  parameter   BAUD_RATE     = 115_200,
  parameter   CLKS_PER_BIT  = CLK_FREQ / BAUD_RATE
)
(
  input wire        iClk, iRst,
  input wire        iRxSerial,
  output wire [7:0] oRxByte, 
  output wire       oRxDone
);

    localparam sIDLE = 3'b000;
    localparam sRX_START = 3'b001;
    localparam sRX_DATA = 3'b011;
    localparam sRX_STOP = 3'b010;
    localparam sRX_DONE = 3'b110;

    reg [2:0] rFSM_Current, wFSM_Next; 
    reg [$clog2(CLKS_PER_BIT):0]   rCnt_Current, wCnt_Next;
    reg [2:0] rBit_Current, wBit_Next;
    reg [7:0] rRxData_Current, wRxData_Next;
    reg rRx1, rRx2;
    
    always @(posedge iClk)
    begin
      rRx1 <= iRxSerial;
      rRx2 <= rRx1;
    end


always@(posedge iClk)
begin
    if(iRst == 1)
    begin
        rFSM_Current <= sIDLE;
        rCnt_Current <= 0;
        rBit_Current <= 0;
        rRxData_Current <= 0;
    end
    else
    begin
        rFSM_Current <= wFSM_Next;
        rCnt_Current <= wCnt_Next;
        rBit_Current <= wBit_Next;
        rRxData_Current <= wRxData_Next;
    end
end

always@(*)
begin
    case(rFSM_Current)
    sIDLE:
        begin
            wCnt_Next = 0;
            wBit_Next = 0;
            wRxData_Next = 0;
            
            if(rRx2 == 0)
                wFSM_Next = sRX_START;
            else
                wFSM_Next = sIDLE;
        end
    
    sRX_START:
        begin
            wBit_Next = 0;
            wRxData_Next = rRxData_Current;
            
            if(rCnt_Current < (CLKS_PER_BIT - 1)/2)
            begin
                wFSM_Next = sRX_START;
                wCnt_Next = rCnt_Current + 1;
            end
            else if((rCnt_Current == (CLKS_PER_BIT - 1)/2) && (rRx2 == 1))
            begin
                wFSM_Next = sIDLE;
                wCnt_Next = 0;
            end 
            else if(rCnt_Current ==CLKS_PER_BIT - 1)
            begin
                wFSM_Next = sRX_DATA;
                wCnt_Next = 0;
            end
            else
            begin
                wFSM_Next = sRX_START;
                wCnt_Next = rCnt_Current + 1;
            end
        end    
        
    sRX_DATA:
        begin
            if(rCnt_Current < (CLKS_PER_BIT - 1)/2)
            begin
                wFSM_Next = sRX_DATA;
                wCnt_Next = rCnt_Current + 1;
                wBit_Next = rBit_Current;
                wRxData_Next = rRxData_Current;
            end
            else if(rCnt_Current == (CLKS_PER_BIT -1)/2)
            begin
                wFSM_Next = sRX_DATA;
                wRxData_Next = {rRx2 ,rRxData_Current[7:1]};
                wCnt_Next = rCnt_Current + 1;
                wBit_Next = rBit_Current;
            end
            else if((rCnt_Current == CLKS_PER_BIT - 1) && (rBit_Current != 7))
            begin
                wRxData_Next = rRxData_Current;
                wFSM_Next = sRX_DATA;
                wCnt_Next = 0;
                wBit_Next = rBit_Current + 1;
            end
            else if((rCnt_Current == CLKS_PER_BIT - 1) && (rBit_Current == 7))
            begin
                wRxData_Next = rRxData_Current;
                wFSM_Next = sRX_STOP;
                wCnt_Next = 0;
                wBit_Next = 0;
            end
            else
            begin
                wFSM_Next = sRX_DATA;
                wCnt_Next = rCnt_Current + 1;
                wBit_Next = rBit_Current;
                wRxData_Next = rRxData_Current;
            end
        end
        
        sRX_STOP:
        begin
            wBit_Next = 0;
            wRxData_Next = rRxData_Current;
            if(rCnt_Current < (CLKS_PER_BIT-1)/2)
            begin
                wFSM_Next = sRX_STOP;
                wCnt_Next = rCnt_Current + 1;
            end
            else if((rCnt_Current == (CLKS_PER_BIT - 1)/2) && (rRx2 == 0))
            begin
                wFSM_Next = sIDLE;
                wCnt_Next = 0;
            end 
            else if(rCnt_Current ==CLKS_PER_BIT - 1)
            begin
                wFSM_Next = sRX_DONE;
                wCnt_Next = 0;
            end
            else
            begin
                wFSM_Next = sRX_STOP;
                wCnt_Next = rCnt_Current + 1;
            end
        end
        
        sRX_DONE:
        begin
            wFSM_Next = sIDLE;
            wCnt_Next = 0;
            wBit_Next = 0;
            wRxData_Next = rRxData_Current;
        end
        
        default:
        begin
            wFSM_Next = sIDLE;
            wCnt_Next = 0;
            wBit_Next = 0;
            wRxData_Next = 0;
        end
     endcase
end

assign oRxByte =  rRxData_Current;

assign oRxDone = (rFSM_Current == sRX_DONE)? 1 : 0;

   
endmodule
