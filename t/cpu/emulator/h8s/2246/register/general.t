use Mojo::Base -strict;

use Test::More;

use CPU::Emulator::H8S::2246::Register::General;

my $register = CPU::Emulator::H8S::2246::Register::General->new;
isa_ok $register, 'CPU::Emulator::H8S::2246::Register::General';

is $register->read32, '0', 'right value';
is $register->write32(0xFFFF_FFFF)->read32, 0xFFFF_FFFF, 'right value';
is $register->write32(0)->read32, 0, 'right value';

done_testing;
