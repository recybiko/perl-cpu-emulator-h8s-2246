use Mojo::Base -strict;

use Test::More;

use CPU::Emulator::H8S::2246::Register::General;

my $register = CPU::Emulator::H8S::2246::Register::General->new;
isa_ok $register, 'CPU::Emulator::H8S::2246::Register::General';

done_testing;
