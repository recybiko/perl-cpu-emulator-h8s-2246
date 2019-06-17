use Mojo::Base -strict;

use Test::More;

use CPU::Emulator::H8S::2246::Register::ConditionCode;

my $register = CPU::Emulator::H8S::2246::Register::ConditionCode->new;
isa_ok $register, 'CPU::Emulator::H8S::2246::Register::ConditionCode';

done_testing;
