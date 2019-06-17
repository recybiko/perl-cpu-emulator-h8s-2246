use Mojo::Base -strict;

use Test::More;

use CPU::Emulator::H8S::2246::Register::General;

my $register = CPU::Emulator::H8S::2246::Register::General->new;
isa_ok $register, 'CPU::Emulator::H8S::2246::Register::General';

is $register->read32, '0', 'right value';
is $register->write32(0xFFFF_FFFF)->read32, 0xFFFF_FFFF, 'right value';
is $register->write32(0)->read32, 0, 'right value';

is $register->write16h(0xFFFF)->read16h, 0xFFFF, 'right value';
is $register->read32, 0xFFFF_0000, 'right value';
is $register->write16l(0xFFFF)->read16l, 0xFFFF, 'right value';
is $register->read32, 0xFFFF_FFFF, 'right value';
is $register->write16h(0)->read16h, 0, 'right value';
is $register->read32, 0x0000_FFFF, 'right value';
is $register->write16l(0)->read16l, 0, 'right value';
is $register->read32, 0, 'right value';

is $register->write8h(0xFF)->read8h, 0xFF, 'right value';
is $register->read32, 0x0000_FF00, 'right value';
is $register->write8l(0xFF)->read8l, 0xFF, 'right value';
is $register->read32, 0x0000_FFFF, 'right value';
is $register->write8h(0)->read8h, 0, 'right value';
is $register->read32, 0x0000_00FF, 'right value';
is $register->write8l(0)->read8l, 0, 'right value';
is $register->read32, 0, 'right value';

done_testing;
