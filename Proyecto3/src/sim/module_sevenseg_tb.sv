`timescale 1ns/1ps

module module_sevenseg_tb;

    logic [3:0] num;
    logic [6:0] seg;

    // DUT
    module_sevenseg dut (
        .num(num),
        .seg(seg)
    );

    initial begin
        $display("=== Test module_sevenseg ===");

        // Probar algunos valores clave
        num = 4'd0;  #1; $display("num=0  seg=%b", seg);
        num = 4'd5;  #1; $display("num=5  seg=%b", seg);
        num = 4'd9;  #1; $display("num=9  seg=%b", seg);
        num = 4'd10; #1; $display("num=A  seg=%b", seg);
        num = 4'd15; #1; $display("num=F  seg=%b", seg);

        $finish;
    end

endmodule