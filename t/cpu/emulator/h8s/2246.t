use Mojo::Base -strict;

use Test::More;

use CPU::Emulator::H8S::2246;

my $cpu = CPU::Emulator::H8S::2246->new;
isa_ok $cpu, 'CPU::Emulator::H8S::2246';

isa_ok $cpu->registers, 'Mojo::Collection';
is $cpu->registers->size, 8, 'right value';
isa_ok $cpu->registers->[0], 'CPU::Emulator::H8S::2246::Register::General';

done_testing;
