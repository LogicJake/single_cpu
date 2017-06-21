`timescale 1ns / 1ps
//*************************************************************************
//   > �ļ���: data_mem.v
//   > ����  ���첽���ݴ洢��ģ�飬���üĴ�������ɣ����ƼĴ�����
//   >         ͬ��д���첽��
//   > ����  : LOONGSON
//   > ����  : 2016-04-14
//*************************************************************************
module data_ram(
	 input  [4:0]  ctrl,			//�����ź�
    input         clk,         // ʱ��
//  input  [3:0]  wen,         // �ֽ�дʹ��
    input  [6:0]  addr,       // ��ַ
    input  [31:0] wdata,       // д����
    output [31:0] rdata,       // ������
    
    //���Զ˿ڣ����ڶ���������ʾ
    input  [4 :0] test_addr,
    output reg [31:0] test_data
);

    reg [31:0] DM[31:0];  //���ݴ洢�����ֽڵ�ַ7'b000_0000~7'b111_1111
	 
	 wire ins_sw,ins_lw,ins_lb,ins_lbu,ins_sb;
	 
	 assign ins_sw = ctrl[4];	
	 assign ins_lw = ctrl[3];
	 assign ins_lb = ctrl[2];
	 assign ins_lbu = ctrl[1];
	 assign ins_sb = ctrl[0];
	 
	 wire [3:0] wen;
	 reg [31:0]	rdata_temp;
	 
	 assign wen = ins_sw ? 4'b1111 : 
					  ins_sb & (addr[1:0] == 2'b00) ? 4'b0001 :
					  ins_sb & (addr[1:0] == 2'b01) ? 4'b0010 :
					  ins_sb & (addr[1:0] == 2'b10) ? 4'b0100 :
					  ins_sb & (addr[1:0] == 2'b11) ? 4'b1000 : 4'b0000;

    //д����
    always @(posedge clk)    
    begin
		if(ins_sw)			   //��һ����
		begin
			DM[addr[6:2]]	<= wdata;
		end
		
		if(ins_sb)				//��һ���ֽ� ������ֽ�
		begin
			if (wen[3])
			begin
            DM[addr[6:2]][31:24] <= wdata[7:0];
			end
			
			if (wen[2])
			begin
            DM[addr[6:2]][23:16] <= wdata[7:0];
			end
			
			if (wen[1])
			begin
            DM[addr[6:2]][15: 8] <= wdata[7:0];
			end
			
			if (wen[0])
			begin
            DM[addr[6:2]][7 : 0] <= wdata[7:0];
			end
		end
	 end
    
	 
	 wire [31:0] dm_B_data;
    //������,ȡ4�ֽ�
    always @(*)
    begin
        case (addr[6:2])			//������ȡ����
            5'd0 : rdata_temp <= DM[0 ];
            5'd1 : rdata_temp <= DM[1 ];
            5'd2 : rdata_temp <= DM[2 ];
            5'd3 : rdata_temp <= DM[3 ];
            5'd4 : rdata_temp <= DM[4 ];
            5'd5 : rdata_temp <= DM[5 ];
            5'd6 : rdata_temp <= DM[6 ];
            5'd7 : rdata_temp <= DM[7 ];
            5'd8 : rdata_temp <= DM[8 ];
            5'd9 : rdata_temp <= DM[9 ];
            5'd10: rdata_temp <= DM[10];
            5'd11: rdata_temp <= DM[11];
            5'd12: rdata_temp <= DM[12];
            5'd13: rdata_temp <= DM[13];
            5'd14: rdata_temp <= DM[14];
            5'd15: rdata_temp <= DM[15];
            5'd16: rdata_temp <= DM[16];
            5'd17: rdata_temp <= DM[17];
            5'd18: rdata_temp <= DM[18];
            5'd19: rdata_temp <= DM[19];
            5'd20: rdata_temp <= DM[20];
            5'd21: rdata_temp <= DM[21];
            5'd22: rdata_temp <= DM[22];
            5'd23: rdata_temp <= DM[23];
            5'd24: rdata_temp <= DM[24];
            5'd25: rdata_temp <= DM[25];
            5'd26: rdata_temp <= DM[26];
            5'd27: rdata_temp <= DM[27];
            5'd28: rdata_temp <= DM[28];
            5'd29: rdata_temp <= DM[29];
            5'd30: rdata_temp <= DM[30];
            5'd31: rdata_temp <= DM[31];
        endcase
    end
	 
	
	 assign dm_B_data[7:0] = (addr[1:0] == 2'b00) ? rdata_temp[ 7:0  ] :
									 (addr[1:0] == 2'b01) ? rdata_temp[ 15:8 ] :
									 (addr[1:0] == 2'b10) ? rdata_temp[ 23:16] :
									 (addr[1:0] == 2'b11) ? rdata_temp[ 31:24] : 8'd0;
	 
	 assign dm_B_data[31:8] = ins_lb ? {24{dm_B_data[7]}} : 24'd0;		//����Ƿ�����չ��ȡ����λ������ȫ��0
	 assign rdata = ins_lw ? rdata_temp : dm_B_data;						//LWָ���ֱ��ȡ,������ֽ�
	 
	 
    //���Զ˿ڣ������ض��ڴ������
    always @(*)
    begin
        case (test_addr)
            5'd0 : test_data <= DM[0 ];
            5'd1 : test_data <= DM[1 ];
            5'd2 : test_data <= DM[2 ];
            5'd3 : test_data <= DM[3 ];
            5'd4 : test_data <= DM[4 ];
            5'd5 : test_data <= DM[5 ];
            5'd6 : test_data <= DM[6 ];
            5'd7 : test_data <= DM[7 ];
            5'd8 : test_data <= DM[8 ];
            5'd9 : test_data <= DM[9 ];
            5'd10: test_data <= DM[10];
            5'd11: test_data <= DM[11];
            5'd12: test_data <= DM[12];
            5'd13: test_data <= DM[13];
            5'd14: test_data <= DM[14];
            5'd15: test_data <= DM[15];
            5'd16: test_data <= DM[16];
            5'd17: test_data <= DM[17];
            5'd18: test_data <= DM[18];
            5'd19: test_data <= DM[19];
            5'd20: test_data <= DM[20];
            5'd21: test_data <= DM[21];
            5'd22: test_data <= DM[22];
            5'd23: test_data <= DM[23];
            5'd24: test_data <= DM[24];
            5'd25: test_data <= DM[25];
            5'd26: test_data <= DM[26];
            5'd27: test_data <= DM[27];
            5'd28: test_data <= DM[28];
            5'd29: test_data <= DM[29];
            5'd30: test_data <= DM[30];
            5'd31: test_data <= DM[31];
        endcase
    end
endmodule
