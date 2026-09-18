module FA_1 (
    input  A,
    input  B,
    input  CI,
    output SUM,
    output CO
);
    assign SUM = A ^ B ^ CI;
    assign CO = (B & CI) | (A & CI) | (A & B);
endmodule
