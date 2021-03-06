use Mojo::Base -strict;

use Test::Exception;
use Test::More;

use CPU::Emulator::H8S::2246;

my $cpu = CPU::Emulator::H8S::2246->new;
isa_ok $cpu, 'CPU::Emulator::H8S::2246';

isa_ok $cpu->registers, 'Mojo::Collection';
is $cpu->registers->size, 8, 'right value';
isa_ok $cpu->registers->[0], 'CPU::Emulator::H8S::2246::Register::General';

isa_ok $cpu->ccr, 'CPU::Emulator::H8S::2246::Register::ConditionCode';
isa_ok $cpu->memory, 'CPU::Emulator::H8S::2246::Memory';

is $cpu->instruction_address, 0, 'right value';
is $cpu->reset_address, 0, 'right value';

$cpu->memory->from_string(pack('N', 4));
is $cpu->reset->instruction_address, 4, 'right value';

subtest 'ADD' => sub {
  subtest 'ADD.B' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x80, 0xFF));
    throws_ok { $cpu->reset->step } qr/STUB: add_b_xx8_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x08, 0x08));
    throws_ok { $cpu->reset->step } qr/STUB: add_b_rs_rd/, 'right error';
  };

  subtest 'ADD.W' => sub {
    $cpu->memory->from_string(pack('NC2S>', 4, 0x79, 0x10, 0xFFFF));
    throws_ok { $cpu->reset->step } qr/STUB: add_w_xx16_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x09, 0x08));
    throws_ok { $cpu->reset->step } qr/STUB: add_w_rs_rd/, 'right error';
  };

  subtest 'ADD.L' => sub {
    $cpu->memory->from_string(pack('NC2N', 4, 0x7A, 0x10, 0xFFFF_FFFF));
    throws_ok { $cpu->reset->step } qr/STUB: add_l_xx32_erd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x0A, 0x80 | 0x01));
    throws_ok { $cpu->reset->step } qr/STUB: add_l_ers_erd/, 'right error';
  };
};

subtest 'ADDS' => sub {
  $cpu->memory->from_string(pack('NC2', 4, 0x0B, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: adds_l_1_erd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x0B, 0x80));
  throws_ok { $cpu->reset->step } qr/STUB: adds_l_2_erd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x0B, 0x90));
  throws_ok { $cpu->reset->step } qr/STUB: adds_l_4_erd/, 'right error';
};

subtest 'ADDX' => sub {
  $cpu->memory->from_string(pack('NC2', 4, 0x90, 0xFF));
  throws_ok { $cpu->reset->step } qr/STUB: addx_b_xx8_rd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x0E, 0x08));
  throws_ok { $cpu->reset->step } qr/STUB: addx_b_rs_rd/, 'right error';
};

subtest 'AND' => sub {
  $cpu->memory->from_string(pack('NC2', 4, 0xE0, 0xFF));
  throws_ok { $cpu->reset->step } qr/STUB: and_b_xx8_rd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x16, 0x08));
  throws_ok { $cpu->reset->step } qr/STUB: and_b_rs_rd/, 'right error';

  $cpu->memory->from_string(pack('NC2S>', 4, 0x79, 0x60, 0xFFFF));
  throws_ok { $cpu->reset->step } qr/STUB: and_w_xx16_rd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x66, 0x08));
  throws_ok { $cpu->reset->step } qr/STUB: and_w_rs_rd/, 'right error';

  $cpu->memory->from_string(pack('NC2N', 4, 0x7A, 0x60, 0xFFFF_FFFF));
  throws_ok { $cpu->reset->step } qr/STUB: and_l_xx32_erd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x01, 0xF0, 0x66, 0x01));
  throws_ok { $cpu->reset->step } qr/STUB: and_l_ers_erd/, 'right error';
};

subtest 'ANDC' => sub {
  $cpu->memory->from_string(pack('NC2', 4, 0x06, 0xFF));
  throws_ok { $cpu->reset->step } qr/STUB: andc_b_xx8_ccr/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x41, 0x06, 0xFF));
  throws_ok { $cpu->reset->step } qr/STUB: andc_b_xx8_exr/, 'right error';
};

subtest 'BAND' => sub {
  $cpu->memory->from_string(pack('NC2', 4, 0x76, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: band_b_xx3_rd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7C, 0x00, 0x76, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: band_b_xx3_Aerd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7E, 0, 0x76, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: band_b_xx3_Aaa8/, 'right error';

  $cpu->memory->from_string(pack('NC2 S C2', 4, 0x6A, 0x10, 0xFFFF, 0x76, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: band_b_xx3_Aaa16/, 'right error';

  $cpu->memory->from_string(pack('NC2NC2', 4, 0x6A, 0x30, 0, 0x76, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: band_b_xx3_Aaa32/, 'right error';
};

subtest 'Bcc d:16' => sub {
  $cpu->memory->from_string(pack('NC2S>', 4, 0x58, 0x40, 0x0000));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bcc_d16/, 'right error';

  $cpu->memory->from_string(pack('NC2S>', 4, 0x58, 0x50, 0x0000));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bcs_d16/, 'right error';

  $cpu->memory->from_string(pack('NC2S>', 4, 0x58, 0x70, 0x0000));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_beq_d16/, 'right error';

  $cpu->memory->from_string(pack('NC2S>', 4, 0x58, 0xC0, 0x0000));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bge_d16/, 'right error';

  $cpu->memory->from_string(pack('NC2S>', 4, 0x58, 0xE0, 0x0000));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bgt_d16/, 'right error';

  $cpu->memory->from_string(pack('NC2S>', 4, 0x58, 0x20, 0x0000));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bhi_d16/, 'right error';

  $cpu->memory->from_string(pack('NC2S>', 4, 0x58, 0xF0, 0x0000));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_ble_d16/, 'right error';

  $cpu->memory->from_string(pack('NC2S>', 4, 0x58, 0x30, 0x0000));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bls_d16/, 'right error';

  $cpu->memory->from_string(pack('NC2S>', 4, 0x58, 0xD0, 0x0000));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_blt_d16/, 'right error';

  $cpu->memory->from_string(pack('NC2S>', 4, 0x58, 0xB0, 0x0000));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bmi_d16/, 'right error';

  $cpu->memory->from_string(pack('NC2S>', 4, 0x58, 0x60, 0x0000));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bne_d16/, 'right error';

  $cpu->memory->from_string(pack('NC2S>', 4, 0x58, 0xA0, 0x0000));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bpl_d16/, 'right error';

  $cpu->memory->from_string(pack('NC2S>', 4, 0x58, 0x00, 0x0000));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bra_d16/, 'right error';

  $cpu->memory->from_string(pack('NC2S>', 4, 0x58, 0x10, 0x0000));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_brn_d16/, 'right error';

  $cpu->memory->from_string(pack('NC2S>', 4, 0x58, 0x80, 0x0000));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bvc_d16/, 'right error';

  $cpu->memory->from_string(pack('NC2S>', 4, 0x58, 0x90, 0x0000));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bvs_d16/, 'right error';
};

subtest 'Bcc d:8' => sub {
  $cpu->memory->from_string(pack('NC2', 4, 0x44, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bcc_d8/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x45, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bcs_d8/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x47, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_beq_d8/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x4C, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bge_d8/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x4E, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bgt_d8/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x42, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bhi_d8/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x4F, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_ble_d8/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x43, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bls_d8/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x4D, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_blt_d8/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x4B, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bmi_d8/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x46, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bne_d8/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x4A, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bpl_d8/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x40, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bra_d8/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x41, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_brn_d8/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x48, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bvc_d8/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x49, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bcc_bvs_d8/, 'right error';
};

subtest 'BCLR' => sub {
  $cpu->memory->from_string(pack('NC2S>C2', 4, 0x6A, 0x18, 0, 0x62, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bclr_b_rn_Aaa16/, 'right error';

  $cpu->memory->from_string(pack('NC2NC2', 4, 0x6A, 0x38, 0, 0x62, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bclr_b_rn_Aaa32/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7F, 0, 0x62, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bclr_b_rn_Aaa8/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7D, 0x00, 0x62, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bclr_b_rn_Aerd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x62, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bclr_b_rn_rd/, 'right error';

  $cpu->memory->from_string(pack('NC2S>C2', 4, 0x6A, 0x18, 0, 0x72, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bclr_b_xx3_Aaa16/, 'right error';

  $cpu->memory->from_string(pack('NC2NC2', 4, 0x6A, 0x38, 0, 0x72, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bclr_b_xx3_Aaa32/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7F, 0, 0x72, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bclr_b_xx3_Aaa8/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7D, 0x00, 0x72, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bclr_b_xx3_Aerd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x72, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: bclr_b_xx3_rd/, 'right error';
};

subtest 'BIAND' => sub {
  $cpu->memory->from_string(pack('NC2', 4, 0x76, 0x80));
  throws_ok { $cpu->reset->step } qr/STUB: biand_b_xx3_rd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7C, 0x00, 0x76, 0x80));
  throws_ok { $cpu->reset->step } qr/STUB: biand_b_xx3_Aerd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7E, 0, 0x76, 0x80));
  throws_ok { $cpu->reset->step } qr/STUB: biand_b_xx3_Aaa8/, 'right error';

  $cpu->memory->from_string(pack('NC2 S C2', 4, 0x6A, 0x10, 0, 0x76, 0x80));
  throws_ok { $cpu->reset->step } qr/STUB: biand_b_xx3_Aaa16/, 'right error';

  $cpu->memory->from_string(pack('NC2NC2', 4, 0x6A, 0x30, 0, 0x76, 0x80));
  throws_ok { $cpu->reset->step } qr/STUB: biand_b_xx3_Aaa32/, 'right error';
};

subtest 'BILD' => sub {
  my @payload = (0x77, 0x80);

  $cpu->memory->from_string(pack('NC2', 4, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bild_b_xx3_rd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7C, 0x00, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bild_b_xx3_Aerd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7E, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bild_b_xx3_Aaa8/, 'right error';

  $cpu->memory->from_string(pack('NC2S>C2', 4, 0x6A, 0x10, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bild_b_xx3_Aaa16/, 'right error';

  $cpu->memory->from_string(pack('NC2NC2', 4, 0x6A, 0x30, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bild_b_xx3_Aaa32/, 'right error';
};

subtest 'BIOR' => sub {
  my @payload = (0x74, 0x80);

  $cpu->memory->from_string(pack('NC2', 4, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bior_b_xx3_rd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7C, 0x00, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bior_b_xx3_Aerd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7E, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bior_b_xx3_Aaa8/, 'right error';

  $cpu->memory->from_string(pack('NC2S>C2', 4, 0x6A, 0x10, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bior_b_xx3_Aaa16/, 'right error';

  $cpu->memory->from_string(pack('NC2NC2', 4, 0x6A, 0x30, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bior_b_xx3_Aaa32/, 'right error';
};

subtest 'BIST' => sub {
  my @payload = (0x67, 0x80);

  $cpu->memory->from_string(pack('NC2', 4, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bist_b_xx3_rd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7D, 0x00, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bist_b_xx3_Aerd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7F, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bist_b_xx3_Aaa8/, 'right error';

  $cpu->memory->from_string(pack('NC2S>C2', 4, 0x6A, 0x18, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bist_b_xx3_Aaa16/, 'right error';

  $cpu->memory->from_string(pack('NC2NC2', 4, 0x6A, 0x38, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bist_b_xx3_Aaa32/, 'right error';
};

subtest 'BIXOR' => sub {
  my @payload = (0x75, 0x80);

  $cpu->memory->from_string(pack('NC2', 4, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bixor_b_xx3_rd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7C, 0x00, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bixor_b_xx3_Aerd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7E, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bixor_b_xx3_Aaa8/, 'right error';

  $cpu->memory->from_string(pack('NC2S>C2', 4, 0x6A, 0x10, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bixor_b_xx3_Aaa16/, 'right error';

  $cpu->memory->from_string(pack('NC2NC2', 4, 0x6A, 0x30, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bixor_b_xx3_Aaa32/, 'right error';
};

subtest 'BLD' => sub {
  my @payload = (0x77, 0x00);

  $cpu->memory->from_string(pack('NC2', 4, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bld_b_xx3_rd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7C, 0x00, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bld_b_xx3_Aerd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7E, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bld_b_xx3_Aaa8/, 'right error';

  $cpu->memory->from_string(pack('NC2S>C2', 4, 0x6A, 0x10, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bld_b_xx3_Aaa16/, 'right error';

  $cpu->memory->from_string(pack('NC2NC2', 4, 0x6A, 0x30, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bld_b_xx3_Aaa32/, 'right error';
};

subtest 'BNOT' => sub {
  my @rn = (0x61, 0x00);

  $cpu->memory->from_string(pack('NC2S>C2', 4, 0x6A, 0x18, 0, @rn));
  throws_ok { $cpu->reset->step } qr/STUB: bnot_b_rn_Aaa16/, 'right error';

  $cpu->memory->from_string(pack('NC2NC2', 4, 0x6A, 0x38, 0, @rn));
  throws_ok { $cpu->reset->step } qr/STUB: bnot_b_rn_Aaa32/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7F, 0, @rn));
  throws_ok { $cpu->reset->step } qr/STUB: bnot_b_rn_Aaa8/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7D, 0x00, @rn));
  throws_ok { $cpu->reset->step } qr/STUB: bnot_b_rn_Aerd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, @rn));
  throws_ok { $cpu->reset->step } qr/STUB: bnot_b_rn_rd/, 'right error';

  my @imm = (0x71, 00);

  $cpu->memory->from_string(pack('NC2S>C2', 4, 0x6A, 0x18, 0, @imm));
  throws_ok { $cpu->reset->step } qr/STUB: bnot_b_xx3_Aaa16/, 'right error';

  $cpu->memory->from_string(pack('NC2NC2', 4, 0x6A, 0x38, 0, @imm));
  throws_ok { $cpu->reset->step } qr/STUB: bnot_b_xx3_Aaa32/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7F, 0, @imm));
  throws_ok { $cpu->reset->step } qr/STUB: bnot_b_xx3_Aaa8/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7D, 0x00, @imm));
  throws_ok { $cpu->reset->step } qr/STUB: bnot_b_xx3_Aerd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, @imm));
  throws_ok { $cpu->reset->step } qr/STUB: bnot_b_xx3_rd/, 'right error';
};

subtest 'BOR' => sub {
  my @payload = (0x74, 0x00);

  $cpu->memory->from_string(pack('NC2', 4, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bor_b_xx3_rd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7C, 0x00, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bor_b_xx3_Aerd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7E, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bor_b_xx3_Aaa8/, 'right error';

  $cpu->memory->from_string(pack('NC2S>C2', 4, 0x6A, 0x10, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bor_b_xx3_Aaa16/, 'right error';

  $cpu->memory->from_string(pack('NC2NC2', 4, 0x6A, 0x30, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bor_b_xx3_Aaa32/, 'right error';
};

subtest 'BSET' => sub {
  my @rn = (0x60, 0x00);

  $cpu->memory->from_string(pack('NC2S>C2', 4, 0x6A, 0x18, 0, @rn));
  throws_ok { $cpu->reset->step } qr/STUB: bset_b_rn_Aaa16/, 'right error';

  $cpu->memory->from_string(pack('NC2NC2', 4, 0x6A, 0x38, 0, @rn));
  throws_ok { $cpu->reset->step } qr/STUB: bset_b_rn_Aaa32/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7F, 0, @rn));
  throws_ok { $cpu->reset->step } qr/STUB: bset_b_rn_Aaa8/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7D, 0x00, @rn));
  throws_ok { $cpu->reset->step } qr/STUB: bset_b_rn_Aerd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, @rn));
  throws_ok { $cpu->reset->step } qr/STUB: bset_b_rn_rd/, 'right error';

  my @imm = (0x70, 00);

  $cpu->memory->from_string(pack('NC2S>C2', 4, 0x6A, 0x18, 0, @imm));
  throws_ok { $cpu->reset->step } qr/STUB: bset_b_xx3_Aaa16/, 'right error';

  $cpu->memory->from_string(pack('NC2NC2', 4, 0x6A, 0x38, 0, @imm));
  throws_ok { $cpu->reset->step } qr/STUB: bset_b_xx3_Aaa32/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7F, 0, @imm));
  throws_ok { $cpu->reset->step } qr/STUB: bset_b_xx3_Aaa8/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7D, 0x00, @imm));
  throws_ok { $cpu->reset->step } qr/STUB: bset_b_xx3_Aerd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, @imm));
  throws_ok { $cpu->reset->step } qr/STUB: bset_b_xx3_rd/, 'right error';
};

subtest 'BSR' => sub {
  $cpu->memory->from_string(pack('NC2S>', 4, 0x5C, 0x00, 0));
  throws_ok { $cpu->reset->step } qr/STUB: bsr_d16/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x55, 0));
  throws_ok { $cpu->reset->step } qr/STUB: bsr_d8/, 'right error';
};

subtest 'BST' => sub {
  my @payload = (0x67, 0x00);

  $cpu->memory->from_string(pack('NC2', 4, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bst_b_xx3_rd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7D, 0x00, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bst_b_xx3_Aerd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7F, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bst_b_xx3_Aaa8/, 'right error';

  $cpu->memory->from_string(pack('NC2S>C2', 4, 0x6A, 0x18, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bst_b_xx3_Aaa16/, 'right error';

  $cpu->memory->from_string(pack('NC2NC2', 4, 0x6A, 0x38, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bst_b_xx3_Aaa32/, 'right error';
};

subtest 'BTST' => sub {
  my @rn = (0x63, 0x00);

  $cpu->memory->from_string(pack('NC2S>C2', 4, 0x6A, 0x10, 0, @rn));
  throws_ok { $cpu->reset->step } qr/STUB: btst_b_rn_Aaa16/, 'right error';

  $cpu->memory->from_string(pack('NC2NC2', 4, 0x6A, 0x30, 0, @rn));
  throws_ok { $cpu->reset->step } qr/STUB: btst_b_rn_Aaa32/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7E, 0, @rn));
  throws_ok { $cpu->reset->step } qr/STUB: btst_b_rn_Aaa8/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7C, 0x00, @rn));
  throws_ok { $cpu->reset->step } qr/STUB: btst_b_rn_Aerd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, @rn));
  throws_ok { $cpu->reset->step } qr/STUB: btst_b_rn_rd/, 'right error';

  my @imm = (0x73, 00);

  $cpu->memory->from_string(pack('NC2S>C2', 4, 0x6A, 0x10, 0, @imm));
  throws_ok { $cpu->reset->step } qr/STUB: btst_b_xx3_Aaa16/, 'right error';

  $cpu->memory->from_string(pack('NC2NC2', 4, 0x6A, 0x30, 0, @imm));
  throws_ok { $cpu->reset->step } qr/STUB: btst_b_xx3_Aaa32/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7E, 0, @imm));
  throws_ok { $cpu->reset->step } qr/STUB: btst_b_xx3_Aaa8/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7C, 0x00, @imm));
  throws_ok { $cpu->reset->step } qr/STUB: btst_b_xx3_Aerd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, @imm));
  throws_ok { $cpu->reset->step } qr/STUB: btst_b_xx3_rd/, 'right error';
};

subtest 'BXOR' => sub {
  my @payload = (0x75, 0x00);

  $cpu->memory->from_string(pack('NC2', 4, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bxor_b_xx3_rd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7C, 0x00, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bxor_b_xx3_Aerd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7E, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bxor_b_xx3_Aaa8/, 'right error';

  $cpu->memory->from_string(pack('NC2S>C2', 4, 0x6A, 0x10, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bxor_b_xx3_Aaa16/, 'right error';

  $cpu->memory->from_string(pack('NC2NC2', 4, 0x6A, 0x30, 0, @payload));
  throws_ok { $cpu->reset->step } qr/STUB: bxor_b_xx3_Aaa32/, 'right error';
};

subtest 'CMP' => sub {
  subtest 'CMP.B' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0xA0, 0xFF));
    throws_ok { $cpu->reset->step } qr/STUB: cmp_b_xx8_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x1C, 0x08));
    throws_ok { $cpu->reset->step } qr/STUB: cmp_b_rs_rd/, 'right error';
  };

  subtest 'CMP.W' => sub {
    $cpu->memory->from_string(pack('NC2S>', 4, 0x79, 0x20, 0xFFFF));
    throws_ok { $cpu->reset->step } qr/STUB: cmp_w_xx16_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x1D, 0x08));
    throws_ok { $cpu->reset->step } qr/STUB: cmp_w_rs_rd/, 'right error';
  };

  subtest 'CMP.L' => sub {
    $cpu->memory->from_string(pack('NC2N', 4, 0x7A, 0x20, 0, 0xFFFF_FFFF));
    throws_ok { $cpu->reset->step } qr/STUB: cmp_l_xx32_erd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x1F, 0x80 | 0x01));
    throws_ok { $cpu->reset->step } qr/STUB: cmp_l_ers_erd/, 'right error';
  };
};

$cpu->memory->from_string(pack('NC2', 4, 0x0F, 0x00));
throws_ok { $cpu->reset->step } qr/STUB: daa_b_rd/, 'right error';

$cpu->memory->from_string(pack('NC2', 4, 0x1F, 0x00));
throws_ok { $cpu->reset->step } qr/STUB: das_b_rd/, 'right error';

subtest 'DEC' => sub {
  subtest 'DEC.B' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x1A, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: dec_b_rd/, 'right error';
  };

  subtest 'DEC.W' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x1B, 0x50));
    throws_ok { $cpu->reset->step } qr/STUB: dec_w_1_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x1B, 0xD0));
    throws_ok { $cpu->reset->step } qr/STUB: dec_w_2_rd/, 'right error';
  };

  subtest 'DEC.L' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x1B, 0x70));
    throws_ok { $cpu->reset->step } qr/STUB: dec_l_1_erd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x1B, 0xF0));
    throws_ok { $cpu->reset->step } qr/STUB: dec_l_2_erd/, 'right error';
  };
};

subtest 'DIVXS' => sub {
  $cpu->memory->from_string(pack('NC4', 4, 0x01, 0xD0, 0x51, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: divxs_b_rs_rd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x01, 0xD0, 0x53, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: divxs_w_rs_erd/, 'right error';
};

subtest 'DIVXU' => sub {
  $cpu->memory->from_string(pack('NC2', 4, 0x51, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: divxu_b_rs_rd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x53, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: divxu_w_rs_erd/, 'right error';
};

subtest 'EEPMOV' => sub {
  $cpu->memory->from_string(pack('NC4', 4, 0x7B, 0x5C, 0x59, 0x8F));
  throws_ok { $cpu->reset->step } qr/STUB: eepmov_b/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x7B, 0xD4, 0x59, 0x8F));
  throws_ok { $cpu->reset->step } qr/STUB: eepmov_w/, 'right error';
};

subtest 'EXTS' => sub {
  $cpu->memory->from_string(pack('NC2', 4, 0x17, 0xD0));
  throws_ok { $cpu->reset->step } qr/STUB: exts_w_rd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x17, 0xF0));
  throws_ok { $cpu->reset->step } qr/STUB: exts_l_erd/, 'right error';
};

subtest 'EXTU' => sub {
  $cpu->memory->from_string(pack('NC2', 4, 0x17, 0x50));
  throws_ok { $cpu->reset->step } qr/STUB: extu_w_rd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x17, 0x70));
  throws_ok { $cpu->reset->step } qr/STUB: extu_l_erd/, 'right error';
};

subtest 'INC' => sub {
  subtest 'INC.B' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x0A, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: inc_b_rd/, 'right error';
  };

  subtest 'INC.W' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x0B, 0x50));
    throws_ok { $cpu->reset->step } qr/STUB: inc_w_1_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x0B, 0xD0));
    throws_ok { $cpu->reset->step } qr/STUB: inc_w_2_rd/, 'right error';
  };

  subtest 'INC.L' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x0B, 0x70));
    throws_ok { $cpu->reset->step } qr/STUB: inc_l_1_erd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x0B, 0xF0));
    throws_ok { $cpu->reset->step } qr/STUB: inc_l_2_erd/, 'right error';
  };
};

subtest 'JMP' => sub {
  $cpu->memory->from_string(pack('NC2CS>', 4, 0x5A, 0, 0));
  throws_ok { $cpu->reset->step } qr/STUB: jmp_Aaa24/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x5B, 0));
  throws_ok { $cpu->reset->step } qr/STUB: jmp_AAaa8/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x59, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: jmp_Aern/, 'right error';
};

subtest 'JSR' => sub {
  $cpu->memory->from_string(pack('NC2CS>', 4, 0x5E, 0, 0));
  throws_ok { $cpu->reset->step } qr/STUB: jsr_Aaa24/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x5F, 0));
  throws_ok { $cpu->reset->step } qr/STUB: jsr_AAaa8/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x5D, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: jsr_Aern/, 'right error';
};

subtest 'LDC' => sub {
  subtest 'LDC.B' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x03, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: ldc_b_rs_ccr/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x03, 0x10));
    throws_ok { $cpu->reset->step } qr/STUB: ldc_b_rs_exr/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x07, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: ldc_b_xx8_ccr/, 'right error';

    $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x41, 0x07, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: ldc_b_xx8_exr/, 'right error';
  };

  subtest 'LDC.W' => sub {
    $cpu->memory->from_string(pack('NC4S>', 4, 0x01, 0x40, 0x6B, 0x00, 0));
    throws_ok { $cpu->reset->step } qr/STUB: ldc_w_Aaa16_ccr/, 'right error';

    $cpu->memory->from_string(pack('NC4S>', 4, 0x01, 0x41, 0x6B, 0x00, 0));
    throws_ok { $cpu->reset->step } qr/STUB: ldc_w_Aaa16_exr/, 'right error';

    $cpu->memory->from_string(pack('NC4N', 4, 0x01, 0x40, 0x6B, 0x20, 0));
    throws_ok { $cpu->reset->step } qr/STUB: ldc_w_Aaa32_ccr/, 'right error';

    $cpu->memory->from_string(pack('NC4N', 4, 0x01, 0x41, 0x6B, 0x20, 0));
    throws_ok { $cpu->reset->step } qr/STUB: ldc_w_Aaa32_exr/, 'right error';

    $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x40, 0x69, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: ldc_w_Aers_ccr/, 'right error';

    $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x41, 0x69, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: ldc_w_Aers_exr/, 'right error';

    $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x40, 0x6D, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: ldc_w_AersP_ccr/, 'right error';

    $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x41, 0x6D, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: ldc_w_AersP_exr/, 'right error';

    $cpu->memory->from_string(pack('NC4S>', 4, 0x01, 0x40, 0x6F, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: ldc_w_AOPd16_ersCP_ccr/,
      'right error';

    $cpu->memory->from_string(pack('NC4S>', 4, 0x01, 0x41, 0x6F, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: ldc_w_AOPd16_ersCP_exr/,
      'right error';

    $cpu->memory->from_string(
      pack('NC6N', 4, 0x01, 0x40, 0x78, 0x00, 0x6B, 0x20, 0),
    );
    throws_ok { $cpu->reset->step } qr/STUB: ldc_w_AOPd32_ersCP_ccr/,
      'right error';

    $cpu->memory->from_string(
      pack('NC6N', 4, 0x01, 0x41, 0x78, 0x00, 0x6B, 0x20, 0),
    );
    throws_ok { $cpu->reset->step } qr/STUB: ldc_w_AOPd32_ersCP_exr/,
      'right error';
  };
};

subtest 'LDM' => sub {
  $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x10, 0x6D, 0x70));
  throws_ok { $cpu->reset->step } qr/STUB: ldm_l_AspP_OPernMernP1CP/,
    'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x20, 0x6D, 0x70));
  throws_ok { $cpu->reset->step } qr/STUB: ldm_l_AspP_OPernMernP2CP/,
    'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x30, 0x6D, 0x70));
  throws_ok { $cpu->reset->step } qr/STUB: ldm_l_AspP_OPernMernP3CP/,
    'right error';
};

subtest 'MOV' => sub {
  subtest 'MOV.B' => sub {
    $cpu->memory->from_string(pack('NC2S>', 4, 0x6A, 0x00, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_b_Aaa16_rd/, 'right error';

    $cpu->memory->from_string(pack('NC4N', 4, 0x6A, 0x20, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_b_Aaa32_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x20, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_b_Aaa8_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x68, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: mov_b_Aers_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x6C, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: mov_b_AersP_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2S>', 4, 0x6E, 0x00, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_b_AOPd16_ersCP_rd/,
      'right error';

    $cpu->memory->from_string(pack('NC4N', 4, 0x78, 0x00, 0x6A, 0x20, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_b_AOPd32_ersCP_rd/,
      'right error';

    $cpu->memory->from_string(pack('NC2S>', 4, 0x6A, 0x80, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_b_rs_Aaa16/, 'right error';

    $cpu->memory->from_string(pack('NC4N', 4, 0x6A, 0xA0, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_b_rs_Aaa32/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x30, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_b_rs_Aaa8/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x68, 0x80));
    throws_ok { $cpu->reset->step } qr/STUB: mov_b_rs_Aerd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x6C, 0x80));
    throws_ok { $cpu->reset->step } qr/STUB: mov_b_rs_AMerd/, 'right error';

    $cpu->memory->from_string(pack('NC2S>', 4, 0x6E, 0x80, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_b_rs_AOPd16_erdCP/,
      'right error';

    $cpu->memory->from_string(pack('NC4N', 4, 0x78, 0x00, 0x6A, 0xA0, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_b_rs_AOPd32_erdCP/,
      'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x0C, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: mov_b_rs_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0xF0, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_b_xx8_rd/, 'right error';
  };

  subtest 'MOV.W' => sub {
    $cpu->memory->from_string(pack('NC2S>', 4, 0x6B, 0x00, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_w_Aaa16_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2N', 4, 0x6B, 0x20, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_w_Aaa32_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x69, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: mov_w_Aers_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x6D, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: mov_w_AersP_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2S>', 4, 0x6F, 0x00, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_w_AOPd16_ersCP_rd/,
      'right error';

    $cpu->memory->from_string(pack('NC4N', 4, 0x78, 0x00, 0x6B, 0x20, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_w_AOPd32_ersCP_rd/,
      'right error';

    $cpu->memory->from_string(pack('NC2S>', 4, 0x6B, 0x80, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_w_rs_Aaa16/, 'right error';

    $cpu->memory->from_string(pack('NC2N', 4, 0x6B, 0xA0, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_w_rs_Aaa32/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x69, 0x80));
    throws_ok { $cpu->reset->step } qr/STUB: mov_w_rs_Aerd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x6D, 0x80));
    throws_ok { $cpu->reset->step } qr/STUB: mov_w_rs_AMerd/, 'right error';

    $cpu->memory->from_string(pack('NC2S>', 4, 0x6F, 0x80, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_w_rs_AOPd16_erdCP/,
      'right error';

    $cpu->memory->from_string(pack('NC4N', 4, 0x78, 0x00, 0x6B, 0xA0, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_w_rs_AOPd32_erdCP/,
      'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x0D, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: mov_w_rs_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2S>', 4, 0x79, 0x00, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_w_xx16_rd/, 'right error';
  };

  subtest 'MOV.L' => sub {
    $cpu->memory->from_string(pack('NC4S>', 4, 0x01, 0x00, 0x6B, 0x00, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_l_Aaa16_erd/, 'right error';

    $cpu->memory->from_string(pack('NC4N', 4, 0x01, 0x00, 0x6B, 0x20, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_l_Aaa32_erd/, 'right error';

    $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x00, 0x69, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: mov_l_Aers_erd/, 'right error';

    $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x00, 0x6D, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: mov_l_AersP_erd/, 'right error';

    $cpu->memory->from_string(pack('NC4S>', 4, 0x01, 0x00, 0x6F, 0x00, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_l_AOPd16_ersCP_erd/,
      'right error';

    $cpu->memory->from_string(
      pack('NC6N', 4, 0x01, 0x00, 0x78, 0x00, 0x6B, 0x20, 0),
    );
    throws_ok { $cpu->reset->step } qr/STUB: mov_l_AOPd32_ersCP_erd/,
      'right error';

    $cpu->memory->from_string(pack('NC4S>', 4, 0x01, 0x00, 0x6B, 0x80, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_l_ers_Aaa16/, 'right error';

    $cpu->memory->from_string(pack('NC4N', 4, 0x01, 0x00, 0x6B, 0xA0, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_l_ers_Aaa32/, 'right error';

    $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x00, 0x69, 0x80));
    throws_ok { $cpu->reset->step } qr/STUB: mov_l_ers_Aerd/, 'right error';

    $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x00, 0x6D, 0x80));
    throws_ok { $cpu->reset->step } qr/STUB: mov_l_ers_AMerd/, 'right error';

    $cpu->memory->from_string(pack('NC4S>', 4, 0x01, 0x00, 0x6F, 0x80, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_l_ers_AOPd16_erdCP/,
      'right error';

    $cpu->memory->from_string(
      pack('NC6N', 4, 0x01, 0x00, 0x78, 0x00, 0x6B, 0xA0, 0),
    );
    throws_ok { $cpu->reset->step } qr/STUB: mov_l_ers_AOPd32_erdCP/,
      'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x0F, 0x80));
    throws_ok { $cpu->reset->step } qr/STUB: mov_l_ers_erd/, 'right error';

    $cpu->memory->from_string(pack('NC2N', 4, 0x7A, 0x00, 0));
    throws_ok { $cpu->reset->step } qr/STUB: mov_l_xx32_rd/, 'right error';
  };
};

$cpu->memory->from_string(pack('NC2', 4, 0x6A, 0x40));
throws_ok { $cpu->reset->step } qr/STUB: movfpe_b_Aaa16_rd/, 'right error';

$cpu->memory->from_string(pack('NC2', 4, 0x6A, 0xC0));
throws_ok { $cpu->reset->step } qr/STUB: movtpe_b_rs_Aaa16/, 'right error';

subtest 'MULXS' => sub {
  $cpu->memory->from_string(pack('NC4', 4, 0x01, 0xC0, 0x50, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: mulxs_b_rs_rd/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x01, 0xC0, 0x52, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: mulxs_w_rs_erd/, 'right error';
};

subtest 'MULXU' => sub {
  $cpu->memory->from_string(pack('NC2', 4, 0x50, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: mulxu_b_rs_rd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x52, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: mulxu_w_rs_erd/, 'right error';
};

subtest 'NEG' => sub {
  $cpu->memory->from_string(pack('NC2', 4, 0x17, 0x80));
  throws_ok { $cpu->reset->step } qr/STUB: neg_b_rd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x17, 0xB0));
  throws_ok { $cpu->reset->step } qr/STUB: neg_l_erd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x17, 0x90));
  throws_ok { $cpu->reset->step } qr/STUB: neg_w_rd/, 'right error';
};

$cpu->memory->from_string(pack('NC2', 4, 0x00, 0x00));
throws_ok { $cpu->reset->step } qr/STUB: nop/, 'right error';

subtest 'NOT' => sub {
  $cpu->memory->from_string(pack('NC2', 4, 0x17, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: not_b_rd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x17, 0x30));
  throws_ok { $cpu->reset->step } qr/STUB: not_l_erd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x17, 0x10));
  throws_ok { $cpu->reset->step } qr/STUB: not_w_rd/, 'right error';
};

subtest 'OR' => sub {
  subtest 'OR.B' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0xC0, 0));
    throws_ok { $cpu->reset->step } qr/STUB: or_b_xx8_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x14, 0x08));
    throws_ok { $cpu->reset->step } qr/STUB: or_b_rs_rd/, 'right error';
  };

  subtest 'OR.W' => sub {
    $cpu->memory->from_string(pack('NC2S>', 4, 0x79, 0x40, 0xFFFF));
    throws_ok { $cpu->reset->step } qr/STUB: or_w_xx16_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x64, 0x08));
    throws_ok { $cpu->reset->step } qr/STUB: or_w_rs_rd/, 'right error';
  };

  subtest 'OR.L' => sub {
    $cpu->memory->from_string(pack('NC2N', 4, 0x7A, 0x40, 0xFFFF_FFFF));
    throws_ok { $cpu->reset->step } qr/STUB: or_l_xx32_erd/, 'right error';

    $cpu->memory->from_string(pack('NC4', 4, 0x01, 0xF0, 0x64, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: or_l_ers_erd/, 'right error';
  };
};

subtest 'ORC' => sub {
  $cpu->memory->from_string(pack('NC2', 4, 0x04, 0));
  throws_ok { $cpu->reset->step } qr/STUB: orc_b_xx8_ccr/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x41, 0x04, 0));
  throws_ok { $cpu->reset->step } qr/STUB: orc_b_xx8_exr/, 'right error';
};

subtest 'ROTL' => sub {
  subtest 'ROTL.B' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x12, 0x80));
    throws_ok { $cpu->reset->step } qr/STUB: rotl_b_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x12, 0xC0));
    throws_ok { $cpu->reset->step } qr/STUB: rotl_b_2_rd/, 'right error';
  };

  subtest 'ROTL.W' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x12, 0x90));
    throws_ok { $cpu->reset->step } qr/STUB: rotl_w_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x12, 0xD0));
    throws_ok { $cpu->reset->step } qr/STUB: rotl_w_2_rd/, 'right error';
  };

  subtest 'ROTL.L' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x12, 0xB0));
    throws_ok { $cpu->reset->step } qr/STUB: rotl_l_erd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x12, 0xF0));
    throws_ok { $cpu->reset->step } qr/STUB: rotl_l_2_erd/, 'right error';
  };
};

subtest 'ROTR' => sub {
  subtest 'ROTR.B' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x13, 0x80));
    throws_ok { $cpu->reset->step } qr/STUB: rotr_b_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x13, 0xC0));
    throws_ok { $cpu->reset->step } qr/STUB: rotr_b_2_rd/, 'right error';
  };

  subtest 'ROTR.W' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x13, 0x90));
    throws_ok { $cpu->reset->step } qr/STUB: rotr_w_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x13, 0xD0));
    throws_ok { $cpu->reset->step } qr/STUB: rotr_w_2_rd/, 'right error';
  };

  subtest 'ROTR.L' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x13, 0xB0));
    throws_ok { $cpu->reset->step } qr/STUB: rotr_l_erd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x13, 0xF0));
    throws_ok { $cpu->reset->step } qr/STUB: rotr_l_2_erd/, 'right error';
  };
};

subtest 'ROTXL' => sub {
  subtest 'ROTXL.B' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x12, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: rotxl_b_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x12, 0x40));
    throws_ok { $cpu->reset->step } qr/STUB: rotxl_b_2_rd/, 'right error';
  };

  subtest 'ROTXL.W' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x12, 0x10));
    throws_ok { $cpu->reset->step } qr/STUB: rotxl_w_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x12, 0x50));
    throws_ok { $cpu->reset->step } qr/STUB: rotxl_w_2_rd/, 'right error';
  };

  subtest 'ROTXL.L' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x12, 0x30));
    throws_ok { $cpu->reset->step } qr/STUB: rotxl_l_erd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x12, 0x70));
    throws_ok { $cpu->reset->step } qr/STUB: rotxl_l_2_erd/, 'right error';
  };
};

subtest 'ROTXR' => sub {
  subtest 'ROTXR.B' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x13, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: rotxr_b_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x13, 0x40));
    throws_ok { $cpu->reset->step } qr/STUB: rotxr_b_2_rd/, 'right error';
  };

  subtest 'ROTXR.W' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x13, 0x10));
    throws_ok { $cpu->reset->step } qr/STUB: rotxr_w_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x13, 0x50));
    throws_ok { $cpu->reset->step } qr/STUB: rotxr_w_2_rd/, 'right error';
  };

  subtest 'ROTXR.L' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x13, 0x30));
    throws_ok { $cpu->reset->step } qr/STUB: rotxr_l_erd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x13, 0x70));
    throws_ok { $cpu->reset->step } qr/STUB: rotxr_l_2_erd/, 'right error';
  };
};

$cpu->memory->from_string(pack('NC2', 4, 0x56, 0x70));
throws_ok { $cpu->reset->step } qr/STUB: rte/, 'right error';

$cpu->memory->from_string(pack('NC2', 4, 0x54, 0x70));
throws_ok { $cpu->reset->step } qr/STUB: rts/, 'right error';

subtest 'SHAL' => sub {
  subtest 'SHAL.B' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x10, 0x80));
    throws_ok { $cpu->reset->step } qr/STUB: shal_b_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x10, 0xC0));
    throws_ok { $cpu->reset->step } qr/STUB: shal_b_2_rd/, 'right error';
  };

  subtest 'SHAL.W' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x10, 0x90));
    throws_ok { $cpu->reset->step } qr/STUB: shal_w_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x10, 0xD0));
    throws_ok { $cpu->reset->step } qr/STUB: shal_w_2_rd/, 'right error';
  };

  subtest 'SHAL.L' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x10, 0xB0));
    throws_ok { $cpu->reset->step } qr/STUB: shal_l_erd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x10, 0xF0));
    throws_ok { $cpu->reset->step } qr/STUB: shal_l_2_erd/, 'right error';
  };
};

subtest 'SHAR' => sub {
  subtest 'SHAR.B' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x11, 0x80));
    throws_ok { $cpu->reset->step } qr/STUB: shar_b_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x11, 0xC0));
    throws_ok { $cpu->reset->step } qr/STUB: shar_b_2_rd/, 'right error';
  };

  subtest 'SHAR.W' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x11, 0x90));
    throws_ok { $cpu->reset->step } qr/STUB: shar_w_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x11, 0xD0));
    throws_ok { $cpu->reset->step } qr/STUB: shar_w_2_rd/, 'right error';
  };

  subtest 'SHAR.L' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x11, 0xB0));
    throws_ok { $cpu->reset->step } qr/STUB: shar_l_erd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x11, 0xF0));
    throws_ok { $cpu->reset->step } qr/STUB: shar_l_2_erd/, 'right error';
  };
};

subtest 'SHLL' => sub {
  subtest 'SHLL.B' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x10, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: shll_b_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x10, 0x40));
    throws_ok { $cpu->reset->step } qr/STUB: shll_b_2_rd/, 'right error';
  };

  subtest 'SHLL.W' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x10, 0x10));
    throws_ok { $cpu->reset->step } qr/STUB: shll_w_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x10, 0x50));
    throws_ok { $cpu->reset->step } qr/STUB: shll_w_2_rd/, 'right error';
  };

  subtest 'SHLL.L' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x10, 0x30));
    throws_ok { $cpu->reset->step } qr/STUB: shll_l_erd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x10, 0x70));
    throws_ok { $cpu->reset->step } qr/STUB: shll_l_2_erd/, 'right error';
  };
};

subtest 'SHLR' => sub {
  subtest 'SHLR.B' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x11, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: shlr_b_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x11, 0x40));
    throws_ok { $cpu->reset->step } qr/STUB: shlr_b_2_rd/, 'right error';
  };

  subtest 'SHLR.W' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x11, 0x10));
    throws_ok { $cpu->reset->step } qr/STUB: shlr_w_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x11, 0x50));
    throws_ok { $cpu->reset->step } qr/STUB: shlr_w_2_rd/, 'right error';
  };

  subtest 'SHLR.L' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x11, 0x30));
    throws_ok { $cpu->reset->step } qr/STUB: shlr_l_erd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x11, 0x70));
    throws_ok { $cpu->reset->step } qr/STUB: shlr_l_2_erd/, 'right error';
  };
};

$cpu->memory->from_string(pack('NC2', 4, 0x01, 0x80));
throws_ok { $cpu->reset->step } qr/STUB: sleep/, 'right error';

subtest 'STC' => sub {
  subtest 'STC.B' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x02, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: stc_b_ccr_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x02, 0x10));
    throws_ok { $cpu->reset->step } qr/STUB: stc_b_exr_rd/, 'right error';
  };

  subtest 'STC.W' => sub {
    $cpu->memory->from_string(pack('NC4S>', 4, 0x01, 0x40, 0x6B, 0x80, 0));
    throws_ok { $cpu->reset->step } qr/STUB: stc_w_ccr_Aaa16/, 'right error';

    $cpu->memory->from_string(pack('NC4N', 4, 0x01, 0x40, 0x6B, 0xA0, 0));
    throws_ok { $cpu->reset->step } qr/STUB: stc_w_ccr_Aaa32/, 'right error';

    $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x40, 0x69, 0x80));
    throws_ok { $cpu->reset->step } qr/STUB: stc_w_ccr_Aerd/, 'right error';

    $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x40, 0x6D, 0x80));
    throws_ok { $cpu->reset->step } qr/STUB: stc_w_ccr_AMerd/, 'right error';

    $cpu->memory->from_string(pack('NC4S>', 4, 0x01, 0x40, 0x6F, 0x80, 0));
    throws_ok { $cpu->reset->step } qr/STUB: stc_w_ccr_AOPd16_erdCP/,
      'right error';

    $cpu->memory->from_string(
      pack('NC6N', 4, 0x01, 0x40, 0x78, 0x00, 0x6B, 0xA0, 0),
    );
    throws_ok { $cpu->reset->step } qr/STUB: stc_w_ccr_AOPd32_erdCP/,
      'right error';

    $cpu->memory->from_string(pack('NC4S>', 4, 0x01, 0x41, 0x6B, 0x80, 0));
    throws_ok { $cpu->reset->step } qr/STUB: stc_w_exr_Aaa16/, 'right error';

    $cpu->memory->from_string(pack('NC4N', 4, 0x01, 0x41, 0x6B, 0xA0, 0));
    throws_ok { $cpu->reset->step } qr/STUB: stc_w_exr_Aaa32/, 'right error';

    $cpu->memory->from_string(pack('NC4S>', 4, 0x01, 0x41, 0x6F, 0x80, 0));
    throws_ok { $cpu->reset->step } qr/STUB: stc_w_exr_AOPd16_erdCP/,
      'right error';

    $cpu->memory->from_string(
      pack('NC6N', 4, 0x01, 0x41, 0x78, 0x00, 0x6B, 0xA0, 0),
    );
    throws_ok { $cpu->reset->step } qr/STUB: stc_w_exr_AOPd32_erdCP/,
      'right error';

    $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x41, 0x69, 0x80));
    throws_ok { $cpu->reset->step } qr/STUB: stc_w_exr_Aerd/, 'right error';

    $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x41, 0x6D, 0x80));
    throws_ok { $cpu->reset->step } qr/STUB: stc_w_exr_AMerd/, 'right error';
  };
};

subtest 'STM' => sub {
  $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x10, 0x6D, 0xF0));
  throws_ok { $cpu->reset->step } qr/STUB: stm_l_OPern_M_ernP1CP_AMsp/,
    'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x20, 0x6D, 0xF0));
  throws_ok { $cpu->reset->step } qr/STUB: stm_l_OPern_M_ernP2CP_AMsp/,
    'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x30, 0x6D, 0xF0));
  throws_ok { $cpu->reset->step } qr/STUB: stm_l_OPern_M_ernP3CP_AMsp/,
    'right error';
};

subtest 'SUB' => sub {
  subtest 'SUB.B' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0x18, 0x08));
    throws_ok { $cpu->reset->step } qr/STUB: sub_b_rs_rd/, 'right error';
  };

  subtest 'SUB.W' => sub {
    $cpu->memory->from_string(pack('NC2S>', 4, 0x79, 0x30, 0xFFFF));
    throws_ok { $cpu->reset->step } qr/STUB: sub_w_xx16_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x19, 0x08));
    throws_ok { $cpu->reset->step } qr/STUB: sub_w_rs_rd/, 'right error';
  };

  subtest 'SUB.L' => sub {
    $cpu->memory->from_string(pack('NC2N', 4, 0x7A, 0x30, 0xFFFF_FFFF));
    throws_ok { $cpu->reset->step } qr/STUB: sub_l_xx32_erd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x1A, 0x80));
    throws_ok { $cpu->reset->step } qr/STUB: sub_l_ers_erd/, 'right error';
  };
};

subtest 'SUBS' => sub {
  $cpu->memory->from_string(pack('NC2', 4, 0x1B, 0x00));
  throws_ok { $cpu->reset->step } qr/STUB: subs_l_1_erd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x1B, 0x80));
  throws_ok { $cpu->reset->step } qr/STUB: subs_l_2_erd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x1B, 0x90));
  throws_ok { $cpu->reset->step } qr/STUB: subs_l_4_erd/, 'right error';
};

subtest 'SUBX' => sub {
  $cpu->memory->from_string(pack('NC2', 4, 0xB0, 0xFF));
  throws_ok { $cpu->reset->step } qr/STUB: subx_b_xx8_rd/, 'right error';

  $cpu->memory->from_string(pack('NC2', 4, 0x1E, 0x08));
  throws_ok { $cpu->reset->step } qr/STUB: subx_b_rs_rd/, 'right error';
};

$cpu->memory->from_string(pack('NC4', 4, 0x01, 0xE0, 0x7B, 0x0C));
throws_ok { $cpu->reset->step } qr/STUB: tas_b_Aerd/, 'right error';

$cpu->memory->from_string(pack('NC2', 4, 0x57, 0x00));
throws_ok { $cpu->reset->step } qr/STUB: trapa/, 'right error';

subtest 'XOR' => sub {
  subtest 'XOR.B' => sub {
    $cpu->memory->from_string(pack('NC2', 4, 0xD0, 0));
    throws_ok { $cpu->reset->step } qr/STUB: xor_b_xx8_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x15, 0x08));
    throws_ok { $cpu->reset->step } qr/STUB: xor_b_rs_rd/, 'right error';
  };

  subtest 'XOR.W' => sub {
    $cpu->memory->from_string(pack('NC2S>', 4, 0x79, 0x50, 0xFFFF));
    throws_ok { $cpu->reset->step } qr/STUB: xor_w_xx16_rd/, 'right error';

    $cpu->memory->from_string(pack('NC2', 4, 0x65, 0x08));
    throws_ok { $cpu->reset->step } qr/STUB: xor_w_rs_rd/, 'right error';
  };

  subtest 'XOR.L' => sub {
    $cpu->memory->from_string(pack('NC2N', 4, 0x7A, 0x50, 0xFFFF_FFFF));
    throws_ok { $cpu->reset->step } qr/STUB: xor_l_xx32_erd/, 'right error';

    $cpu->memory->from_string(pack('NC4', 4, 0x01, 0xF0, 0x65, 0x00));
    throws_ok { $cpu->reset->step } qr/STUB: xor_l_ers_erd/, 'right error';
  };
};

subtest 'XORC' => sub {
  $cpu->memory->from_string(pack('NC2', 4, 0x05, 0xFF));
  throws_ok { $cpu->reset->step } qr/STUB: xorc_b_xx8_ccr/, 'right error';

  $cpu->memory->from_string(pack('NC4', 4, 0x01, 0x41, 0x05, 0xFF));
  throws_ok { $cpu->reset->step } qr/STUB: xorc_b_xx8_exr/, 'right error';
};

done_testing;
