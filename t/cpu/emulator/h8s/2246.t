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

done_testing;
