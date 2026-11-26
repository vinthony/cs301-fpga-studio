package cs301
private[cs301] object DecoderTable {
  case class Row(mask:String,pattern:String,id:Int,fmt:Int,alu:Int,unsigned:Boolean,shift:Boolean,control:String)
  val rows=Seq(
    Row("fe00707f","33",0,0,0,false,false,"f"), // ADD
    Row("fe00707f","40000033",1,0,1,false,false,"f"), // SUB
    Row("fe00707f","1033",2,0,5,false,false,"f"), // SLL
    Row("fe00707f","2033",3,0,8,false,false,"f"), // SLT
    Row("fe00707f","3033",4,0,9,false,false,"f"), // SLTU
    Row("fe00707f","4033",5,0,4,false,false,"f"), // XOR
    Row("fe00707f","5033",6,0,6,false,false,"f"), // SRL
    Row("fe00707f","40005033",7,0,7,false,false,"f"), // SRA
    Row("fe00707f","6033",8,0,3,false,false,"f"), // OR
    Row("fe00707f","7033",9,0,2,false,false,"f"), // AND
    Row("707f","13",10,1,0,false,false,"10b"), // ADDI
    Row("707f","2013",11,1,8,false,false,"10b"), // SLTI
    Row("707f","3013",12,1,9,false,false,"10b"), // SLTIU
    Row("707f","4013",13,1,4,false,false,"10b"), // XORI
    Row("707f","6013",14,1,3,false,false,"10b"), // ORI
    Row("707f","7013",15,1,2,false,false,"10b"), // ANDI
    Row("fe00707f","1013",16,1,5,false,true,"10b"), // SLLI
    Row("fe00707f","5013",17,1,6,false,true,"10b"), // SRLI
    Row("fe00707f","40005013",18,1,7,false,true,"10b"), // SRAI
    Row("707f","3",19,1,0,false,false,"111b"), // LB
    Row("707f","1003",20,1,0,false,false,"511b"), // LH
    Row("707f","2003",21,1,0,false,false,"911b"), // LW
    Row("707f","4003",22,1,0,true,false,"111b"), // LBU
    Row("707f","5003",23,1,0,true,false,"511b"), // LHU
    Row("707f","23",24,2,0,false,false,"127"), // SB
    Row("707f","1023",25,2,0,false,false,"4127"), // SH
    Row("707f","2023",26,2,0,false,false,"8127"), // SW
    Row("707f","63",27,3,1,false,false,"47"), // BEQ
    Row("707f","1063",28,3,1,false,false,"47"), // BNE
    Row("707f","4063",29,3,8,false,false,"47"), // BLT
    Row("707f","5063",30,3,8,false,false,"47"), // BGE
    Row("707f","6063",31,3,9,false,false,"47"), // BLTU
    Row("707f","7063",32,3,9,false,false,"47"), // BGEU
    Row("7f","6f",33,5,0,false,false,"2389"), // JAL
    Row("707f","67",34,1,0,false,false,"218b"), // JALR
    Row("7f","37",35,4,0,false,false,"3109"), // LUI
    Row("7f","17",36,4,0,false,false,"309"), // AUIPC
    Row("707f","f",37,6,0,false,false,"801"), // FENCE
    Row("ffffffff","73",38,6,0,false,false,"401"), // ECALL
    Row("ffffffff","100073",39,6,0,false,false,"401") // EBREAK
  )
}
