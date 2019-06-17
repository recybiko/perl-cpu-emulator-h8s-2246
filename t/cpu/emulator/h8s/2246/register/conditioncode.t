use Mojo::Base -strict;

use Test::More;

use CPU::Emulator::H8S::2246::Register::ConditionCode;

my $register = CPU::Emulator::H8S::2246::Register::ConditionCode->new;
isa_ok $register, 'CPU::Emulator::H8S::2246::Register::ConditionCode';

is $register->carry, 0, 'right value';
is $register->half_carry, 0, 'right value';
is $register->interrupt, 0, 'right value';
is $register->negative, 0, 'right value';
is $register->overflow, 0, 'right value';
is $register->user, 0, 'right value';
is $register->user_interrupt, 0, 'right value';
is $register->zero, 0, 'right value';

done_testing;
