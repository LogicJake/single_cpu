`timescale 1ns / 1ps
//*************************************************************************
//   > ÎÄ¼þÃû: inst_rom.v
//   > ÃèÊö  £ºÒì²½Ö¸Áî´æ´¢Æ÷Ä£¿é£¬²ÉÓÃ¼Ä´æÆ÷´î½¨¶ø³É£¬ÀàËÆ¼Ä´æÆ÷¶Ñ
//   >         ÄÚÇ¶ºÃÖ¸Áî£¬Ö»¶Á£¬Òì²½¶Á
//   > ×÷Õß  : LOONGSON
//   > ÈÕÆÚ  : 2016-04-14
//*************************************************************************
module inst_rom(
    input      [9 :0] addr, // Ö¸ÁîµØÖ·
    output reg [31:0] inst       // Ö¸Áî
    );

    wire [31:0] inst_rom[1024:0];  // Ö¸Áî´æ´¢Æ÷£¬×Ö½ÚµØÖ·7'b000_0000~7'b111_1111
    //------------- Ö¸Áî±àÂë ---------|Ö¸ÁîµØÖ·|--- »ã±àÖ¸Áî -----|- Ö¸Áî½á¹û -----//
    // assign inst_rom[ 0] = 32'h24010001; // 00H: addiu $1 ,$0,#1   | $1 = 0000_0001H
    // assign inst_rom[ 1] = 32'h00011100; // 04H: sll   $2 ,$1,#4   | $2 = 0000_0010H
    // assign inst_rom[ 2] = 32'h00411821; // 08H: addu  $3 ,$2,$1   | $3 = 0000_0011H
    // assign inst_rom[ 3] = 32'h00022082; // 0CH: srl   $4 ,$2,#2   | $4 = 0000_0004H
    // assign inst_rom[ 4] = 32'h00642823; // 10H: subu  $5 ,$3,$4   | $5 = 0000_000DH
    // assign inst_rom[ 5] = 32'hAC250013; // 14H: sw    $5 ,#19($1) | Mem[0000_0014H] = 0000_000DH
    // assign inst_rom[ 6] = 32'h00A23027; // 18H: nor   $6 ,$5,$2   | $6 = FFFF_FFE2H
    // assign inst_rom[ 7] = 32'h00C33825; // 1CH: or    $7 ,$6,$3   | $7 = FFFF_FFF3H
    // assign inst_rom[ 8] = 32'h00E64026; // 20H: xor   $8 ,$7,$6   | $8 = 0000_0011H
    // assign inst_rom[ 9] = 32'hAC08001C; // 24H: sw    $8 ,#28($0) | Mem[0000_001CH] = 0000_0011H
    // assign inst_rom[10] = 32'h00C7482A; // 28H: slt   $9 ,$6,$7   | $9 = 0000_0001H
    // assign inst_rom[11] = 32'h11210002; // 2CH: beq   $9 ,$1,#2   | Ìø×ªµ½Ö¸Áî34H
    // assign inst_rom[12] = 32'h24010004; // 30H: addiu $1 ,$0,#4   | ²»Ö´ÐÐ
    // assign inst_rom[13] = 32'h8C2A0013; // 34H: lw    $10,#19($1) | $10 = 0000_000DH
    // assign inst_rom[14] = 32'h15450003; // 38H: bne   $10,$5,#3   | ²»Ìø×ª
    // assign inst_rom[15] = 32'h00415824; // 3CH: and   $11,$2,$1   | $11 = 0000_0000H
    // assign inst_rom[16] = 32'hAC0B001C; // 40H: sw    $11,#28($0) | Men[0000_001CH] = 0000_0000H
    // assign inst_rom[17] = 32'hAC040010; // 44H: sw    $4 ,#16($0) | Mem[0000_0010H] = 0000_0004H
    // assign inst_rom[18] = 32'h3C0C000C; // 48H: lui   $12,#12     | [R12] = 000C_0000H
    // assign inst_rom[19] = 32'h08000000; // 4CH: j     00H         | Ìø×ªÖ¸Áî00H
	 
	 assign inst_rom[ 0] = 32'h24010001; 		
	 assign inst_rom[ 1] = 32'h00011100;
	 assign inst_rom[ 2] = 32'h00411821;
	 assign inst_rom[ 3] = 32'h00022082;
	 assign inst_rom[ 4] = 32'h28990005;
	 assign inst_rom[ 5] = 32'h0721000f;
	 assign inst_rom[ 6] = 32'h00642823;
	 assign inst_rom[ 7] = 32'hac050014;
	 assign inst_rom[ 8] = 32'h00a23027;
	 assign inst_rom[ 9] = 32'h00c33825;
	 assign inst_rom[ 10] = 32'h00e64026;
	 assign inst_rom[ 11] = 32'hac08001c;
	 assign inst_rom[ 12] = 32'h11030001;
	 assign inst_rom[ 13] = 32'h00c7482a;
	 assign inst_rom[ 14] = 32'h24010008;
	 assign inst_rom[ 15] = 32'h8c2a0014;
	 assign inst_rom[ 16] = 32'h15450003;
	 assign inst_rom[ 17] = 32'h00415824;
	 assign inst_rom[ 18] = 32'hac2b001c;
	 assign inst_rom[ 19] = 32'hac240010;
	 assign inst_rom[ 20] = 32'h0c000019;
	 assign inst_rom[ 21] = 32'h3c0c000c;
	 assign inst_rom[ 22] = 32'h004cd007;
	 assign inst_rom[ 23] = 32'h003ad804;
	 assign inst_rom[ 24] = 32'h0360f809;
	 assign inst_rom[ 25] = 32'ha07a0005;
	 assign inst_rom[ 26] = 32'h0063682b;
	 assign inst_rom[ 27] = 32'h1da0fffd;
	 assign inst_rom[ 28] = 32'h00867004;
	 assign inst_rom[ 29] = 32'h000e7883;
	 assign inst_rom[ 30] = 32'h002f8006;
	 assign inst_rom[ 31] = 32'h1a00fff5;
	 assign inst_rom[ 32] = 32'h002f8007;
	 assign inst_rom[ 33] = 32'h240b008c;
	 assign inst_rom[ 34] = 32'h256b0008;
	 assign inst_rom[ 35] = 32'h8d5c0003;
	 assign inst_rom[ 36] = 32'h179d0004;
	 assign inst_rom[ 37] = 32'ha0af0008;
	 assign inst_rom[ 38] = 32'h80b20008;
	 assign inst_rom[ 39] = 32'h90b30008;
	 assign inst_rom[ 40] = 32'h256b001c;
	 assign inst_rom[ 41] = 32'h2df8ffff;
	 assign inst_rom[ 42] = 32'h0185e825;
	 assign inst_rom[ 43] = 32'h01600008;
	 assign inst_rom[ 44] = 32'h3c01ffff;
	 assign inst_rom[ 45] = 32'h3421ffff;
	 assign inst_rom[ 46] = 32'h01e1a024;
	 assign inst_rom[ 47] = 32'h3c01ffff;
	 assign inst_rom[ 48] = 32'h3421ffff;
	 assign inst_rom[ 49] = 32'h01e1a825;
	 assign inst_rom[ 50] = 32'h3c01ffff;
	 assign inst_rom[ 51] = 32'h3421ffff;
	 assign inst_rom[ 52] = 32'h01e1b026;
	 assign inst_rom[ 53] = 32'h08000000;
	 

    //¶ÁÖ¸Áî,È¡4×Ö½Ú
    always @(*)
    begin
        // case (addr)
        //     5'd0 : inst <= inst_rom[0 ];
        //     5'd1 : inst <= inst_rom[1 ];
        //     5'd2 : inst <= inst_rom[2 ];
        //     5'd3 : inst <= inst_rom[3 ];
        //     5'd4 : inst <= inst_rom[4 ];
        //     5'd5 : inst <= inst_rom[5 ];
        //     5'd6 : inst <= inst_rom[6 ];
        //     5'd7 : inst <= inst_rom[7 ];
        //     5'd8 : inst <= inst_rom[8 ];
        //     5'd9 : inst <= inst_rom[9 ];
        //     5'd10: inst <= inst_rom[10];
        //     5'd11: inst <= inst_rom[11];
        //     5'd12: inst <= inst_rom[12];
        //     5'd13: inst <= inst_rom[13];
        //     5'd14: inst <= inst_rom[14];
        //     5'd15: inst <= inst_rom[15];
        //     5'd16: inst <= inst_rom[16];
        //     5'd17: inst <= inst_rom[17];
        //     5'd18: inst <= inst_rom[18];
        //     5'd19: inst <= inst_rom[19];
        //     default: inst <= 32'd0;
        // endcase
        inst <= inst_rom[addr];
    end
endmodule