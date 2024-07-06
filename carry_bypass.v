module carry_bypass #(parameter ADDER_WIDTH = 32) (
    input [ADDER_WIDTH-1:0] iA, iB,
    input iCarry,
    output [ADDER_WIDTH-1:0] oSum,
    output oCarry
);

    // Internal wires
    wire [ADDER_WIDTH-1:0] sum1, sum2;
    wire [ADDER_WIDTH:0] propagate, GENERATE;

    // Generate propagate and generate signals
    assign propagate = iA | iB;
    assign GENERATE = {1'b0, propagate} + {propagate, 1'b0};

    // First stage of addition
    ripple_carry_adder_Nb #(.ADDER_WIDTH(ADDER_WIDTH)) adder1 (
        .iA(iA),
        .iB(iB),
        .iCarry(iCarry),
        .oSum(sum1),
        .oCarry()
    );

    // Second stage of addition with carry-bypass
    ripple_carry_adder_Nb #(.ADDER_WIDTH(ADDER_WIDTH)) adder2 (
        .iA(sum1),
        .iB({ADDER_WIDTH{1'b0}}), // Zero input for the second stage
        .iCarry(iCarry), // Connect the carry-out of the first stage
        .oSum(sum2),
        .oCarry()
    );

    // Final sum with carry-bypass logic
    assign oSum = GENERATE[ADDER_WIDTH] ? sum2 : sum1; // Select sum2 if carry is generated
    assign oCarry = GENERATE[ADDER_WIDTH] | (propagate[ADDER_WIDTH] & iCarry);

endmodule
