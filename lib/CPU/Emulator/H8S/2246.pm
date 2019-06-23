package CPU::Emulator::H8S::2246;
use Mojo::Base '-base';

use CPU::Emulator::H8S::2246::Memory;
use CPU::Emulator::H8S::2246::Register::ConditionCode;
use CPU::Emulator::H8S::2246::Register::General;

use Carp 'croak';
use Mojo::Collection 'c';
use Mojo::Util 'monkey_patch';

no warnings 'portable';

has instruction_address => 0;
has reset_address => 0;

has ccr => sub { CPU::Emulator::H8S::2246::Register::ConditionCode->new };
has memory => sub { CPU::Emulator::H8S::2246::Memory->new };

has registers => sub {c(
  map { CPU::Emulator::H8S::2246::Register::General->new } 0 .. 7
)};

foreach my $name (qw[
  add_b_rs_rd
  add_b_xx8_rd
  add_l_ers_erd
  add_l_xx32_erd
  add_w_rs_rd
  add_w_xx16_rd
  adds_l_1_erd
  adds_l_2_erd
  adds_l_4_erd
  addx_b_rs_rd
  addx_b_xx8_rd
  and_b_rs_rd
  and_b_xx8_rd
  and_l_ers_erd
  and_l_xx32_erd
  and_w_rs_rd
  and_w_xx16_rd
  andc_b_xx8_ccr
  andc_b_xx8_exr
  band_b_xx3_Aaa16
  band_b_xx3_Aaa32
  band_b_xx3_Aaa8
  band_b_xx3_Aerd
  band_b_xx3_rd
  bcc_bcc_d16
  bcc_bcc_d8
  bcc_bcs_d16
  bcc_bcs_d8
  bcc_beq_d16
  bcc_beq_d8
  bcc_bge_d16
  bcc_bge_d8
  bcc_bgt_d16
  bcc_bgt_d8
  bcc_bhi_d16
  bcc_bhi_d8
  bcc_ble_d16
  bcc_ble_d8
  bcc_bls_d16
  bcc_bls_d8
  bcc_blt_d16
  bcc_blt_d8
  bcc_bmi_d16
  bcc_bmi_d8
  bcc_bne_d16
  bcc_bne_d8
  bcc_bpl_d16
  bcc_bpl_d8
  bcc_bra_d16
  bcc_bra_d8
  bcc_brn_d16
  bcc_brn_d8
  bcc_bvc_d16
  bcc_bvc_d8
  bcc_bvs_d16
  bcc_bvs_d8
  bclr_b_rn_Aaa16
  bclr_b_rn_Aaa32
  bclr_b_rn_Aaa8
  bclr_b_rn_Aerd
  bclr_b_rn_rd
  bclr_b_xx3_Aaa16
  bclr_b_xx3_Aaa32
  bclr_b_xx3_Aaa8
  bclr_b_xx3_Aerd
  bclr_b_xx3_rd
  biand_b_xx3_Aaa16
  biand_b_xx3_Aaa32
  biand_b_xx3_Aaa8
  biand_b_xx3_Aerd
  biand_b_xx3_rd
  bild_b_xx3_Aaa16
  bild_b_xx3_Aaa32
  bild_b_xx3_Aaa8
  bild_b_xx3_Aerd
  bild_b_xx3_rd
  bior_b_xx3_Aaa16
  bior_b_xx3_Aaa32
  bior_b_xx3_Aaa8
  bior_b_xx3_Aerd
  bior_b_xx3_rd
  bist_b_xx3_Aaa16
  bist_b_xx3_Aaa32
  bist_b_xx3_Aaa8
  bist_b_xx3_Aerd
  bist_b_xx3_rd
  bixor_b_xx3_Aaa16
  bixor_b_xx3_Aaa32
  bixor_b_xx3_Aaa8
  bixor_b_xx3_Aerd
  bixor_b_xx3_rd
  bld_b_xx3_Aaa16
  bld_b_xx3_Aaa32
  bld_b_xx3_Aaa8
  bld_b_xx3_Aerd
  bld_b_xx3_rd
  bnot_b_rn_Aaa16
  bnot_b_rn_Aaa32
  bnot_b_rn_Aaa8
  bnot_b_rn_Aerd
  bnot_b_rn_rd
  bnot_b_xx3_Aaa16
  bnot_b_xx3_Aaa32
  bnot_b_xx3_Aaa8
  bnot_b_xx3_Aerd
  bnot_b_xx3_rd
  bor_b_xx3_Aaa16
  bor_b_xx3_Aaa32
  bor_b_xx3_Aaa8
  bor_b_xx3_Aerd
  bor_b_xx3_rd
  bset_b_rn_Aaa16
  bset_b_rn_Aaa32
  bset_b_rn_Aaa8
  bset_b_rn_Aerd
  bset_b_rn_rd
  bset_b_xx3_Aaa16
  bset_b_xx3_Aaa32
  bset_b_xx3_Aaa8
  bset_b_xx3_Aerd
  bset_b_xx3_rd
  bsr_d16
  bsr_d8
  bst_b_xx3_Aaa16
  bst_b_xx3_Aaa32
  bst_b_xx3_Aaa8
  bst_b_xx3_Aerd
  bst_b_xx3_rd
  btst_b_rn_Aaa16
  btst_b_rn_Aaa32
  btst_b_rn_Aaa8
  btst_b_rn_Aerd
  btst_b_rn_rd
  btst_b_xx3_Aaa16
  btst_b_xx3_Aaa32
  btst_b_xx3_Aaa8
  btst_b_xx3_Aerd
  btst_b_xx3_rd
  bxor_b_xx3_Aaa16
  bxor_b_xx3_Aaa32
  bxor_b_xx3_Aaa8
  bxor_b_xx3_Aerd
  bxor_b_xx3_rd
  cmp_b_rs_rd
  cmp_b_xx8_rd
  cmp_l_ers_erd
  cmp_l_xx32_erd
  cmp_w_rs_rd
  cmp_w_xx16_rd
  daa_b_rd
  das_b_rd
  dec_b_rd
  dec_l_1_erd
  dec_l_2_erd
  dec_w_1_rd
  dec_w_2_rd
  divxs_b_rs_rd
  divxs_w_rs_erd
  divxu_b_rs_rd
  divxu_w_rs_erd
  eepmov_b
  eepmov_w
  exts_l_erd
  exts_w_rd
  extu_l_erd
  extu_w_rd
  inc_b_rd
  inc_l_1_erd
  inc_l_2_erd
  inc_w_1_rd
  inc_w_2_rd
  jmp_Aaa24
  jmp_AAaa8
  jmp_Aern
  jsr_Aaa24
  jsr_AAaa8
  jsr_Aern
  ldc_b_rs_ccr
  ldc_b_rs_exr
  ldc_b_xx8_ccr
  ldc_b_xx8_exr
  ldc_w_Aaa16_ccr
  ldc_w_Aaa16_exr
  ldc_w_Aaa32_ccr
  ldc_w_Aaa32_exr
  ldc_w_Aers_ccr
  ldc_w_Aers_exr
  ldc_w_AersP_ccr
  ldc_w_AersP_exr
  ldc_w_AOPd16_ersCP_ccr
  ldc_w_AOPd16_ersCP_exr
  ldc_w_AOPd32_ersCP_ccr
  ldc_w_AOPd32_ersCP_exr
  ldm_l_AspP_OPernMernP1CP
  ldm_l_AspP_OPernMernP2CP
  ldm_l_AspP_OPernMernP3CP
]) {
  monkey_patch __PACKAGE__, "_op_$name", sub {
    croak "STUB: $name";
  };
}

sub reset {
  my $self = shift;

  my $address = $self->memory->read32($self->reset_address);
  $self->instruction_address($address);

  return $self;
}

sub step {
  my $self = shift;

  state $handler_for = &_handlers;

  my $bytes = $self->_instruction;
  my $handlers = $handler_for->map(sub {
    my $masked_value = $bytes & $_->{mask};
    my $handler = $_->{handler_for}{$masked_value};
    return $handler // ();
  });
  die 'No handler found' unless $handlers->size;
  die 'Matched multiple handlers' if $handlers->size > 1;
  $handlers->first->($self, $bytes);

  return $self;
}

sub _handlers {
  my $self = shift;

  return c({
    mask => 0xF000_0000_0000_0000,
    handler_for => {
      0x8000_0000_0000_0000 => \&_op_add_b_xx8_rd,
      0x9000_0000_0000_0000 => \&_op_addx_b_xx8_rd,
      0xA000_0000_0000_0000 => \&_op_cmp_b_xx8_rd,
      0xE000_0000_0000_0000 => \&_op_and_b_xx8_rd,
    },
  }, {
    mask => 0xFF00_0000_0000_0000,
    handler_for => {
      0x0600_0000_0000_0000 => \&_op_andc_b_xx8_ccr,
      0x0700_0000_0000_0000 => \&_op_ldc_b_xx8_ccr,
      0x0800_0000_0000_0000 => \&_op_add_b_rs_rd,
      0x0900_0000_0000_0000 => \&_op_add_w_rs_rd,
      0x0E00_0000_0000_0000 => \&_op_addx_b_rs_rd,
      0x1600_0000_0000_0000 => \&_op_and_b_rs_rd,
      0x1C00_0000_0000_0000 => \&_op_cmp_b_rs_rd,
      0x1D00_0000_0000_0000 => \&_op_cmp_w_rs_rd,
      0x4000_0000_0000_0000 => \&_op_bcc_bra_d8,
      0x4100_0000_0000_0000 => \&_op_bcc_brn_d8,
      0x4200_0000_0000_0000 => \&_op_bcc_bhi_d8,
      0x4300_0000_0000_0000 => \&_op_bcc_bls_d8,
      0x4400_0000_0000_0000 => \&_op_bcc_bcc_d8,
      0x4500_0000_0000_0000 => \&_op_bcc_bcs_d8,
      0x4600_0000_0000_0000 => \&_op_bcc_bne_d8,
      0x4700_0000_0000_0000 => \&_op_bcc_beq_d8,
      0x4800_0000_0000_0000 => \&_op_bcc_bvc_d8,
      0x4900_0000_0000_0000 => \&_op_bcc_bvs_d8,
      0x4A00_0000_0000_0000 => \&_op_bcc_bpl_d8,
      0x4B00_0000_0000_0000 => \&_op_bcc_bmi_d8,
      0x4C00_0000_0000_0000 => \&_op_bcc_bge_d8,
      0x4D00_0000_0000_0000 => \&_op_bcc_blt_d8,
      0x4E00_0000_0000_0000 => \&_op_bcc_bgt_d8,
      0x4F00_0000_0000_0000 => \&_op_bcc_ble_d8,
      0x5100_0000_0000_0000 => \&_op_divxu_b_rs_rd,
      0x5500_0000_0000_0000 => \&_op_bsr_d8,
      0x5A00_0000_0000_0000 => \&_op_jmp_Aaa24,
      0x5B00_0000_0000_0000 => \&_op_jmp_AAaa8,
      0x5E00_0000_0000_0000 => \&_op_jsr_Aaa24,
      0x5F00_0000_0000_0000 => \&_op_jsr_AAaa8,
      0x6000_0000_0000_0000 => \&_op_bset_b_rn_rd,
      0x6100_0000_0000_0000 => \&_op_bnot_b_rn_rd,
      0x6200_0000_0000_0000 => \&_op_bclr_b_rn_rd,
      0x6300_0000_0000_0000 => \&_op_btst_b_rn_rd,
      0x6600_0000_0000_0000 => \&_op_and_w_rs_rd,
    },
  }, {
    mask => 0xFF00_FF0F_0000_0000,
    handler_for => {
      0x7E00_6300_0000_0000 => \&_op_btst_b_rn_Aaa8,
      0x7F00_6000_0000_0000 => \&_op_bset_b_rn_Aaa8,
      0x7F00_6100_0000_0000 => \&_op_bnot_b_rn_Aaa8,
      0x7F00_6200_0000_0000 => \&_op_bclr_b_rn_Aaa8,
    },
  }, {
    mask => 0xFF00_FF8F_0000_0000,
    handler_for => {
      0x7E00_7300_0000_0000 => \&_op_btst_b_xx3_Aaa8,
      0x7E00_7400_0000_0000 => \&_op_bor_b_xx3_Aaa8,
      0x7E00_7480_0000_0000 => \&_op_bior_b_xx3_Aaa8,
      0x7E00_7500_0000_0000 => \&_op_bxor_b_xx3_Aaa8,
      0x7E00_7580_0000_0000 => \&_op_bixor_b_xx3_Aaa8,
      0x7E00_7600_0000_0000 => \&_op_band_b_xx3_Aaa8,
      0x7E00_7680_0000_0000 => \&_op_biand_b_xx3_Aaa8,
      0x7E00_7700_0000_0000 => \&_op_bld_b_xx3_Aaa8,
      0x7E00_7780_0000_0000 => \&_op_bild_b_xx3_Aaa8,
      0x7F00_6700_0000_0000 => \&_op_bst_b_xx3_Aaa8,
      0x7F00_6780_0000_0000 => \&_op_bist_b_xx3_Aaa8,
      0x7F00_7000_0000_0000 => \&_op_bset_b_xx3_Aaa8,
      0x7F00_7100_0000_0000 => \&_op_bnot_b_xx3_Aaa8,
      0x7F00_7200_0000_0000 => \&_op_bclr_b_xx3_Aaa8,
    },
  }, {
    mask => 0xFF08_0000_0000_0000,
    handler_for => {
      0x5300_0000_0000_0000 => \&_op_divxu_w_rs_erd,
    },
  }, {
    mask => 0xFF80_0000_0000_0000,
    handler_for => {
      0x6700_0000_0000_0000 => \&_op_bst_b_xx3_rd,
      0x6780_0000_0000_0000 => \&_op_bist_b_xx3_rd,
      0x7000_0000_0000_0000 => \&_op_bset_b_xx3_rd,
      0x7100_0000_0000_0000 => \&_op_bnot_b_xx3_rd,
      0x7200_0000_0000_0000 => \&_op_bclr_b_xx3_rd,
      0x7300_0000_0000_0000 => \&_op_btst_b_xx3_rd,
      0x7400_0000_0000_0000 => \&_op_bor_b_xx3_rd,
      0x7480_0000_0000_0000 => \&_op_bior_b_xx3_rd,
      0x7500_0000_0000_0000 => \&_op_bxor_b_xx3_rd,
      0x7580_0000_0000_0000 => \&_op_bixor_b_xx3_rd,
      0x7600_0000_0000_0000 => \&_op_band_b_xx3_rd,
      0x7680_0000_0000_0000 => \&_op_biand_b_xx3_rd,
      0x7700_0000_0000_0000 => \&_op_bld_b_xx3_rd,
      0x7780_0000_0000_0000 => \&_op_bild_b_xx3_rd,
    },
  }, {
    mask => 0xFF88_0000_0000_0000,
    handler_for => {
      0x0A80_0000_0000_0000 => \&_op_add_l_ers_erd,
      0x1F80_0000_0000_0000 => \&_op_cmp_l_ers_erd,
    },
  }, {
    mask => 0xFF8F_0000_0000_0000,
    handler_for => {
      0x5900_0000_0000_0000 => \&_op_jmp_Aern,
      0x5D00_0000_0000_0000 => \&_op_jsr_Aern,
    },
  }, {
    mask => 0xFF8F_FF0F_0000_0000,
    handler_for => {
      0x7C00_6300_0000_0000 => \&_op_btst_b_rn_Aerd,
      0x7D00_6000_0000_0000 => \&_op_bset_b_rn_Aerd,
      0x7D00_6100_0000_0000 => \&_op_bnot_b_rn_Aerd,
      0x7D00_6200_0000_0000 => \&_op_bclr_b_rn_Aerd,
    },
  }, {
    mask => 0xFF8F_FF8F_0000_0000,
    handler_for => {
      0x7C00_7300_0000_0000 => \&_op_btst_b_xx3_Aerd,
      0x7C00_7400_0000_0000 => \&_op_bor_b_xx3_Aerd,
      0x7C00_7480_0000_0000 => \&_op_bior_b_xx3_Aerd,
      0x7C00_7500_0000_0000 => \&_op_bxor_b_xx3_Aerd,
      0x7C00_7580_0000_0000 => \&_op_bixor_b_xx3_Aerd,
      0x7C00_7600_0000_0000 => \&_op_band_b_xx3_Aerd,
      0x7C00_7680_0000_0000 => \&_op_biand_b_xx3_Aerd,
      0x7C00_7700_0000_0000 => \&_op_bld_b_xx3_Aerd,
      0x7C00_7780_0000_0000 => \&_op_bild_b_xx3_Aerd,
      0x7D00_6700_0000_0000 => \&_op_bst_b_xx3_Aerd,
      0x7D00_6780_0000_0000 => \&_op_bist_b_xx3_Aerd,
      0x7D00_7000_0000_0000 => \&_op_bset_b_xx3_Aerd,
      0x7D00_7100_0000_0000 => \&_op_bnot_b_xx3_Aerd,
      0x7D00_7200_0000_0000 => \&_op_bclr_b_xx3_Aerd,
    },
  }, {
    mask => 0xFFF0_0000_0000_0000,
    handler_for => {
      0x0300_0000_0000_0000 => \&_op_ldc_b_rs_ccr,
      0x0310_0000_0000_0000 => \&_op_ldc_b_rs_exr,
      0x0A00_0000_0000_0000 => \&_op_inc_b_rd,
      0x0B50_0000_0000_0000 => \&_op_inc_w_1_rd,
      0x0BD0_0000_0000_0000 => \&_op_inc_w_2_rd,
      0x0F00_0000_0000_0000 => \&_op_daa_b_rd,
      0x1750_0000_0000_0000 => \&_op_extu_w_rd,
      0x17D0_0000_0000_0000 => \&_op_exts_w_rd,
      0x1A00_0000_0000_0000 => \&_op_dec_b_rd,
      0x1B50_0000_0000_0000 => \&_op_dec_w_1_rd,
      0x1BD0_0000_0000_0000 => \&_op_dec_w_2_rd,
      0x1F00_0000_0000_0000 => \&_op_das_b_rd,
      0x7910_0000_0000_0000 => \&_op_add_w_xx16_rd,
      0x7920_0000_0000_0000 => \&_op_cmp_w_xx16_rd,
      0x7960_0000_0000_0000 => \&_op_and_w_xx16_rd,
    },
  }, {
    mask => 0xFFF8_0000_0000_0000,
    handler_for => {
      0x0B00_0000_0000_0000 => \&_op_adds_l_1_erd,
      0x0B70_0000_0000_0000 => \&_op_inc_l_1_erd,
      0x0B80_0000_0000_0000 => \&_op_adds_l_2_erd,
      0x0B90_0000_0000_0000 => \&_op_adds_l_4_erd,
      0x0BF0_0000_0000_0000 => \&_op_inc_l_2_erd,
      0x1770_0000_0000_0000 => \&_op_extu_l_erd,
      0x17F0_0000_0000_0000 => \&_op_exts_l_erd,
      0x1B70_0000_0000_0000 => \&_op_dec_l_1_erd,
      0x1BF0_0000_0000_0000 => \&_op_dec_l_2_erd,
      0x7A10_0000_0000_0000 => \&_op_add_l_xx32_erd,
      0x7A20_0000_0000_0000 => \&_op_cmp_l_xx32_erd,
      0x7A60_0000_0000_0000 => \&_op_and_l_xx32_erd,
    },
  }, {
    mask => 0xFFFF_0000_0000_0000,
    handler_for => {
      0x5800_0000_0000_0000 => \&_op_bcc_bra_d16,
      0x5810_0000_0000_0000 => \&_op_bcc_brn_d16,
      0x5820_0000_0000_0000 => \&_op_bcc_bhi_d16,
      0x5830_0000_0000_0000 => \&_op_bcc_bls_d16,
      0x5840_0000_0000_0000 => \&_op_bcc_bcc_d16,
      0x5850_0000_0000_0000 => \&_op_bcc_bcs_d16,
      0x5860_0000_0000_0000 => \&_op_bcc_bne_d16,
      0x5870_0000_0000_0000 => \&_op_bcc_beq_d16,
      0x5880_0000_0000_0000 => \&_op_bcc_bvc_d16,
      0x5890_0000_0000_0000 => \&_op_bcc_bvs_d16,
      0x58A0_0000_0000_0000 => \&_op_bcc_bpl_d16,
      0x58B0_0000_0000_0000 => \&_op_bcc_bmi_d16,
      0x58C0_0000_0000_0000 => \&_op_bcc_bge_d16,
      0x58D0_0000_0000_0000 => \&_op_bcc_blt_d16,
      0x58E0_0000_0000_0000 => \&_op_bcc_bgt_d16,
      0x58F0_0000_0000_0000 => \&_op_bcc_ble_d16,
      0x5C00_0000_0000_0000 => \&_op_bsr_d16,
    },
  }, {
    mask => 0xFFFF_0000_0000_FF0F,
    handler_for => {
      0x6A30_0000_0000_6300 => \&_op_btst_b_rn_Aaa32,
      0x6A38_0000_0000_6000 => \&_op_bset_b_rn_Aaa32,
      0x6a38_0000_0000_6100 => \&_op_bnot_b_rn_Aaa32,
      0x6A38_0000_0000_6200 => \&_op_bclr_b_rn_Aaa32,
    },
  }, {
    mask => 0xFFFF_0000_0000_FF8F,
    handler_for => {
      0x6A30_0000_0000_7300 => \&_op_btst_b_xx3_Aaa32,
      0x6A30_0000_0000_7400 => \&_op_bor_b_xx3_Aaa32,
      0x6A30_0000_0000_7480 => \&_op_bior_b_xx3_Aaa32,
      0x6A30_0000_0000_7500 => \&_op_bxor_b_xx3_Aaa32,
      0x6A30_0000_0000_7580 => \&_op_bixor_b_xx3_Aaa32,
      0x6A30_0000_0000_7600 => \&_op_band_b_xx3_Aaa32,
      0x6A30_0000_0000_7680 => \&_op_biand_b_xx3_Aaa32,
      0x6A30_0000_0000_7700 => \&_op_bld_b_xx3_Aaa32,
      0x6A30_0000_0000_7780 => \&_op_bild_b_xx3_Aaa32,
      0x6A38_0000_0000_6700 => \&_op_bst_b_xx3_Aaa32,
      0x6A38_0000_0000_6780 => \&_op_bist_b_xx3_Aaa32,
      0x6A38_0000_0000_7000 => \&_op_bset_b_xx3_Aaa32,
      0x6A38_0000_0000_7100 => \&_op_bnot_b_xx3_Aaa32,
      0x6A38_0000_0000_7200 => \&_op_bclr_b_xx3_Aaa32,
    },
  }, {
    mask => 0xFFFF_0000_FF0F_0000,
    handler_for => {
      0x6A10_0000_6300_0000 => \&_op_btst_b_rn_Aaa16,
      0x6A18_0000_6000_0000 => \&_op_bset_b_rn_Aaa16,
      0x6A18_0000_6100_0000 => \&_op_bnot_b_rn_Aaa16,
      0x6A18_0000_6200_0000 => \&_op_bclr_b_rn_Aaa16,
    },
  }, {
    mask => 0xFFFF_0000_FF8F_0000,
    handler_for => {
      0x6A10_0000_7300_0000 => \&_op_btst_b_xx3_Aaa16,
      0x6A10_0000_7400_0000 => \&_op_bor_b_xx3_Aaa16,
      0x6A10_0000_7480_0000 => \&_op_bior_b_xx3_Aaa16,
      0x6A10_0000_7500_0000 => \&_op_bxor_b_xx3_Aaa16,
      0x6A10_0000_7580_0000 => \&_op_bixor_b_xx3_Aaa16,
      0x6A10_0000_7600_0000 => \&_op_band_b_xx3_Aaa16,
      0x6A10_0000_7680_0000 => \&_op_biand_b_xx3_Aaa16,
      0x6A10_0000_7700_0000 => \&_op_bld_b_xx3_Aaa16,
      0x6A10_0000_7780_0000 => \&_op_bild_b_xx3_Aaa16,
      0x6A18_0000_6700_0000 => \&_op_bst_b_xx3_Aaa16,
      0x6A18_0000_6780_0000 => \&_op_bist_b_xx3_Aaa16,
      0x6A18_0000_7000_0000 => \&_op_bset_b_xx3_Aaa16,
      0x6A18_0000_7100_0000 => \&_op_bnot_b_xx3_Aaa16,
      0x6A18_0000_7200_0000 => \&_op_bclr_b_xx3_Aaa16,
    },
  }, {
    mask => 0xFFFF_FF00_0000_0000,
    handler_for => {
      0x0141_0600_0000_0000 => \&_op_andc_b_xx8_exr,
      0x0141_0700_0000_0000 => \&_op_ldc_b_xx8_exr,
      0x01D0_5100_0000_0000 => \&_op_divxs_b_rs_rd,
    },
  }, {
    mask => 0xFFFF_FF08_0000_0000,
    handler_for => {
      0x01D0_5300_0000_0000 => \&_op_divxs_w_rs_erd,
    },
  }, {
    mask => 0xFFFF_FF88_0000_0000,
    handler_for => {
      0x01F0_6600_0000_0000 => \&_op_and_l_ers_erd,
    },
  }, {
    mask => 0xFFFF_FF8F_0000_0000,
    handler_for => {
      0x0140_6900_0000_0000 => \&_op_ldc_w_Aers_ccr,
      0x0140_6D00_0000_0000 => \&_op_ldc_w_AersP_ccr,
      0x0140_6F00_0000_0000 => \&_op_ldc_w_AOPd16_ersCP_ccr,
      0x0141_6900_0000_0000 => \&_op_ldc_w_Aers_exr,
      0x0141_6D00_0000_0000 => \&_op_ldc_w_AersP_exr,
      0x0141_6F00_0000_0000 => \&_op_ldc_w_AOPd16_ersCP_exr,
    },
  }, {
    mask => 0xFFFF_FF8F_FFFF_0000,
    handler_for => {
      0x0140_7800_6B20_0000 => \&_op_ldc_w_AOPd32_ersCP_ccr,
      0x0141_7800_6B20_0000 => \&_op_ldc_w_AOPd32_ersCP_exr,
    },
  }, {
    mask => 0xFFFF_FFF8_0000_0000,
    handler_for => {
      0x0110_6D70_0000_0000 => \&_op_ldm_l_AspP_OPernMernP1CP,
      0x0120_6D70_0000_0000 => \&_op_ldm_l_AspP_OPernMernP2CP,
      0x0130_6D70_0000_0000 => \&_op_ldm_l_AspP_OPernMernP3CP,
    },
  }, {
    mask => 0xFFFF_FFFF_0000_0000,
    handler_for => {
      0x0140_6B00_0000_0000 => \&_op_ldc_w_Aaa16_ccr,
      0x0140_6B20_0000_0000 => \&_op_ldc_w_Aaa32_ccr,
      0x0141_6B00_0000_0000 => \&_op_ldc_w_Aaa16_exr,
      0x0141_6B20_0000_0000 => \&_op_ldc_w_Aaa32_exr,
      0x7B5C_598F_0000_0000 => \&_op_eepmov_b,
      0x7BD4_598F_0000_0000 => \&_op_eepmov_w,
    },
  });
}

sub _instruction {
  my $self = shift;

  my $bytes = $self->memory->read64($self->instruction_address);
  return $bytes if defined $bytes;

  die 'Unable to fetch instruction';
}

1;

=encoding utf8

=head1 NAME

CPU::Emulator::H8S::2246 - CPU emulator for the H8S/2246

=head1 SYNOPSIS

  use CPU::Emulator::H8S::2246;

  my $cpu = CPU::Emulator::H8S::2246->new;

=head1 DESCRIPTION

L<CPU::Emulator::H8S::2246> is an interpreting emulator for the H8S/2246 CPU,
as found in the Cybiko Classic.

=head1 ATTRIBUTES

L<CPU::Emulator::H8S::2246> implements the following attributes.

=head2 ccr

  my $ccr = $cpu->ccr;
  $cpu = $cpu->ccr(CPU::Emulator::H8S::2246::Register::ConditionCode->new);

Condition Code Register for the CPU, defaults to a
L<CPU::Emulator::H8S::2246::Register::ConditionCode> object.

=head2 instruction_address

  my $address = $cpu->instruction_address;
  $cpu = $cpu->instruction_address(0);

The address of the next instruction, defaults to 0.

=head2 memory

  my $memory = $cpu->memory;
  $memory = $cpu->memory(CPU::Emulator::H8S::2246::Memory->new);

Memory for the CPU, defaults to a L<CPU::Emulator::H8S::2246::Memory> object.

=head2 registers

  my $collection = $cpu->registers;
  $cpu = $cpu->registers(c(
    map { CPU::Emulator::H8S::2246::Register::General->new } 0 .. 7
  ));

General registers, defaults to a L<Mojo::Collection> of 8
L<CPU::Emulator::H8S::2246::Register::General> objects.

=head2 reset_address

  my $address = $cpu->reset_address;
  $cpu = $cpu->reset_address(0);

The address of the address of the first instruction, defaults to 0.

=head1 METHODS

L<CPU::Emulator::H8S::2246> inherits all methods from L<Mojo::Base> and
implements the following new ones.

=head2 reset

  $cpu = $cpu->reset;

Resets the CPU by setting the C<instruction_address> to the address stored at
C<reset_address>.

=head2 step

  $cpu = $cpu->step;

Fetches and processes the next instruction.

=head1 SEE ALSO

L<Mojolicious>.

=cut
