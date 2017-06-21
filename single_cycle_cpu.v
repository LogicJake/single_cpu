`timescale 1ns / 1ps
//*************************************************************************
//   > �ļ���: single_cycle_cpu.v
//   > ����  :������CPUģ�飬��ʵ��16��ָ��
//   >        ָ��rom������ram�������첽�����ݣ��Ա㵥����CPU��ʵ��
//   > ����  : LOONGSON
//   > ����  : 2016-04-14
//*************************************************************************
`define STARTADDR 32'd0  // ������ʼ��ַ
module single_cycle_cpu(
    input clk,    // ʱ��
    input resetn,  // ��λ�źţ��͵�ƽ��Ч

    //display data
    input  [ 4:0] rf_addr,
    input  [31:0] mem_addr,
    output [31:0] rf_data,
    output [31:0] mem_data,
    output [31:0] cpu_pc,
    output [31:0] cpu_inst
    );


//---------------------------------t{ȡָ}begin------------------------------------//
    reg  [31:0] pc;
    wire [31:0] next_pc;
    wire [31:0] seq_pc;
    wire [31:0] jbr_target;
    wire jbr_taken;

    // ��һָ���ַ��seq_pc=pc+4
    assign seq_pc[31:2]    = pc[31:2] + 1'b1;
    assign seq_pc[1:0]     = pc[1:0];
    // ��ָ���ָ����ת��Ϊ��ת��ַ������Ϊ��һָ��
    assign next_pc = jbr_taken ? jbr_target : seq_pc;
    always @ (posedge clk)    // PC���������
    begin
        if (!resetn) begin
            pc <= `STARTADDR; // ��λ��ȡ������ʼ��ַ
        end
        else begin
            pc <= next_pc;    // ����λ��ȡ��ָ��
        end
    end

    wire [31:0] inst_addr;
    wire [31:0] inst;
    assign inst_addr = pc;  // ָ���ַ��ָ���32λ
    inst_rom inst_rom_module(         // ָ��洢��
        .addr      (inst_addr[11:2]),  //I, 5,ָ���ַ,ָ��
		  .inst      (inst          )   // O, 32st
    );
    assign cpu_pc = pc;       //display pc
    assign cpu_inst = inst;	//display in 
        
//----------------------------------{ȡָ}end-------------------------------------//

//---------------------------------{����}begin------------------------------------//
    wire [5:0] op;       
    wire [4:0] rs;       
    wire [4:0] rt;       
    wire [4:0] rd;       
    wire [4:0] sa;      
    wire [5:0] funct;    
    wire [15:0] imm;     
    wire [15:0] offset;  
    wire [25:0] target;  

    assign op     = inst[31:26];  // ������
    assign rs     = inst[25:21];  // Դ������1
    assign rt     = inst[20:16];  // Դ������2
    assign rd     = inst[15:11];  // Ŀ�������
    assign sa     = inst[10:6];   // �����򣬿��ܴ��ƫ����
    assign funct  = inst[5:0];    // ������
    assign imm    = inst[15:0];   // ������
    assign offset = inst[15:0];   // ��ַƫ����
    assign target = inst[25:0];   // Ŀ���ַ

    wire op_zero;  // ������ȫ0
    wire sa_zero;  // sa��ȫ0
    assign op_zero = ~(|op);		//�ж�op�Ƿ�ȫΪ0
    assign sa_zero = ~(|sa);		//�ж�sa�Ƿ�ȫΪ0
    
    // ʵ��ָ���б�
    wire inst_ADDU, inst_SUBU , inst_SLT, inst_AND;
    wire inst_NOR , inst_OR   , inst_XOR, inst_SLL;
    wire inst_SRL , inst_ADDIU, inst_BEQ, inst_BNE;
    wire inst_LW  , inst_SW   , inst_LUI, inst_J;
	 wire inst_SLTU, inst_JALR	, inst_JR , inst_SLLV;
	 wire inst_SRA , inst_SRAV , inst_SRLV,inst_SLTI;
	 wire inst_SLTIU,inst_BGEZ , inst_BGTZ,inst_BLEZ;
	 wire inst_BLTZ, inst_LB   , inst_LBU ,inst_SB;
	 wire inst_ANDI, inst_ORI  , inst_XORI,inst_JAL;

    assign inst_ADDU  = op_zero & sa_zero    & (funct == 6'b100001);// �޷��żӷ�
    assign inst_SUBU  = op_zero & sa_zero    & (funct == 6'b100011);// �޷��ż���
    assign inst_SLT   = op_zero & sa_zero    & (funct == 6'b101010);// С������λ
	 assign inst_SLTU  = op_zero & sa_zero		& (funct == 6'b101011);// �޷���С����λ
    assign inst_AND   = op_zero & sa_zero    & (funct == 6'b100100);// �߼�������
    assign inst_NOR   = op_zero & sa_zero    & (funct == 6'b100111);// �߼��������
    assign inst_OR    = op_zero & sa_zero    & (funct == 6'b100101);// �߼�������
    assign inst_XOR   = op_zero & sa_zero    & (funct == 6'b100110);// �߼��������
    assign inst_SLL   = op_zero & (rs==5'd0) & (funct == 6'b000000);// �߼�����
    assign inst_SRL   = op_zero & (rs==5'd0) & (funct == 6'b000010);// �߼�����
	 assign inst_JALR	 = op_zero & sa_zero    & (funct == 6'b001001) & (rt == 5'd0) & (rd == 5'b11111); 	//��ת�Ĵ��������� û��
    assign inst_JR    =	op_zero & sa_zero    & (funct == 6'b001000) & (rt == 5'd0) & (rd == 5'd0);			//��ת�Ĵ���
	 assign inst_SLLV  = op_zero & sa_zero    & (funct == 6'b000100);// �����߼�����
	 assign inst_SRA	 = op_zero & (rs==5'd0) & (funct == 6'b000011);//��������
	 assign inst_SRAV  = op_zero & sa_zero		& (funct == 6'b000111);//������������
	 assign inst_SRLV  = op_zero & sa_zero    & (funct == 6'b000110);//�����߼�����
	 assign inst_ADDIU = (op == 6'b001001);                  // �������޷��żӷ�
    assign inst_BEQ   = (op == 6'b000100);                  // �ж������ת
    assign inst_BNE   = (op == 6'b000101);                  // �жϲ�����ת
    assign inst_LW    = (op == 6'b100011);                  // ���ڴ�װ��
    assign inst_SW    = (op == 6'b101011);                  // ���ڴ�洢
    assign inst_LUI   = (op == 6'b001111);                  // ������װ�ظ߰��ֽ�
    assign inst_J     = (op == 6'b000010);                  // ֱ����ת
	 assign inst_SLTI	 = (op == 6'b001010);						//�������з��űȽϣ�С����λ
	 assign inst_SLTIU = (op == 6'b001011);						//�������޷��űȽϣ� С����λ
	 assign inst_BGEZ  = (op == 6'b000001) & (rt==5'd1); //���ڵ���0��ת
    assign inst_BGTZ  = (op == 6'b000111) & (rt==5'd0); //����0��ת
	 assign inst_BLEZ  = (op == 6'b000110) & (rt==5'd0); //С�ڵ���0��ת
    assign inst_BLTZ  = (op == 6'b000001) & (rt==5'd0); //С��0��ת
    assign inst_LB    = (op == 6'b100000);              //load�ֽڣ�������չ��
    assign inst_LBU   = (op == 6'b100100);              //load�ֽڣ��޷�����չ��
    assign inst_SB    = (op == 6'b101000);              //���ڴ�洢�ֽ�
    assign inst_ANDI  = (op == 6'b001100);              //��������
    assign inst_ORI   = (op == 6'b001101);              //��������
    assign inst_XORI  = (op == 6'b001110);              //���������
    assign inst_JAL   = (op == 6'b000011);              //��ת������
	 

    // ��������ת�ж�
    wire        j_taken;
	 wire 		 j_reg;
    wire [31:0] j_target;
    assign j_taken  = inst_J | inst_JR | inst_JAL | inst_JALR;
	 assign j_reg    = inst_JR| inst_JALR;
    // ��������תĿ���ַ��PC={PC[31:28],target<<2}��rs
    assign j_target = j_reg ? rs_value : {pc[31:28], target, 2'b00};

    //��֧��ת
    wire        beq_taken;
    wire        bne_taken;
    wire [31:0] br_target;
	 wire rs_ez;
    wire rs_lz;
	 
	 
    assign beq_taken = (rs_value == rt_value);       // BEQ��ת������GPR[rs]=GPR[rt]
    assign bne_taken = ~beq_taken;                   // BNE��ת������GPR[rs]��GPR[rt]
	 assign rs_ez       = ~(|rs_value);             // rs�Ĵ���ֵΪ0
    assign rs_lz      = rs_value[31];             // rs�Ĵ���ֵС��0

    //��תָ�����ת�źź���תĿ���ַ
              
    assign jbr_taken = j_taken
								| inst_BEQ & beq_taken// ָ����ת����������ת �� �����֧��ת����
								| inst_BNE & bne_taken
								| inst_BGEZ& ~rs_lz
								| inst_BGTZ& ~rs_lz & ~rs_ez
								| inst_BLEZ& (rs_ez | rs_lz)
								| inst_BLTZ& rs_lz;
							
	 assign br_target[31:2] = pc[31:2] + {{14{offset[15]}}, offset} + 1;		
    assign br_target[1:0]  = pc[1:0];    // ��֧��תĿ���ַ��PC=PC+offset<<2
	 
    assign jbr_target = j_taken ? j_target : br_target;

    // �Ĵ�����
    wire rf_wen;
    wire [4:0] rf_waddr;
    wire [31:0] rf_wdata;
    wire [31:0] rs_value, rt_value;

    regfile rf_module(
        .clk    (clk      ),  // I, 1
		  .rst    (resetn   ),
        .wen    (rf_wen   ),  // I, 1
        .raddr1 (rs       ),  // I, 5
        .raddr2 (rt       ),  // I, 5
        .waddr  (rf_waddr ),  // I, 5
        .wdata  (rf_wdata ),  // I, 32
        .rdata1 (rs_value ),  // O, 32
        .rdata2 (rt_value ),   // O, 32

        //display rf
        .test_addr(rf_addr),
        .test_data(rf_data)
    );
    
    
    // ���ݵ�ִ��ģ���ALUԴ�������Ͳ�����
    wire inst_add, inst_sub, inst_slt,inst_sltu;
    wire inst_and, inst_nor, inst_or, inst_xor;
    wire inst_sll, inst_srl, inst_sra,inst_lui;
    assign inst_add = inst_ADDU | inst_ADDIU | inst_LW | inst_SW | inst_JALR | inst_LB | inst_LBU | inst_SB | inst_JAL ; // ���ӷ�����ָ��
    assign inst_sub = inst_SUBU; // ����
    assign inst_slt = inst_SLT | inst_SLTI;  // С����λ
    assign inst_sltu= inst_SLTU| inst_SLTIU; // �޷���С����λ
    assign inst_and = inst_AND | inst_ANDI;  // �߼���
    assign inst_nor = inst_NOR;  // �߼����
    assign inst_or  = inst_OR  | inst_ORI;   // �߼���
    assign inst_xor = inst_XOR | inst_XORI;  // �߼����
    assign inst_sll = inst_SLL | inst_SLLV;  // �߼�����
    assign inst_srl = inst_SRL | inst_SRLV;  // �߼�����
    assign inst_sra = inst_SRA | inst_SRAV;      // ��δʵ��
    assign inst_lui = inst_LUI;  // ������װ�ظ�λ


    wire   inst_	;    //ʹ��sa����Ϊƫ������ָ��
    assign inst_shf_sa   = inst_SLL | inst_SRL | inst_SRA;
	 
	//��������չ��ʽ
	 wire immi_zero;
	 wire immi_sign;			//������չ�ź�
	 wire [31:0] sext_imm;
	 wire [31:0] zext_imm;
	 assign immi_zero = inst_ANDI | inst_ORI | inst_XORI;
	 assign immi_sign = inst_ADDIU | inst_LUI | inst_SLTI | inst_SLTIU | inst_LW | inst_SW | inst_LB | inst_LBU | inst_SB;
    assign sext_imm      = {{16{imm[15]}}, imm};// ������������չ
	 assign zext_imm      = {{16{0}}, imm};// ������0��չ	 


    wire link_4;
	 assign link_4 = inst_JAL | inst_JALR;
	 
    wire [31:0] alu_operand1;
    wire [31:0] alu_operand2;
    wire [11:0] alu_control;
    assign alu_operand1 = inst_shf_sa ? {27'd0,sa} : 
								  link_4 	  ? pc : rs_value;
    assign alu_operand2 = immi_sign ? sext_imm :
								  immi_zero ? zext_imm :
								  link_4		? 32'd4	  : rt_value;
								  
    assign alu_control = {inst_add,        // ALU�����룬���ȱ���
                          inst_sub,
                          inst_slt,
                          inst_sltu,
                          inst_and,
                          inst_nor,
                          inst_or, 
                          inst_xor,
                          inst_sll,
                          inst_srl,
                          inst_sra,
                          inst_lui};
//----------------------------------{����}end-------------------------------------//

//---------------------------------{ִ��}begin------------------------------------//
    wire [31:0] alu_result;

    alu alu_module(
        .alu_control  (alu_control ),  // I, 12, ALU�����ź�
        .alu_src1     (alu_operand1),  // I, 32, ALU������1
        .alu_src2     (alu_operand2),  // I, 32, ALU������2
        .alu_result   (alu_result  )   // O, 32, ALU���
    );
//----------------------------------{ִ��}end-------------------------------------//
    
//---------------------------------{�ô�}begin------------------------------------//
//  wire [3 :0] dm_wen;
	 wire [4:0]  dm_ctrl;
    wire [31:0] dm_addr;
    wire [31:0] dm_wdata;
    wire [31:0] dm_rdata;
	 

	 assign dm_ctrl  = {inst_SW,inst_LW,inst_LB,inst_LBU,inst_SB};
    assign dm_addr  = alu_result;               // �ڴ�д��ַ��ΪALU���
    assign dm_wdata = rt_value;                 // �ڴ�д���ݣ�Ϊrt�Ĵ���ֵ
    data_ram data_ram_module(
		  .ctrl  (dm_ctrl),
        .clk   (clk         ),  // I, 1,  ʱ��
//        .wen   (dm_wen      ),  // I, 1,  дʹ��
        .addr  (dm_addr[6:0]),  // I, 32, ����ַ
        .wdata (dm_wdata    ),  // I, 32, д����
        .rdata (dm_rdata),  // O, 32, ������

        //display mem
        .test_addr(mem_addr[6:2]),
        .test_data(mem_data     )
    );

	 
//----------------------------------{�ô�}end-------------------------------------//

//---------------------------------{д��}begin------------------------------------//
    wire inst_wdest_rt;   // �Ĵ�����д���ַΪrt��ָ��
    wire inst_wdest_rd;   // �Ĵ�����д���ַΪrd��ָ��
	 wire inst_wdest_31;
	 wire write_alu_result;
    assign inst_wdest_rt = inst_ADDIU | inst_LW | inst_LUI | inst_SLTI | inst_SLTIU 
									| inst_LB | inst_LBU | inst_ANDI | inst_ORI | inst_XORI;
    assign inst_wdest_rd = inst_ADDU | inst_SUBU | inst_SLT | inst_AND | inst_NOR
                           | inst_OR | inst_XOR  | inst_SLL | inst_SRL | inst_SLTU
									|inst_SLLV| inst_SRA  | inst_SRAV| inst_SRLV;
	 assign inst_wdest_31 = inst_JALR | inst_JAL;
	 assign write_alu_result = inst_ADDU | inst_SUBU | inst_SLT | inst_AND | inst_NOR | inst_OR 
										| inst_XOR | inst_SLL | inst_SRL | inst_ADDIU | inst_LUI | inst_SLTU
										| inst_JALR | inst_SLLV | inst_SRA | inst_SRAV | inst_SRLV | inst_SLTI
										| inst_SLTIU | inst_ANDI | inst_ORI | inst_XORI | inst_JAL ; 
    // �Ĵ�����дʹ���źţ��Ǹ�λ״̬����Ч
    assign rf_wen   = (inst_wdest_rt | inst_wdest_rd | inst_wdest_31) & resetn;
    assign rf_waddr = inst_wdest_rd ? rd :
							 inst_wdest_rt ? rt : 5'd31;        // �Ĵ�����д��ַrd��rt��31
    assign rf_wdata = write_alu_result ? alu_result : dm_rdata;// д�ؽ����Ϊload�����ALU���
//----------------------------------{д��}end-------------------------------------//
endmodule
