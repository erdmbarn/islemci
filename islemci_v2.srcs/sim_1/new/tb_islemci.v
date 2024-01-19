`timescale 1ns/1ps

module tb_islemci();

localparam BELLEK_ADRES = 32'h8000_0000;
localparam ADRES_BIT = 32;
localparam VERI_BIT = 32;

reg clk_r;
reg rst_r;

wire [ADRES_BIT-1:0] islemci_bellek_adres;
wire [VERI_BIT-1:0] islemci_bellek_oku_veri;
wire [VERI_BIT-1:0] islemci_bellek_yaz_veri;
wire islemci_bellek_yaz;

anabellek anabellek (
    .clk(clk_r),
    .adres(islemci_bellek_adres),
    .oku_veri(islemci_bellek_oku_veri),
    .yaz_veri(islemci_bellek_yaz_veri),
    .yaz_gecerli(islemci_bellek_yaz)
);

islemci islemci (
    .clk(clk_r),
    .rst(rst_r),
    .bellek_adres(islemci_bellek_adres),
    .bellek_oku_veri(islemci_bellek_oku_veri),
    .bellek_yaz_veri(islemci_bellek_yaz_veri),
    .bellek_yaz(islemci_bellek_yaz)
);


localparam insADD = 32'b0000000_00000_00001_000_00010_0110011;
localparam insADD1 = 32'b00000001110011101000110110110011;
localparam insADD2 = 32'b00000000000100000000001000110011;
localparam insADD3 = 32'b00000000100001001000010100110011;
localparam insSUB = 32'b0100000_00000_00010_000_00011_0110011;
localparam insSUB1 = 32'b01000001110011101000110110110011;
localparam insSUB2 = 32'b01000000001100010000001010110011;
localparam insSUB3 = 32'b01000000100101010000010110110011;
localparam insADDI = 32'b00000010000_00011_000_00100_0010011;
localparam insADDI1 = 32'b00111110100000000000010010010011;
localparam insADDI2 = 32'b00000110010000000000100000010011;
localparam insADDI3 = 32'b00000000010100000000000010010011;
localparam insADDI4 = 32'b00000000000100001000000010010011;
localparam insOR = 32'b0000000_00000_00001_110_00101_0110011;
localparam insOR1 = 32'b00000000000100100110001110110011;
localparam insAND = 32'b0000000_00000_00001_111_00110_0110011;
localparam insAND1 = 32'b00000000000100000111001100110011;
localparam insXOR = 32'b0000000_00000_00001_100_00111_0110011;
localparam insXOR1 = 32'b00000000011100101100010000110011;
localparam insLUI1 = 32'b00000000000000000000111110110111;
localparam insLUI2 = 32'b00000000000000000001111100110111;
localparam insLUI3 = 32'b00000000000000000010111010110111;
localparam insLUI4 = 32'b00000000000000000011111000110111;
localparam insLUI5 = 32'b01100111000111001000011100110111;
localparam insAUIPC = 32'b00000000000000000001_01001_0010111;
localparam insAUIPC1 = 32'b00000000000000000001_01111_0010111;
localparam insBEQ = 32'b0000000_11111_11110_000_01000_1100011;
localparam insBEQ1 = 32'b0000000_00100_00001_000_01000_1100011;
localparam insBNE = 32'b00000000001100001001010001100011;
localparam insBNE1 = 32'b00000000001000001001011001100011;
localparam insBLT = 32'b0000000_01001_01000_100_01000_1100011;
localparam insBLT1 = 32'b00000000100101010100010001100011;
localparam insSW =  32'b00000000100100100010000000100011;
localparam insJAL = 32'b00000000100000000000010101101111;
localparam insJAL1 = 32'b11111111100111111111010101101111;
localparam insJALR = 32'b00000000000001010000010111100111;

localparam wADDI = 32'b00000000000100001000000010010011; // addi x1,x1,1
localparam wADDI1 = 32'b00000001010100010000000100010011; // addi x2,x2,21
localparam wADDI2 = 32'b00000000011100011000000110010011; // addi x3, x3, 7
localparam wBEQ = 32'b00000000001000001000101001100011; // beq x1 x2 20 
localparam wBLT = 32'b00000000001100001100010001100011; // blt x1,x3,8
localparam wADDI3 = 32'b00000000001000001000000010010011; // addi x1,x1,2
localparam wJAL = 32'b11111111000111111111100001101111; // jal x16, -16


always begin
    clk_r = 1'b0;
    #5;
    clk_r = 1'b1;
    #5;
end

localparam MAX_CYCLES = 500;
integer stall_ctr;
initial begin
    stall_ctr = 0;
    rst_r = 1'b1;
    // Race condition engellemek icin sistem 1 cevrim calistirilir
    @(posedge clk_r); // reset sinyali aktif oldugu icin degisiklik olusmaz
    // https://luplab.gitlab.io/rvcodecjs/ <- assembly binary donusumu icin kullanabiliriniz
    // BUYRUKLAR 
    
    bellek_yaz('h8000_0000, 32'h00500093); // addi x1, x0, 5
   // bellek_yaz('h8000_0000, 32'h000001f7);
    bellek_yaz('h8000_0004, 32'h00a00113); // addi x2, x0, 10
    bellek_yaz('h8000_0008, 32'h002081b3); // add  x3, x1, x2
    bellek_yaz('h8000_000c, 32'h80000237); // lui  x4, 0x80000
    bellek_yaz('h8000_0010, 32'h40022283); // lw   x5, 0x400(x4)  
    bellek_yaz('h8000_0014, 32'h003282b3); // add  x5, x5, x3
    bellek_yaz('h8000_0018, 32'h40522223); // sw   x5, 0x404(x4)
    //bellek_yaz('h8000_0000, 32'h000001f7);
    
    
    
    /*anabellek.bellek[0] = wADDI; // addi x1,x1,1
    anabellek.bellek[1] = wADDI1; // addi x2,x2,21
    anabellek.bellek[2] = wADDI2; // addi x3,x3,7
    anabellek.bellek[3] = wBEQ; // beq x1 x2 20 
    anabellek.bellek[4] = wBLT; // blt x1,x3,8
    anabellek.bellek[5] = wADDI3; // // addi x1,x1,2
    anabellek.bellek[6] = wADDI; // addi x1,x1,1
    anabellek.bellek[7] = wJAL; // jal x16,-16
    anabellek.bellek[8] = insLUI2; // lui x30, 1*/
    
    
    
    
     
    
    /*
    anabellek.bellek[7] = insBNE1; // bne x1, x2, 12
    anabellek.bellek[8] = insADDI4; // addi x1, x1, 1
    anabellek.bellek[9] = insJAL1; // jal x10, -8
    anabellek.bellek[10] = insLUI2; // lui x30, 1
    */
    
    
    anabellek.bellek[7] = insLUI1; // lui x31, 0  //8
    anabellek.bellek[8] = insLUI2; // lui x30, 1   //9
    anabellek.bellek[9] = insLUI3; // lui x29, 2   //10
    anabellek.bellek[10] = insLUI4; // lui x28, 3  //11
    anabellek.bellek[11] = insADD1;  //x27,x29,x28 //12
    anabellek.bellek[12] = insBEQ1; // beq x4,x1,8  //13
    anabellek.bellek[13] = insSUB2;  // sub x5, x2, x3//14
    anabellek.bellek[14] = insAND1; // and x6, x0, x1//15
    anabellek.bellek[15] = insOR1;   // or x7, x4, x1 //16
    anabellek.bellek[16] = insXOR1; // xor x8, x5, x7 //17
    anabellek.bellek[17] = insBNE;  // bne x1,x3,8   //18
    anabellek.bellek[18] = insSUB3; // sub x9, x0, x8 //19
    anabellek.bellek[19] = insADDI1; // addi x9, x0, 1000 //20
    anabellek.bellek[20] = insBLT;  // blt x8, x9, 8 //21
    anabellek.bellek[21] = insADD3; // add x10, x9, x8 //22
    anabellek.bellek[22] = insBLT1; // blt x10 x9 8 //23
    anabellek.bellek[23] = insADD3; // add x10, x9, x8  //24
    anabellek.bellek[24] = insSW; // sw x9 deðerini adresin 0. indexine koy  //25 
    anabellek.bellek[25] = insLUI5; // lui x14, 422344 //26
    anabellek.bellek[26] = insAUIPC1; // auipc x15, 1 //27
    anabellek.bellek[27] = insJAL;  // jal x10, 8  //28
    anabellek.bellek[28] = insLUI1; // lui x31, 0 // will not be implemented but second will work //29
    anabellek.bellek[29] = insJALR; // jalr x11, 0(x10)  // after this will be jumped to above  //30

    // PROGRAM VERISI
    bellek_yaz('h8000_0400, 32'hdeadbee0);
    bellek_yaz('h8000_0404, 32'h55555555);

    // BUYRUKLAR - ALTERNATIF YONTEM (zaten 8000_0000'in 0. index oldugunu biliyoruz)
    // anabellek.bellek[0] = 32'h00500093; 
    // anabellek.bellek[1] = 32'h00a00113; 

    repeat (10) @(posedge clk_r); #2; // 10 cevrim reset
    rst_r = 1'b0;

    buyruk_kontrol(3); // 3 buyruk yurut
    if (yazmac_oku(1) != 5) begin
        $display("[ERR] x1 DEGER HATASI expected: 5 actual: %0d", yazmac_oku(1));
    end
    if (yazmac_oku(2) != 10) begin
        $display("[ERR] x2 DEGER HATASI expected: 10 actual: %0d", yazmac_oku(2));
    end
    if (yazmac_oku(3) != 15) begin
        $display("[ERR] x3 DEGER HATASI expected: 15 actual: %0d", yazmac_oku(3));
    end
    if (islemci.ps_r != 'h8000_000c) begin
        $display("[ERR] program sayaci 4. buyrugu gostermeli.");
    end

    buyruk_kontrol(4); // 4 buyruk yurut
    if (bellek_oku('h8000_0400) != 32'hdeadbee0) begin
        $display("[ERR] adres 0x80000400 DEGER HATASI expected: 0xdeadbee0 actual: 0x%0x.", bellek_oku('h8000_0400));
    end
    if (bellek_oku('h8000_0404) != 32'hdeadbeef) begin
        $display("[ERR] adres 0x80000404 DEGER HATASI expected: 0xdeadbeef actual: 0x%0x.", bellek_oku('h8000_0404));
    end
    
    

end

// Islemcide buyruk_sayisi kadar buyruk yurutulmesini izler ve asama sirasini kontrol eder.
task buyruk_kontrol (
    input [31:0] buyruk_sayisi
);
integer counter;
begin
    for (counter = 0; counter < buyruk_sayisi; counter = counter + 1) begin
        asama_kontrol(islemci.GETIR);
        @(posedge clk_r) #2;
        asama_kontrol(islemci.COZYAZMACOKU);
        @(posedge clk_r) #2;
        asama_kontrol(islemci.YURUTGERIYAZ);
        @(posedge clk_r) #2;
    end
end
endtask

task asama_kontrol (
    input integer beklenen
);
begin
    if (islemci.simdiki_asama_r != beklenen) begin
        $display("[ERR] YANLIS ASAMA expected: %0x actual: %0x", beklenen, islemci.simdiki_asama_r);
    end
end
endtask

task bellek_yaz (
    input [ADRES_BIT-1:0] adres,
    input [VERI_BIT-1:0] veri
);
begin
    anabellek.bellek[adres_satir_idx(adres)] = veri;
end
endtask

function [VERI_BIT-1:0] bellek_oku (
    input [ADRES_BIT-1:0] adres
);
begin
    bellek_oku = anabellek.bellek[adres_satir_idx(adres)];
end
endfunction

function [VERI_BIT-1:0] yazmac_oku (
    input integer yazmac_idx
);
begin
    yazmac_oku = islemci.yazmac_obegi[yazmac_idx];
end
endfunction

// Verilen adresi bellek satir indisine donusturur.
function integer adres_satir_idx (
    input [ADRES_BIT-1:0] adres
);
begin
    adres_satir_idx = (adres - BELLEK_ADRES) >> $clog2(VERI_BIT / 8);
end
endfunction

endmodule