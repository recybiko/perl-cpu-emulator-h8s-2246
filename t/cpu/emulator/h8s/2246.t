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

done_testing;
